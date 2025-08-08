import 'dart:convert';
import '../data/repositories/refer_repo.dart';
import '../data/source/errors/check_status.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/referral_list_model.dart' as r;

class ReferralListController extends GetxController {
  static ReferralListController get to => Get.find<ReferralListController>();

  String referralLink = "";
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<int, bool> expandedState = {};

  void toggleExpansion(int id, bool isExpanded) {
    expandedState[id] = isExpanded;
    update();
  }

  Map<int, List<r.ReferralUser>> referralDataCache =
      {};

  Future<void> getInitialReferralList() async {
    _isLoading = true;
    update();
    http.Response response = await ReferRepo.getReferralList();
    _isLoading = false;
    referralDataCache.clear();
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        referralLink = data['data']['referral_link'].toString();

        final fetchedData = data['data']['referral_users'] as List<dynamic>;
        referralDataCache[0] = fetchedData
            .map(
                (item) => r.ReferralUser.fromJson(item as Map<String, dynamic>))
            .toList();
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      ApiStatus.checkStatus("error", "Something went wrong!");
    }
  }

  Future<void> fetchNestedReferrals(int userId) async {
    if (referralDataCache.containsKey(userId))
      return;
    http.Response response =
        await ReferRepo.getDirectReferUsers(userId: userId);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final fetchedData = data['data'] as List<dynamic>;
        referralDataCache[userId] = fetchedData
            .map(
                (item) => r.ReferralUser.fromJson(item as Map<String, dynamic>))
            .toList();
        update();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    getInitialReferralList();
  }
}
