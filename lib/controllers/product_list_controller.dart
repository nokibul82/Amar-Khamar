import 'dart:convert';
import 'product_manage_controller.dart';
import '../data/repositories/products_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../data/models/products_model.dart' as p;
import '../data/models/product_details_model.dart' as details;
import '../data/source/errors/check_status.dart';
import '../views/screens/ecommerce/products/product_details_screen.dart';

class ProductListController extends GetxController {
  static ProductListController get to => Get.find<ProductListController>();

  TextEditingController searchEditingCtrlr = TextEditingController();
  TextEditingController startDateTimeEditingCtrlr = TextEditingController();
  TextEditingController endDateTimeEditingCtrlr = TextEditingController();

  int selectedTabIndex = 0;
  int quantity = 1;
  bool isGridView = true;

  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<p.Category> categoryList = [];
  List<p.Product> productList = [];
  List<p.Product> searchedProductList = [];
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
          min: "",
          max: "",
          sorting: "",
          category: selectedCategoryList,
          status: selectedAvailableList,
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
    productList.clear();
    page = 1;
    isSearchTapped = true;
    hasNextPage = true;
    if(isFromOnRefreshIndicator ==true){
      selectedAvailableList.clear();
    selectedCategoryList.clear();
    priceRange = SfRangeValues(0, 5000);
    }
    update();
  }

  // product list
  Future getProductList(
      {required int page,
      List<String>? status,
      List<String>? category,
      required String min,
      required String max,
      required String sorting,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await ProductsRepo.getProductList(
        page: page,
        min: min,
        max: max,
        status: status,
        category: category,
        sorting: sorting);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    ProductManageController.to.wishListItem = [];
    categoryList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        categoryList = [
          ...categoryList,
          ...p.ProductsModel.fromJson(data).data!.categories!
        ];
        final fetchedData = data['data']['products'];
        if (fetchedData.isNotEmpty) {
          productList = [
            ...productList,
            ...p.ProductsModel.fromJson(data).data!.products!
          ];
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          // filter wishlist data
          if (productList.isNotEmpty) {
            var product = productList.where((e) => e.wishlist == true).toList();
            for (int i = 0; i < product.length; i += 1) {
              ProductManageController.to.wishListItem.add(product[i].id);
            }
          }
          update();
        } else {
          productList = [
            ...productList,
            ...p.ProductsModel.fromJson(data).data!.products!
          ];
          hasNextPage = false;
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          // filter wishlist data
          if (productList.isNotEmpty) {
            var product = productList.where((e) => e.wishlist == true).toList();
            for (int i = 0; i < product.length; i += 1) {
              ProductManageController.to.wishListItem.add(product[i].id);
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
      productList = [];
    }
  }
  
  // search product manually
  bool isSearching = false;
  onSearchChanged(String query) {
    searchedProductList = productList
        .where((item) => item.details!.title
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
    if (query.isEmpty) {
      isSearching = false;
    } else if (query.isNotEmpty) {
      isSearching = true;
    }
    update();
  }

  //------------product search by category
  SfRangeValues priceRange = SfRangeValues(0, 5000);
  List<String> selectedAvailableList = [];
  List<String> selectedCategoryList = [];

  addCatgory(item) {
    if (selectedCategoryList.contains(item)) {
      selectedCategoryList.remove(item);
    } else {
      selectedCategoryList.add(item);
    }
    update();
  }

  addAvalilable(item) {
    if (selectedAvailableList.contains(item)) {
      selectedAvailableList.remove(item);
    } else {
      selectedAvailableList.add(item);
    }
    update();
  }

  List<Availability> availabilityList = [
    Availability(name: "In Stock", slug: "available"),
    Availability(name: "Out of Stock", slug: "Stock Out"),
  ];

  // product details
  List<details.ProductModel> productDetails = [];
  int selectedDetailsIndex = -1;
  Future getProductDetails({required String id}) async {
    _isLoading = true;
    update();
    http.Response response = await ProductsRepo.getProductDetails(id: id);
    _isLoading = false;
    ProductManageController.to.wishListItem = [];
    productDetails = [];
    update();

    if (response.statusCode == 200) {
      var datas = jsonDecode(response.body);
      if (datas['status'] == 'success') {
        productDetails.add(details.ProductModel.fromJson(datas));
        _isLoading = false;
        // filter wishlist data
        if (productDetails.isNotEmpty) {
          var data = productDetails[0].data;
          if (productDetails[0].data!.wishlist == true) {
            ProductManageController.to.wishListItem.add(data!.id);
          }
          Get.to(() => ProductDetailsScreen(
                data: data,
                isWishListIcon: false,
                id: data!.id.toString(),
                img: data.thumbnailImage.toString(),
                title: data.details == null ? "" : data.details!.title,
                description:
                    data.details == null ? "" : data.details!.description,
                price: data.price.toString(),
                rating: data.avgRating.toString(),
                quantity: data.quantity.toString() +
                    " " +
                    data.quantityUnit.toString(),
                review: data.reviews,
              ));
        }

        update();
      } else {
        ApiStatus.checkStatus(datas['status'], datas['data']);
      }
    } else {
      productList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    getProductList(
      page: page,
      min: "",
      max: "",
      sorting: "",
      category: selectedCategoryList,
      status: selectedAvailableList,
    );
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    productList.clear();
  }
}

class Availability {
  final String name;
  final String slug;
  Availability({required this.name, required this.slug});
}
