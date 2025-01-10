import 'package:result_dart/result_dart.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../../../core/infrastructure/models/conversation.dart';

abstract class IMessageRepository {
  Future<Result<PagingApiResponse<Conversation>, ApiError>> getListConversation(
      int page, int? limit);
  
  Future<Result<PagingApiResponse<Conversation>, ApiError>> searchConversation(
      int page, int? limit, String? keyword);
}
