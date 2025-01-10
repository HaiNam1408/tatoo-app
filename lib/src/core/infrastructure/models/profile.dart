import 'package:freezed_annotation/freezed_annotation.dart';

import 'attachment.dart';
import 'post.dart';
import 'tag.dart';

part 'profile.g.dart';
part 'profile.freezed.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const ProfileModel._();

  const factory ProfileModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'fullname') String? fullname,
    @JsonKey(name: 'name_store') String? storeName,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'authId') int? authId,
    @JsonKey(name: 'avarage_rating') double? averageRating,
    @JsonKey(name: 'avatar') Attachment? avatar,
    @JsonKey(name: 'background') Attachment? background,
    @JsonKey(name: 'address') AddressModel? address,
    @JsonKey(name: 'profile_tag') List<ProfileTagModel>? profileTag,
    @JsonKey(name: 'posts') List<PostModel>? posts,
    @JsonKey(name: 'roles') Roles? roles,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

@freezed
class AddressModel with _$AddressModel {
  const AddressModel._();

  const factory AddressModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'city') required String city,
    @JsonKey(name: 'district') String? district,
    @JsonKey(name: 'ward') String? ward,
    @JsonKey(name: 'street') required String street,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  String toCustomString() {
    final wardPart = ward != null && ward!.isNotEmpty ? ' $ward,' : '';
    final districtPart =
        district != null && district!.isNotEmpty ? ' $district,' : '';
    return '$street,$wardPart$districtPart $city';
  }
}

@freezed
class ProfileTagModel with _$ProfileTagModel {
  const factory ProfileTagModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'tags') required TagModel tags,
  }) = _ProfileTagModel;

  factory ProfileTagModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileTagModelFromJson(json);
}

@freezed
class Roles with _$Roles {
  const factory Roles({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'role') String? role,
  }) = _Roles;

  factory Roles.fromJson(Map<String, dynamic> json) => _$RolesFromJson(json);
}
