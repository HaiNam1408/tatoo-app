import 'dart:io';

import 'package:result_dart/result_dart.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../../../core/infrastructure/models/message.dart';

abstract class IConversationRepository {
  Future<Result<PagingApiResponse<Message>, ApiError>> getListMessage(
      int receiverId, int page, int? limit);
  Future<Result<Message, ApiError>> sendMessage(
      {required Message request, File? file});
  
  Future<Result<dynamic, ApiError>> deleteMessage({required int id});
}
