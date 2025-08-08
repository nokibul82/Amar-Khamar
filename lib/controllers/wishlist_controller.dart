import 'dart:convert';
import 'product_manage_controller.dart';
import '../data/repositories/products_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/wishlist_model.dart' as w;
import '../data/source/errors/check_status.dart';

class WishlistController extends GetxController {
  static WishlistController get to => Get.find<WishlistController>();

  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<w.Datum> wishList = [];
  Future loadMore() async {
    if (!_isLoading &&
        !isLoadMore &&
        hasNextPage &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getProductList(
          page: page,
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
    wishList.clear();
    page = 1;
    isSearchTapped = true;
    hasNextPage = true;
    update();
  }

  Future getProductList(
      {required int page,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await ProductsRepo.getWishList(
        page: page);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    ProductManageController.to.wishListItem = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['data'];
        if (fetchedData.isNotEmpty) {
          wishList = [
            ...wishList,
            ...w.WishListModel.fromJson(data).data!.data!
          ];
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          // filter wishlist data
          if (wishList.isNotEmpty) {
            for (int i = 0; i < wishList.length; i += 1) {
              ProductManageController.to.wishListItem.add(wishList[i].id);
            }
          }
          update();
        } else {
          wishList = [
            ...wishList,
            ...w.WishListModel.fromJson(data).data!.data!
          ];
          hasNextPage = false;
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          // filter wishlist data
             if (wishList.isNotEmpty) {
            for (int i = 0; i < wishList.length; i += 1) {
              ProductManageController.to.wishListItem.add(wishList[i].id);
            }
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
      wishList = [];
    }
  }

  

  @override
  void onInit() {
    super.onInit();
    getProductList(
        page: page);
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    wishList.clear();
  }
}
