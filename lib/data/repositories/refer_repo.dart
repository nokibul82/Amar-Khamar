import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class ReferRepo {
  static Future<http.Response> getBonusList({
    required int  page,
    required String remark, 
    required String start_date, 
    required String end_date,
    required String type}) async => await ApiClient.get(
        ENDPOINT_URL: AppConstants.bonusList+  "?page=$page&type=$type&remark=$remark&start_date=$start_date&end_date=$end_date");

  static Future<http.Response> getReferralList() async => await ApiClient.get(
        ENDPOINT_URL: AppConstants.referralList);

  static Future<http.Response> getDirectReferUsers({
    required int  userId}) async => await ApiClient.get(
        ENDPOINT_URL: AppConstants.getDirectReferUsers+  "?userId=$userId");
}
