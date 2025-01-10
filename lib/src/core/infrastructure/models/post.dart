import 'package:freezed_annotation/freezed_annotation.dart';

import 'attachment.dart';
part 'post.g.dart';
part 'post.freezed.dart';

@freezed
class PostModel with _$PostModel {
  const PostModel._();

  const factory PostModel({
    @JsonKey(name: 'id') required int? id,
    @JsonKey(name: 'content') required String? content,
    @JsonKey(name: 'post_image') required Attachment? postImage,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
