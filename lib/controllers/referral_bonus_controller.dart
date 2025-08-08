import 'dart:convert';
import '../data/repositories/refer_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/referral_bonus_model.dart' as r;
import '../data/source/errors/check_status.dart';

class ReferralBonusController extends GetxController {
  static ReferralBonusController get to => Get.find<ReferralBonusController>();

  String currency_symbol = "";
  String base_currency = "";
  TextEditingController remarkEditingCtrlr = TextEditingController();
  TextEditingController typeEditingCtrlr = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController startDateTimeEditingCtrlr = TextEditingController();
  TextEditingController endDateTimeEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<r.Datum> bonusList = [];
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getBonusList(
          page: page,
          remark: remarkEditingCtrlr.text,
          type: typeEditingCtrlr.text,
          start_date: startDateTimeEditingCtrlr.text,
          end_date: endDateTimeEditingCtrlr.text,
          isLoadMoreRunning: true);
      if (kDebugMode) {
        print("====================loaded from load more: " + page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    bonusList.clear();
    page = 1;
    isSearchTapped = true;
    hasNextPage = true;
    update();
  }

  Future getBonusList(
      {required int page,
      required String remark,
      required String type,
      required String start_date,
      required String end_date,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await ReferRepo.getBonusList(
        page: page,
        type: type,
        remark: remark,
        start_date: start_date,
        end_date: end_date);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['data']['referrals'] == null ||
                data['data']['referrals']['data'] == null
            ? []
            : data['data']['referrals']['data'];
        if (fetchedData.isNotEmpty) {
          base_currency = data['data']['base_currency'];
          currency_symbol = data['data']['currency'];
          bonusList = [
            ...bonusList,
            ...r.ReferralBonusModel.fromJson(data).data!.referrals!.data!
          ];
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          bonusList = [
            ...bonusList,
            ...r.ReferralBonusModel.fromJson(data).data!.referrals!.data!
          ];
          hasNextPage = false;
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: true");
          }

          update();
        }
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      bonusList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    getBonusList(
        page: page, remark: '', start_date: '', end_date: '', type: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    bonusList.clear();
  }
}
