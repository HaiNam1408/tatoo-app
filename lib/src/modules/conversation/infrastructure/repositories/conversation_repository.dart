import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';
import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/message/message_client.dart';
import '../../../../core/infrastructure/models/message.dart';
import '../../domain/interfaces/conversation_repository_interface.dart';

@LazySingleton(as: IConversationRepository)
class ConversationRepository implements IConversationRepository {
  final MessageClient _client;

  ConversationRepository(this._client);

  @override
  Future<Result<PagingApiResponse<Message>, ApiError>> getListMessage(
      int receiverId, int page, int? limit) {
    var result =
        _client.fetchListMessage(receiverId, page, limit, CancelToken());
    return result.tryGet((response) => response);
  }
  
  @override
  Future<Result<Message, ApiError>> sendMessage({
    required Message request,
    File? file,
  }) async {
    final attachment =
        file != null ? await MultipartFile.fromFile(file.path) : null;
    final formData = FormData.fromMap({
      'receiver_id': request.receiverId,
      if (request.content != null) 'context': request.content!,
      if (attachment != null) 'files': attachment,
      if (request.tempId != null) 'temp_id': request.tempId
    });
    final result = _client.createMessage(formData, CancelToken());
    return result.tryGet((response) => response.data);
  }
  
  @override
  Future<Result<dynamic, ApiError>> deleteMessage({required int id}) {
    var result = _client.deleteMessage(id, CancelToken());
    return result.tryGet((response) => response);
  }

}
