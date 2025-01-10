import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../domain/interface/shop_infor_repository_interface.dart';
import '../model/rating_request.dart';
import '../service/shop_infor_api.dart';

@Injectable(as: IShopInforRepository)
class ShopInforRepository implements IShopInforRepository {
  final ShopInforApi _api;

  ShopInforRepository(this._api);

  @override
  Future<Result<StatusApiResponse, ApiError>> rating(
      double star, int shopId) async {
    return await _api
        .rating(RatingRequest(shopId: shopId, star: star))
        .tryGet((response) => response);
  }
}
