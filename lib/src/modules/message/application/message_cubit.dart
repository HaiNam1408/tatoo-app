import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/infrastructure/datasources/remote/socket/socket_manager.dart';
import '../../../core/infrastructure/models/conversation.dart';
import '../domain/interfaces/message_repository_interface.dart';
import 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final IMessageRepository messageRepository;
  MessageCubit(this.messageRepository)
      : super(const MessageState(isLoading: true)) {
    handleGetConversationList(1, itemsPerPage);
    listenToSocket();
    listener();
  }

  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  Timer? debounce;
  final int itemsPerPage = 10;
  String lastKeyword = '';

  void changeSearchMessage(String text) {
    lastKeyword = text;
    debounce?.cancel();
    if (text.isEmpty) {
      debounce = null;
      handleGetConversationList(1, itemsPerPage);
      return;
    }
    debounce = Timer(const Duration(milliseconds: 300), () {
      if (lastKeyword != text) return;

      emit(state.copyWith(isLoading: true, conversationList: state.messages));
      searchConversation(text, 1, itemsPerPage);
    });
  }

  Future<void> searchConversation(String? keyword, int page, int limit) async {
    if (keyword != lastKeyword) return;

    var result =
        await messageRepository.searchConversation(page, limit, keyword ?? '');
    result.fold((success) {
      if (keyword == lastKeyword) {
        emit(state.copyWith(
          totalPages: success.meta.totalPages,
          conversationList: page == 1
              ? success.data
              : [...state.conversationList, ...success.data],
          isLoading: false,
        ));
      }
    }, (failure) {
      if (keyword == lastKeyword) {
        emit(state.copyWith(isLoading: false, conversationList: []));
      }
    });
  }

  Future<void> handleGetConversationList(int page, int limit) async {
    if (page == 1) {
      emit(state.copyWith(isLoading: true, conversationList: state.messages));
    }

    final result = await messageRepository.getListConversation(page, limit);
    result.fold((success) {
      emit(state.copyWith(
          totalPages: success.meta.totalPages,
          conversationList: page == 1
              ? success.data
              : [...state.conversationList, ...success.data],
          isLoading: false));
    }, (failure) {
      emit(state.copyWith(isLoading: false));
    });
  }


  void fetchNextPage() {
    if (state.isFetchingMore || state.currentPage >= state.totalPages) return;

    emit(state.copyWith(
        isFetchingMore: true, currentPage: state.currentPage + 1));

    handleGetConversationList(state.currentPage, itemsPerPage).then((_) {
      emit(state.copyWith(isFetchingMore: false));
    });
  }

  void listener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchNextPage();
      }
    });
  }

  void listenToSocket() {
    SocketManager.instance.on('conversationUpdate', (msg) {
      Conversation newConversation = Conversation.fromJson(msg);
      if (!isClosed) {
        List<Conversation> temp = [...state.conversationList];
        temp.removeWhere((c) => c.id == newConversation.id);
        emit(state.copyWith(conversationList: [newConversation, ...temp]));
      }
    });

    SocketManager.instance.on('deleteMessage', (msg) {
      int deletedMessageId = msg['message_id'];
      int conversationId = msg['conversation_id'];

      if (!isClosed) {
        Conversation? conversation =
            state.conversationList.firstWhere((c) => c.id == conversationId);

        if (conversation.message?.id == deletedMessageId) {
          Conversation updatedConversation = conversation.copyWith(
              message: conversation.message?.copyWith(content: ''));

          List<Conversation> updatedList = state.conversationList
              .map((c) => c.id == conversationId ? updatedConversation : c)
              .toList();

          emit(state.copyWith(conversationList: updatedList));
        }
      }
    });

    @override
    Future<void> close() {
      scrollController.dispose();
      return super.close();
    }
  }
}
