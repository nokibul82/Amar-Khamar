import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class PlanHistoryRepo {
  static Future<http.Response> getPlanHistoryList({
    required int page,
    required String name,
    required String start_date,
    required String end_date,
  }) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.planHistory +
              "?page=$page&name=$name&start_date=$start_date&end_date=$end_date");

  static Future<http.Response> getPlanInvestmentList() async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.planInvestment);

  static Future<http.Response> PlanInvest(
          {required Map<String, dynamic> fields}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.planInvest, fields: fields);
}
