import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating_request.freezed.dart';
part 'rating_request.g.dart';

@freezed
class RatingRequest with _$RatingRequest  {
  const factory RatingRequest({
    @Default(0) double star,
    @Default(0) int shopId,  
  }) = _RatingRequest;

  factory RatingRequest.fromJson(Map<String, dynamic> json) =>
      _$RatingRequestFromJson(json);
}