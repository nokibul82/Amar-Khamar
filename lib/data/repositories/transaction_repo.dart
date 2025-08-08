import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class TransactionRepo {
  static Future<http.Response> getTransactionList({
    required int page,
    required String transaction_id,
    required String start_date,
    required String end_date,
    String? uuid,
  }) async => await ApiClient.get(
        ENDPOINT_URL: AppConstants.transactionUrl +
            "?page=$page&trx_id=$transaction_id&from_date=$start_date&to_date=$end_date");
}
