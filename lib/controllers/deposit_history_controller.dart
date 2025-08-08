import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/deposit_history_model.dart' as d;
import '../data/repositories/deposit_repo.dart';
import '../data/source/errors/check_status.dart';

class DepositHistoryController extends GetxController {
  static DepositHistoryController get to => Get.find<DepositHistoryController>();

  TextEditingController transactionIdEditingCtrlr = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController startDateTimeEditingCtrlr = TextEditingController();
  TextEditingController endDateTimeEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<d.Datum> depositHistoryList = [];
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getDepositHistoryList(
          page: page,
          transaction_id: transactionIdEditingCtrlr.text,
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
    depositHistoryList.clear();
    page = 1;
    isSearchTapped = true;
    hasNextPage = true;
    update();
  }

  Future getDepositHistoryList(
      {required int page,
      required String transaction_id,
      required String start_date,
      required String end_date,
      bool? isFromWallet = false,
      String? uuid,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await DepositRepo.getDepositHistoryList(
        uuid: uuid,
        page: page,
        transaction_id: transaction_id,
        start_date: start_date,
        end_date: end_date);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['data'];
        if (fetchedData.isNotEmpty) {
          depositHistoryList = [
            ...depositHistoryList,
            ...d.DepositHistoryModel.fromJson(data).data!
          ];
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          depositHistoryList = [
            ...depositHistoryList,
            ...d.DepositHistoryModel.fromJson(data).data!
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
      depositHistoryList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    getDepositHistoryList(
        page: page,
        transaction_id: '',
        start_date: '',
        end_date: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    depositHistoryList.clear();
  }
}


