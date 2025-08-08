import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/order_list_model.dart' as o;
import '../data/models/order_details_model.dart' as od;
import '../data/repositories/products_repo.dart';
import '../data/source/errors/check_status.dart';
import '../views/screens/ecommerce/orders/order_details_screen.dart';

class MyOrderController extends GetxController {
  static MyOrderController get to => Get.find<MyOrderController>();

  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<o.Datum> orderList = [];
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getOrderList(page: page, isLoadMoreRunning: true);
      if (kDebugMode) {
        print("====================loaded from load more: " + page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    orderList.clear();
    page = 1;
    isSearchTapped = true;
    hasNextPage = true;
    update();
  }

  //-----------order list
  Future getOrderList(
      {required int page, bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await ProductsRepo.getOrderList(page: page);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['data'];
        if (fetchedData.isNotEmpty) {
          orderList = [...orderList, ...o.OrderListModel.fromJson(data).data!];
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          orderList = [...orderList, ...o.OrderListModel.fromJson(data).data!];
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
      orderList = [];
    }
  }

  //-----------order details
  List<od.OrderItem> orderDetailsList = [];
  int selectedIndex = -1;
  bool isGettingDetails = false;
  Future getOrderDetailsList({required String id}) async {
    isGettingDetails = true;
    update();
    http.Response response = await ProductsRepo.getOrderDetailsList(id: id);
    isGettingDetails = false;
    orderDetailsList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        orderDetailsList = [
          ...orderDetailsList,
          ...od.OrderDetialsModel.fromJson(data).data!.orderItems!
        ];
        isGettingDetails = false;
        Get.to(() => OrderDetailsScreen(id: id));

        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      orderDetailsList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    getOrderList(page: page);
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    orderList.clear();
  }
}
