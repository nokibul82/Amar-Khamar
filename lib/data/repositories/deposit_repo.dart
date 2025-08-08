import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class DepositRepo {
  static Future<http.Response> getDepositHistoryList({
    required int page,
    required String transaction_id,
    required String start_date,
    required String end_date,
    String? uuid,
  }) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.depositHistoryUrl +
              "?page=$page&trx_id=$transaction_id&start_date=$start_date&end_date=$end_date");

  static Future<http.Response> getGateways() async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.gatewaysUrl);

  static Future<http.Response> manualPayment(
          {required String trxid,
          required Iterable<http.MultipartFile>? fileList,
          required Map<String, String> fields}) async =>
      await ApiClient.postMultipart(
          ENDPOINT_URL: AppConstants.manualPaymentUrl + "/$trxid",
          fields: fields,
          fileList: fileList);

  static Future<http.Response> webviewPayment({required String trxId}) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.webviewPayment + "?trx_id=$trxId");

  static Future<http.Response> addFundRequest(
          {required Map<String, String> fields}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.paymentRequest, fields: fields);

  static Future<http.Response> cardPayment(
          {required Map<String, String> fields}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.cardPayment, fields: fields);

  static Future<http.Response> onPaymentDone(
          {required String trxId}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.onPaymentDone+"?trx_id=$trxId");
}
