import 'package:freezed_annotation/freezed_annotation.dart';

import 'message.dart';
import 'profile.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'userId1') ProfileModel? userId1,
      @JsonKey(name: 'userId2') ProfileModel? userId2,
      @JsonKey(name: 'receiver_id') int? receiverId,
      @JsonKey(name: 'last_message_id') int? lastMessageId,
      @JsonKey(name: 'message') Message? message,
      @JsonKey(name: 'create_at') String? createdAt,
      @JsonKey(name: 'update_at') String? updatedAt}) = _Conversation;

  factory Conversation.fromJson(dynamic json) => _$ConversationFromJson(json);
}
