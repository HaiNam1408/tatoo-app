import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../model/rating_request.dart';

part 'shop_infor_api.g.dart';

@RestApi()
@injectable
abstract class ShopInforApi {
  @factoryMethod
  factory ShopInforApi(Dio dio) = _ShopInforApi;
  @POST('/user/v1/rating')
  Future<StatusApiResponse> rating(
    @Body() RatingRequest request,
  );
}
