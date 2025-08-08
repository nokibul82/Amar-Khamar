import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class ProductsRepo {
  static Future<http.Response> getProductList({
    required int page,
    List<String>? status,
    List<String>? category,
    required String min,
    required String max,
    required String sorting,
  }) async {
    Uri uri = Uri.parse(AppConstants.productList).replace(
      queryParameters: {
        "page": page.toString(),
        if (category == null || category.isEmpty) "category": "",
        if (category != null && category.isNotEmpty)
          for (int i = 0; i < category.length; i++) "category[$i]": "${category[i]}",
        "min": min.toString(),
        "max": max.toString(),
        "sorting": sorting,
        if (status == null || status.isEmpty) "status": "",
        if (status != null && status.isNotEmpty)
          for (int i = 0; i < status.length; i++) "status[$i]": "${status[i]}",
      },
    );
    return await ApiClient.get(ENDPOINT_URL: uri.toString());
  }

  static Future<http.Response> getWishList({required int page}) async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.wishlist + "?page=$page");

  static Future<http.Response> getProductDetails({required String id}) async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.productDetails + "/$id");

  static Future<http.Response> addToWishlist({required String id}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.addWishlist, fields: {"id": id});

  static Future<http.Response> addRating(
          {Map<String, dynamic>? fields}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.addRating, fields: fields);

  static Future<http.Response> couponApply(
          {Map<String, dynamic>? fields}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.couponApply, fields: fields);

  static Future<http.Response> getOrderList({required int page}) async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.orders + "?page=$page");

  static Future<http.Response> getOrderDetailsList(
          {required String id}) async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.orderDetails + "/$id");

  static Future<http.Response> getAreaList() async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.areaList);

  static Future<http.Response> createOrder(
          {Map<String, dynamic>? fields}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.createOrder, fields: fields);

  static Future<http.Response> makeOrderPayment(
          {Map<String, dynamic>? fields}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.makeOrderPayment, fields: fields);
}
