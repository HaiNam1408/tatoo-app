import '../../../core/infrastructure/models/message.dart';

class ConversationState {
  final bool isLoading;
  final List<Message> messageList;
  final String? error;
  final int currentPage;
  final int totalPages;
  final bool isFetchingMore;

  List<Message> get messages => List.generate(
        10,
        (index) => Message(
            id: index + 1,
            senderId: index % 2 == 0 ? 1 : 2,
            receiverId: index % 2 == 0 ? 2 : 1,
            content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
            createdAt: '2022-01-01T00:00:00.000Z'),
      );

  const ConversationState({
    this.isLoading = true,
    this.messageList = const [],
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.isFetchingMore = false,
  });

  ConversationState copyWith({
    bool? isLoading,
    String? error,
      List<Message>? messageList,
      int? currentPage,
      int? totalPages,
      bool? isFetchingMore
  }) {
    return ConversationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
        messageList: messageList ?? this.messageList,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        isFetchingMore: isFetchingMore ?? this.isFetchingMore
    );
  }
}
