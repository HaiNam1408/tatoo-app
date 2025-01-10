// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_picker/gallery_picker.dart';
import 'package:toastification/toastification.dart';
import '../../../common/extensions/optional_x.dart';
import '../../../common/utils/show_toast.dart';
import '../../../core/infrastructure/datasources/remote/socket/socket_manager.dart';
import '../../../core/infrastructure/models/attachment.dart';
import '../../../core/infrastructure/models/message.dart';
import '../domain/interfaces/conversation_repository_interface.dart';
import '../presentation/widgets/message_image_picker.dart';
import 'conversation_state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final IConversationRepository conversationRepository;
  final int receiverId;
  ConversationCubit(this.conversationRepository, this.receiverId)
      : super(const ConversationState(isLoading: true)) {
    handleGetMessageList(receiverId, 1, itemsPerPage);
    listener();
    listenToSocket();
  }

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final int itemsPerPage = 10;

  Future<void> handleGetMessageList(
      int receiverId, int page, int? limit) async {
    if (page == 1) emit(state.copyWith(messageList: state.messages));
    var result =
        await conversationRepository.getListMessage(receiverId, page, limit);
    result.fold((success) {
      emit(state.copyWith(
        isLoading: false,
        totalPages: success.meta.totalPages,
        messageList:
            page == 1 ? success.data : [...state.messageList, ...success.data],
      ));
    }, (failure) {
      emit(state.copyWith(isLoading: false, messageList: []));
    });
  }

  void fetchNextPage() {
    if (state.isFetchingMore || state.currentPage >= state.totalPages) return;

    emit(state.copyWith(
        isFetchingMore: true, currentPage: state.currentPage + 1));

    handleGetMessageList(receiverId, state.currentPage, itemsPerPage).then((_) {
      emit(state.copyWith(isFetchingMore: false));
    });
  }

  Future<void> sendMessage(BuildContext context) async {
    if (messageController.text.isEmpty) return;
    Message request = Message(
        receiverId: receiverId,
        content: messageController.text,
        createdAt: DateTime.now().toIso8601String(),
        tempId: DateTime.now().toIso8601String() +
            Random().nextInt(1000000).toRadixString(16),
        attachments: []);
    emit(state.copyWith(messageList: [request, ...state.messageList]));
    var result = await conversationRepository.sendMessage(request: request);
    result.fold((success) {
      messageController.clear();
    }, (failure) {
      CustomToast.show(
          context: context,
          message: 'Có lỗi xảy ra, vui lòng thử lại',
          type: ToastificationType.error);
      messageController.clear();
    });
  }

  Future<void> sendAttachment(File? file) async {
    if (file == null) return;
    Message request = Message(
        receiverId: receiverId,
        createdAt: DateTime.now().toIso8601String(),
        tempId: DateTime.now().toIso8601String() +
            Random().nextInt(1000000).toRadixString(16),
        attachments: [Attachment(filePath: file.path)]);
    emit(state.copyWith(messageList: [request, ...state.messageList]));
    var result =
        await conversationRepository.sendMessage(request: request, file: file);
    result.fold((success) {
      // emit(state.copyWith(messageList: [success, ...state.messageList]));
    }, (failure) {});
  }

  void updateMessageFromSocket(Message message) {
    emit(state.copyWith(messageList: [message, ...state.messageList]));
  }

  Future<void> selectAttachment(BuildContext context) async {
    GalleryMedia? allMedia = await GalleryPicker.collectGallery();
    if (allMedia != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return MessageImagePicker(
              allMedia: allMedia, onSendAttachment: sendAttachment);
        },
      );
    }
  }

  Future<void> deleteMessage(int id) async {
    var result = await conversationRepository.deleteMessage(id: id);
    result.fold((success) {
      final updatedMessages = state.messageList.map((message) {
        if (message.id == id) {
          return message.copyWith(content: '');
        }
        return message;
      }).toList();
      emit(state.copyWith(messageList: updatedMessages));
    }, (failure) {
      debugPrint('Failed to delete message: $failure');
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
    SocketManager.instance.on('message', (msg) async {
      Message newMessage = Message.fromJson(msg);
      if (!isClosed) {
        Message? tempMessage;
        if (newMessage.receiverId == receiverId) {
          tempMessage = state.messageList
              .firstWhere((m) => m.tempId == newMessage.tempId);
        }
        if (tempMessage.isNotNull) {
          List<Message> temp = state.messageList
              .map((m) => m.tempId != newMessage.tempId ? m : newMessage)
              .toList();
          emit(state.copyWith(messageList: temp));
        } else {
          emit(state.copyWith(messageList: [newMessage, ...state.messageList]));
        }
      }
    });

    SocketManager.instance.on('deleteMessage', (msg) {
      int deletedMessageId = msg['message_id'];
      if (!isClosed) {
        Message? message =
            state.messageList.firstWhere((m) => m.id == deletedMessageId);
        if (message.isNotNull) {
          Message newMessage = Message(
              content: '',
              id: message.id,
              attachments: message.attachments,
              createdAt: message.createdAt,
              conversationId: message.conversationId,
              senderId: message.senderId,
              receiverId: message.receiverId);
          List<Message> temp = state.messageList
              .map((m) => m.id == message.id ? newMessage : m)
              .toList();
          emit(state.copyWith(messageList: temp));
        }
      }
    });
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    messageController.dispose();
    return super.close();
  }
}
