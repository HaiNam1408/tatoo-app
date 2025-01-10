import 'package:freezed_annotation/freezed_annotation.dart';

part 'meta.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Meta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Meta({
    @JsonKey(name: 'total') required this.total,
    @JsonKey(name: 'page') required this.page,
    @JsonKey(name: 'limit') required this.limit,
    @JsonKey(name: 'totalPages') required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
