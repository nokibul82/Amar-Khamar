import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class ProjectRepo {
  static Future<http.Response> getProjectHistoryList({
    required int page,
    required String name,
    required String start_date,
    required String end_date,
  }) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.projectHistory +
              "?page=$page&name=$name&start_date=$start_date&end_date=$end_date");

  static Future<http.Response> getProjectList(
  ) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.projectList);

           static Future<http.Response> projectInvest(
          {required Map<String, dynamic> fields}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.projectInvest, fields: fields);
}
