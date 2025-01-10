
	
import '../../../core/infrastructure/models/attachment.dart';
import '../../../core/infrastructure/models/conversation.dart';
import '../../../core/infrastructure/models/message.dart';
import '../../../core/infrastructure/models/profile.dart';

class MessageState {
	final bool isLoading;
  final List<Conversation> conversationList;
	final String? error;
  final int currentPage;
  final int totalPages;
  final bool isFetchingMore;

  List<Conversation> get messages => List.generate(
        6,
        (index) => Conversation(
          id: index + 1,
          message: Message(
              id: index + 1,
              content: 'Lorem ipsum dolor sit amet met ipsum dolor sit amet',
              createdAt: '2022-08-12T12:30:00.000Z'),
          receiverId: index + 2,
          userId1: ProfileModel(
              id: index + 1,
              fullname: 'Nguyen Van A',
              avatar:
                  const Attachment(filePath: 'https://picsum.photos/100/100')),
          userId2: ProfileModel(
              id: index + 2,
              fullname: 'Nguyen Van B',
              avatar:
                  const Attachment(filePath: 'https://picsum.photos/100/100')),
        ),
      );
	  
	const MessageState({
    this.isLoading = true,
      this.conversationList = const [],
		this.error,
      this.currentPage = 1,
      this.totalPages = 1,
      this.isFetchingMore = false
	});
	  
	MessageState copyWith({
		bool? isLoading,
		String? error,
      List<Conversation>? conversationList,
      int? currentPage,
      int? totalPages,
      bool? isFetchingMore
	}) {
		return MessageState(
			isLoading: isLoading ?? this.isLoading,
			error: error ?? this.error,
        conversationList: conversationList ?? this.conversationList,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        isFetchingMore: isFetchingMore ?? this.isFetchingMore
		);
	}
}
