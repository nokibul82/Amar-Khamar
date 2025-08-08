import 'dart:async';
import 'dart:convert';
import 'product_list_controller.dart';
import '../data/repositories/products_repo.dart';
import '../data/source/errors/check_status.dart';
import '../utils/services/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/app_colors.dart';
import '../data/models/add_ratings_model.dart';
import '../data/models/create_order_model.dart';
import '../data/models/products_model.dart' as p;
import '../data/models/area_model.dart' as area;
import '../routes/routes_name.dart';
import '../utils/services/localstorage/addCart_model.dart';
import '../utils/services/localstorage/init_hive.dart';
import 'deposit_controller.dart';

class ProductManageController extends GetxController {
  static ProductManageController get to => Get.find<ProductManageController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //---------------add to wishlist------------------------//
  dynamic isAddedToWishlist = null;
  List<int> wishListItem = [];

  Future addToWishlist({required String id}) async {
    _isLoading = true;
    update();
    http.Response response = await ProductsRepo.addToWishlist(id: id);
    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ApiStatus.checkStatus(data['status'], data['data']);
      if (data['status'] == "success") {
        if (data['data'].toString().toLowerCase().contains("added")) {
          isAddedToWishlist = true;
          update();
        } else if (data['data'].toString().toLowerCase().contains("removed")) {
          isAddedToWishlist = false;
          update();
        }
      }
    } else {
      Helpers.showSnackBar(msg: "Something went wrong!");
    }
  }

  Future addToLocalWishlist(p.Product data) async {
    await addToWishlist(id: data.id.toString());
    if (isAddedToWishlist != null && wishListItem.contains(data.id)) {
      wishListItem.remove(data.id);
    } else if (isAddedToWishlist != null && !wishListItem.contains(data.id)) {
      wishListItem.add(data.id);
    }
    update();
  }

  //---------------add rating------------------------//
  TextEditingController reviewEditingCtrlr = TextEditingController();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  Future addRating({Map<String, dynamic>? fields}) async {
    _isLoading = true;
    update();
    http.Response response = await ProductsRepo.addRating(fields: fields);
    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      ApiStatus.checkStatus(data['status'], data['data']);
      if (data['status'] == "success") {
        rating = 0.00;
        reviewEditingCtrlr.clear();
        nameEditingController.clear();
        emailEditingController.clear();
        update();
      }
    } else {
      Helpers.showSnackBar(msg: "Something went wrong!");
    }
  }

  double rating = 0.00;
  onRatingUpdate(v) {
    rating = v;
    update();
  }

  onReviwSubmit({required String productId}) async {
    if (rating == 0.00) {
      Helpers.showSnackBar(msg: "Please provide a rating to proceed.");
    } else if (reviewEditingCtrlr.text.isEmpty) {
      Helpers.showSnackBar(msg: "Review field is required");
    } else if (nameEditingController.text.isEmpty) {
      Helpers.showSnackBar(msg: "Name field is required");
    } else if (emailEditingController.text.isEmpty) {
      Helpers.showSnackBar(msg: "Email field is required");
    } else {
      await addRating(
        fields: AddRating(
          productId: productId,
          rating: "$rating",
          massage: "${reviewEditingCtrlr.text}",
          email: "${emailEditingController.text}",
          name: "${nameEditingController.text}",
        ).toJson(),
      );
    }
    update();
  }

  Widget ratingExpression() {
    if (rating == 0.00) {
      return SizedBox();
    } else if (rating >= 1 && rating <= 1.5) {
      return Icon(
        Icons.sentiment_dissatisfied_sharp,
        size: 30.h,
      );
    } else if (rating >= 2 && rating <= 2.5) {
      return Icon(
        Icons.mood_bad,
        size: 30.h,
      );
    } else if (rating >= 3 && rating <= 3.5) {
      return Icon(
        Icons.sentiment_dissatisfied,
        size: 30.h,
      );
    } else if (rating >= 4 && rating <= 4.5) {
      return Icon(
        Icons.sentiment_satisfied_alt,
        size: 30.h,
      );
    } else if (rating == 5) {
      return Icon(
        Icons.mood,
        size: 30.h,
      );
    }
    update();
    return SizedBox();
  }

  //--------------addToCart------------------------//
  int selectedIndex = -1;
  int quantity = 1;
  Future addToCart(p.Product data,
      {bool? isQuantityUpdatedInProductDetailsPage = false}) async {
    try {
      String key = 'key_${data.id.toString()}';

      if (storedLocalCartItem.containsKey(key)) {
        AddCartModel existingCartData = storedLocalCartItem.get(key);
        int updatedQuantity = existingCartData.quantity;

        if (isQuantityUpdatedInProductDetailsPage == true) {
          updatedQuantity += ProductListController.to.quantity;
        } else if (isQuantityUpdatedInProductDetailsPage == false) {
          updatedQuantity += 1;
        }

        final updatedItem =
            existingCartData.copyWith(quantity: updatedQuantity);
        storedLocalCartItem.put(key, updatedItem);
      } else {
        var cartItem = AddCartModel(
          id: data.id,
          img: data.thumbnailImage,
          title: data.details == null ? "" : data.details!.title,
          avgRating: data.avgRating.toString(),
          price: data.price.toString(),
          quantityUnit: data.quantity.toString() + " " + data.quantityUnit,
          quantity: isQuantityUpdatedInProductDetailsPage == true
              ? ProductListController.to.quantity
              : 1,
        );
        storedLocalCartItem.put(key, cartItem);
      }
      Helpers.showToast(
        msg: "Added to the cart",
        bgColor: AppColors.whiteColor,
        textColor: AppColors.blackColor,
      );
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  Future removeFromCart(String key) async {
    try {
      storedLocalCartItem.delete(key);
      Helpers.showToast(
        msg: "Item removed from the cart",
        bgColor: AppColors.whiteColor,
        textColor: AppColors.blackColor,
      );
      update();
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  Future manageQuantity(int i, dynamic key, {bool? isDecrease = false}) async {
    try {
      selectedIndex = i;
      if (selectedIndex == i) {
        AddCartModel existingCartData = storedLocalCartItem.get(key);
        int updatedQuantity = existingCartData.quantity;
        // increase quantity
        if (isDecrease == false) {
          updatedQuantity += 1;
        }
        // decrease quantity
        else if (isDecrease == true) {
          if (existingCartData.quantity > 1) {
            updatedQuantity -= 1;
          }
        }

        final updatedData =
            existingCartData.copyWith(quantity: updatedQuantity);
        await storedLocalCartItem.put(key, updatedData);
      }
      update();
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  // calculate amount for checkout page
  String subTotal = "0.00";
  String discount = "0.00";
  String total = "0.00";
  double itemPrice = 0.00;
  int totalQuantity = 0;
  // for checking delivery charge based on quantity in checkout page
  int storedTotalQuantity = 0;
  Future calculateAmount() async {
    try {
      double totalCalculatedAmount = 0.00;
      storedTotalQuantity = 0;
      cartItems = [];
      if (storedLocalCartItem != null && storedLocalCartItem.isNotEmpty) {
        for (int i = 0; i < storedLocalCartItem.length; i += 1) {
          AddCartModel data = await storedLocalCartItem.getAt(i);
          itemPrice = await double.parse(data.price);
          totalQuantity = await data.quantity;
          storedTotalQuantity += await data.quantity;
          totalCalculatedAmount += await (totalQuantity * itemPrice);
          subTotal = totalCalculatedAmount.toStringAsFixed(2);
          total = (totalCalculatedAmount - double.parse(discount))
              .toStringAsFixed(2);
          // for applying coupon and create order
          cartItems.add({
            "id": data.id.toString(),
            "quantity": data.quantity.toString(),
            "price": data.price.toString(),
          });
        }
        update();
      }
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  //---------------Coupon Apply------------------------//
  TextEditingController couponEditingCtrl = TextEditingController();
  List<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[];
  Future couponApply({Map<String, dynamic>? fields}) async {
    _isLoading = true;
    update();
    http.Response response = await ProductsRepo.couponApply(fields: fields);
    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      couponEditingCtrl.clear();
      if (data['status'] == "success") {
        discount = data['data']['discountWithOutCurrency'].toString();
        await calculateAmount();
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      Helpers.showSnackBar(msg: "Something went wrong!");
    }
  }

  Future onApplyCoupon() async {
    if (couponEditingCtrl.text.isEmpty) {
      Helpers.showSnackBar(msg: "Please enter a coupon code to proceed.");
    } else {
      await couponApply(
        fields: {
          "cart_items": cartItems,
          "coupon": couponEditingCtrl.text,
        },
      );
      update();
    }
  }

  //----------------checkout section----------------------------//
  TextEditingController fNameEditingCtrlr = TextEditingController();
  TextEditingController lNameEditingCtrlr = TextEditingController();
  TextEditingController phoneEditingCtrlr = TextEditingController();
  TextEditingController addressEditingCtrlr = TextEditingController();
  TextEditingController cityEditingCtrlr = TextEditingController();
  TextEditingController zipCodeEditingCtrlr = TextEditingController();
  TextEditingController additionalInfoEditingCtrlr = TextEditingController();
  String selectedPaymentMethod = "checkout";

  //-----------get area list-------
  List<area.Datum> areaList = [];
  int selectedPaymentMethodIndex = 0;
  dynamic selectedArea;
  int areaId = 0;
  String deliveryCharge = "0.00";
  bool isGettingArea = false;
  Future getAreaList() async {
    isGettingArea = true;
    update();
    http.Response response = await ProductsRepo.getAreaList();
    isGettingArea = false;
    areaList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        areaList = [...areaList, ...area.AreaModel.fromJson(data).data!];
        isGettingArea = false;

        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      areaList = [];
    }
  }

  double totalPriceWithDeliveryCharge = 0.00;
  Future onAreaChanged(v) async {
    try {
      areaColor = Colors.transparent;
      selectedArea = v;
      var area = areaList.firstWhere((e) => e.areaName == v);
      areaId = area.id;
      int quantityFrom = 0;
      int quantityTo = 0;
      double baseTotal = double.parse(total);

      if (area.shippingCharge != null) {
        for (int i = 0; i < area.shippingCharge!.length; i += 1) {
          quantityFrom = int.parse(area.shippingCharge![i].orderFrom);
          quantityTo = area.shippingCharge![i].orderTo == null ||
                  area.shippingCharge![i].orderTo == ""
              ? 9999999999
              : int.parse(area.shippingCharge![i].orderTo);
          if (storedTotalQuantity >= quantityFrom &&
              storedTotalQuantity <= quantityTo) {
            deliveryCharge = area.shippingCharge![i].deliveryCharge.toString();
          }
        }
        totalPriceWithDeliveryCharge =
            baseTotal + double.parse(deliveryCharge.toString());
      } else {
        totalPriceWithDeliveryCharge = baseTotal;
      }
      update();
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  //-----------create order----------
  String orderId = "-1";
  Future createOrder(
      {Map<String, dynamic>? fields, required BuildContext context}) async {
    _isLoading = true;
    update();
    http.Response response = await ProductsRepo.createOrder(fields: fields);
    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        this.orderId = data['data']['order_id'].toString();
        if (orderId != "0") {
          if (selectedPaymentMethod == "wallet" ||
              selectedPaymentMethod == "cash") {
            makeOrderPayment(context: context, fields: {
              "order_id": this.orderId,
              // cash on delvery => 2000 , wallet => 2100
              "gateway_id": selectedPaymentMethod == "wallet" ? 2100 : 2000,
            });
          } else if (selectedPaymentMethod == "checkout") {
            Get.toNamed(RoutesName.productPaymentScreen);
          }
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      Helpers.showSnackBar(msg: "Something went wrong!");
    }
  }

  //-----------validate checkout field
  Color areaColor = Colors.transparent;
  Color fNameColor = Colors.transparent;
  Color lNameColor = Colors.transparent;
  Color emailColor = Colors.transparent;
  Color phoneColor = Colors.transparent;
  Color addressColor = Colors.transparent;
  Color cityColor = Colors.transparent;
  Color zipColor = Colors.transparent;

  Future checkValidate({required BuildContext context}) async {
    if (selectedArea == null) {
      Helpers.showSnackBar(msg: "Area field is required.");
      areaColor = AppColors.redColor;
    } else if (fNameEditingCtrlr.text.isEmpty) {
      Helpers.showSnackBar(msg: "First Name field is required.");
      fNameColor = AppColors.redColor;
    } else if (lNameEditingCtrlr.text.isEmpty) {
      Helpers.showSnackBar(msg: "Last Name field is required.");
      lNameColor = AppColors.redColor;
    } else if (emailEditingController.text.isEmpty) {
      Helpers.showSnackBar(msg: "Email field is required.");
      emailColor = AppColors.redColor;
    } else if (phoneEditingCtrlr.text.isEmpty) {
      Helpers.showSnackBar(msg: "Phone Number field is required.");
      phoneColor = AppColors.redColor;
    } else if (addressEditingCtrlr.text.isEmpty) {
      Helpers.showSnackBar(msg: "Address field is required.");
      addressColor = AppColors.redColor;
    } else if (cityEditingCtrlr.text.isEmpty) {
      Helpers.showSnackBar(msg: "City/Town field is required.");
      cityColor = AppColors.redColor;
    } else if (zipCodeEditingCtrlr.text.isEmpty) {
      Helpers.showSnackBar(msg: "Zip Code field is required.");
      zipColor = AppColors.redColor;
    } else {
      resetColor();
      Map<String, dynamic> body = {};
      body.addAll(CreateOrderModel(
        area: areaId,
        firstName: fNameEditingCtrlr.text,
        lastName: lNameEditingCtrlr.text,
        email: emailEditingController.text,
        phone: phoneEditingCtrlr.text,
        address: addressEditingCtrlr.text,
        city: cityEditingCtrlr.text,
        zip: zipCodeEditingCtrlr.text,
        additionalInformation: additionalInfoEditingCtrlr.text,
        paymentMethod: selectedPaymentMethod, // cash,checkout,wallet
      ).toJson());
      body.addAll({"cart_items": cartItems});

      await createOrder(context: context, fields: body);
    }
    update();
  }

  resetColor() {
    areaColor = Colors.transparent;
    fNameColor = Colors.transparent;
    lNameColor = Colors.transparent;
    emailColor = Colors.transparent;
    phoneColor = Colors.transparent;
    addressColor = Colors.transparent;
    cityColor = Colors.transparent;
    zipColor = Colors.transparent;
  }

  fNameChanged(v) {
    if (v.isNotEmpty) {
      fNameColor = Colors.transparent;
      update();
    } else {
      fNameColor = AppColors.redColor;
      update();
    }
  }

  lNameChanged(v) {
    if (v.isNotEmpty) {
      lNameColor = Colors.transparent;
      update();
    } else {
      lNameColor = AppColors.redColor;
      update();
    }
  }

  emailChanged(v) {
    if (v.isNotEmpty) {
      emailColor = Colors.transparent;
      update();
    } else {
      emailColor = AppColors.redColor;
      update();
    }
  }

  phoneChanged(v) {
    if (v.isNotEmpty) {
      phoneColor = Colors.transparent;
      update();
    } else {
      phoneColor = AppColors.redColor;
      update();
    }
  }

  addrChanged(v) {
    if (v.isNotEmpty) {
      addressColor = Colors.transparent;
      update();
    } else {
      addressColor = AppColors.redColor;
      update();
    }
  }

  cityChanged(v) {
    if (v.isNotEmpty) {
      cityColor = Colors.transparent;
      update();
    } else {
      cityColor = AppColors.redColor;
      update();
    }
  }

  zipChanged(v) {
    if (v.isNotEmpty) {
      zipColor = Colors.transparent;
      update();
    } else {
      zipColor = AppColors.redColor;
      update();
    }
  }

  //-----------------------make order payment-----------------------//
  bool isPayment = false;
  Future makeOrderPayment(
      {Map<String, dynamic>? fields, required BuildContext context}) async {
    isPayment = true;
    update();
    http.Response response =
        await ProductsRepo.makeOrderPayment(fields: fields);
    isPayment = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        if (selectedPaymentMethod == "wallet" ||
            selectedPaymentMethod == "cash") {
          ApiStatus.checkStatus(data['status'], data['data']);
          Get.toNamed(RoutesName.projectPaymentSuccessScreen);
          // clear cart list after payment successfull
          storedLocalCartItem.clear();
        } else if (selectedPaymentMethod == "checkout") {
          // do checkout
          DepositController.to.trxId = data['data'].toString();
          await DepositController.to.onBuyNowTapped(context: context);
        }

        update();
      } else {}
    } else {
      Helpers.showSnackBar(msg: "Something went wrong!");
    }
  }

  // refresh checkout amount
  refreshCheckoutAmount() {
    selectedArea = null;
    deliveryCharge = "0.00";
    totalPriceWithDeliveryCharge = 0.00;
  }

  //------if the payment method == "checkout"
  String amountInSelectedCurr = "0.00";
  String charge = "0.00";
  String payableAmount = "0.00";
  String exchRate = "0.00";
  String payableInBaseCurr = "0.00";
  calculateCheckoutAmount() {
    try {
      if (totalPriceWithDeliveryCharge != 0.0) {
        amountInSelectedCurr =
            (double.parse(DepositController.to.conversion_rate) *
                    totalPriceWithDeliveryCharge)
                .toStringAsFixed(2);
        charge = DepositController.to.charge;
        payableAmount = (double.parse(DepositController.to.charge) +
                double.parse(amountInSelectedCurr))
            .toStringAsFixed(2);
        exchRate = DepositController.to.conversion_rate;
        payableInBaseCurr = ((double.parse(DepositController.to.charge) /
                    double.parse(DepositController.to.conversion_rate)) +
                totalPriceWithDeliveryCharge)
            .toStringAsFixed(2);
        DepositController.to.totalPayableAmountInBaseCurrency =
            payableInBaseCurr;
        DepositController.to.totalChargedAmount = payableAmount;
        DepositController.to.sendAmount = payableAmount;
        update();
      }
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }
}
