import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../../models/conversation.dart';
import '../../../../../models/message.dart';
import '../../base/api_response.dart';
part 'message_client.g.dart';

@RestApi()
@injectable
abstract class MessageClient {
  @factoryMethod
  factory MessageClient(Dio dio) = _MessageClient;

  @GET('/user/v1/message/get-list-conversation-user')
  Future<PagingApiResponse<Conversation>> fetchListConversation(
      @Query('page') int page,
      @Query('limit') int? limit,
      @CancelRequest() CancelToken? cancelToken);

  @GET('/user/v1/message/search')
  Future<PagingApiResponse<Conversation>> fetchSearchConversation(
      @Query('page') int page,
      @Query('limit') int? limit,
      @Query('keyword') String? keyword,
      @CancelRequest() CancelToken? cancelToken);
  
  @GET('/user/v1/message/get-message-user')
  Future<PagingApiResponse<Message>> fetchListMessage(
      @Query('receiver_id') int receiverId,
      @Query('page') int page,
      @Query('limit') int? limit,
      @CancelRequest() CancelToken? cancelToken);

  @POST('/user/v1/message/create-message')
  @MultiPart()
  Future<SingleApiResponse<Message>> createMessage(
    @Body() FormData formData,
    @CancelRequest() CancelToken? cancelToken,
  );
  
  @DELETE('/user/v1/message/delete-message/{id}')
  Future<SingleApiResponse> deleteMessage(
    @Path('id') int id,
    @CancelRequest() CancelToken? cancelToken,
  );
}
