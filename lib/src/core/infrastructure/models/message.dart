import 'package:freezed_annotation/freezed_annotation.dart';

import 'attachment.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'sender_id') int? senderId,
      @JsonKey(name: 'receiver_id') int? receiverId,
      @JsonKey(name: 'conversation_id') int? conversationId,
      @JsonKey(name: 'temp_id') String? tempId,
      @JsonKey(name: 'is_read') bool? isRead,
      @JsonKey(name: 'context') String? content,
      @JsonKey(name: 'create_at') String? createdAt,
      @JsonKey(name: 'attachments') List<Attachment>? attachments}) = _Message;

  factory Message.fromJson(dynamic json) => _$MessageFromJson(json);
}
