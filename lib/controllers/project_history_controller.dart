import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/project_history_model.dart' as p;
import '../data/repositories/project_investment_repo.dart';
import '../data/source/errors/check_status.dart';

class ProjectHistoryController extends GetxController {
  static ProjectHistoryController get to =>
      Get.find<ProjectHistoryController>();

  TextEditingController nameEditingCtrlr = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController startDateTimeEditingCtrlr = TextEditingController();
  TextEditingController endDateTimeEditingCtrlr = TextEditingController();

  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<p.Datum> projectHistoryList = [];
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getProjectHistoryList(
          page: page,
          name: nameEditingCtrlr.text,
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
    projectHistoryList.clear();
    page = 1;
    isSearchTapped = true;
    hasNextPage = true;
    update();
  }

  Future getProjectHistoryList(
      {required int page,
      required String name,
      required String start_date,
      required String end_date,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await ProjectRepo.getProjectHistoryList(
        page: page, name: name, start_date: start_date, end_date: end_date);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['data'];
        if (fetchedData.isNotEmpty) {
          projectHistoryList = [
            ...projectHistoryList,
            ...p.ProjectHistoryModel.fromJson(data).data!
          ];
          _calculateTimeRemaining();

          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          projectHistoryList = [
            ...projectHistoryList,
            ...p.ProjectHistoryModel.fromJson(data).data!
          ];
          hasNextPage = false;
          _calculateTimeRemaining();

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
      projectHistoryList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    getProjectHistoryList(page: page, name: '', start_date: '', end_date: '');
    _startTimer();
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    projectHistoryList.clear();
    _timer.cancel();
  }

  late Timer _timer;
  List<String> timeRemaining = [];
  List<String> periodicTimerList = [];

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeRemaining = _calculateTimeRemaining();
      update();
    });
  }

  List<String> _calculateTimeRemaining() {
    periodicTimerList = [];
    filterPeriodic();
    update();
    return periodicTimerList;
  }

  filterPeriodic() {
    if (projectHistoryList.isNotEmpty) {
      for (int i = 0; i < projectHistoryList.length; i += 1) {
        if (projectHistoryList[i].nextReturn != null) {
          Duration remaining =
              DateTime.parse(projectHistoryList[i].nextReturn.toString())
                  .difference(DateTime.now());

          if (remaining.isNegative) {
            periodicTimerList.add("Time has passed");
          } else {
            int days = remaining.inDays;
            int hours = remaining.inHours.remainder(24);
            int minutes = remaining.inMinutes.remainder(60);
            int seconds = remaining.inSeconds.remainder(60);

            periodicTimerList.add('${days}d ${hours}h ${minutes}m ${seconds}s');
          }
        }
      }
    }
  }
}
