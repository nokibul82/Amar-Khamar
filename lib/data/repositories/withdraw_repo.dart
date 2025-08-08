import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class WithdrawRepo {
  static Future<http.Response> getWithdrawHistoryList({
    required int page,
    required String transaction_id,
    required String start_date,
    required String end_date,
  }) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.withdrawHistory +
              "?page=$page&trx_id=$transaction_id&start_date=$start_date&end_date=$end_date");

  static Future<http.Response> getPayouts() async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.payoutUrl);

  static Future<http.Response> getWithdrawDetails({required String trxId}) async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.withdrawDetails+"/$trxId");

  static Future<http.Response> getBankFromBank(
          {required String bankName}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.getBankFromBankUrl,
          fields: {"bankName": bankName});

  static Future<http.Response> getBankFromCurrency(
          {required String currencyCode}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.getBankFromCurrencyUrl,
          fields: {"currencyCode": currencyCode});

  static Future<http.Response> payoutInitUrl(
          {required Map<String, String> fields}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.payoutInitUrl, fields: fields);

  static Future<http.Response> payoutSubmit(
          {required Iterable<MultipartFile>? fileList,
          required Map<String, String> fields,
          required String trx_id}) async =>
      await ApiClient.postMultipart(
          ENDPOINT_URL: AppConstants.payoutSubmitUrl + "/$trx_id",
          fields: fields,
          fileList: fileList);

  static Future<http.Response> flutterwaveSubmit(
          {required Map<String, String> fields,
          required String trx_id}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.flutterwaveSubmitUrl + "/$trx_id",
          fields: fields);

  static Future<http.Response> paystackSubmit(
          {required Map<String, String> fields,
          required String trx_id}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.paystackSubmitUrl + "/$trx_id",
          fields: fields);
}
