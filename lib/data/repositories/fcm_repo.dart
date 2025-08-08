import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class FcmRepo {
  static Future<http.Response> saveFcmToken({required String fcm_token}) async => await ApiClient.post(
        ENDPOINT_URL: AppConstants.saveFcmToken,fields: {"fcm_token": fcm_token});
}
