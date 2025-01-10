import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';
import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/message/message_client.dart';
import '../../../../core/infrastructure/models/conversation.dart';
import '../../domain/interfaces/message_repository_interface.dart';

@LazySingleton(as: IMessageRepository)
class MessageRepository implements IMessageRepository {
  final MessageClient _client;

  MessageRepository(this._client);

  @override
  Future<Result<PagingApiResponse<Conversation>, ApiError>> getListConversation(
      int page, int? limit) {
    var result = _client.fetchListConversation(page, limit, CancelToken());
    return result.tryGet((response) => response);
  }
  
  @override
  Future<Result<PagingApiResponse<Conversation>, ApiError>> searchConversation(
      int page, int? limit, String? keyword) {
    var result =
        _client.fetchSearchConversation(page, limit, keyword, CancelToken());
    return result.tryGet((response) => response);
  }
}
