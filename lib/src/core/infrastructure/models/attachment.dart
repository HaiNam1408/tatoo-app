import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment.freezed.dart';
part 'attachment.g.dart';

@freezed
class Attachment with _$Attachment {
  const factory Attachment({
    @JsonKey(name: 'fileName') String? fileName,
    @JsonKey(name: 'filePath') String? filePath,
    @JsonKey(name: 'type') String? fileType,
  }) = _Attachment;

  factory Attachment.fromJson(dynamic json) => _$AttachmentFromJson(json);
}
