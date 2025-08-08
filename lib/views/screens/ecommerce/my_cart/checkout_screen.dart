import '../../../../controllers/product_manage_controller.dart';
import '../../../../themes/themes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/dimensions.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/services/helpers.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/app_custom_dropdown.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/spacing.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProductManageController.to.refreshCheckoutAmount();
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ProductManageController>(builder: (_) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _.resetColor();
          Get.back();
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title:storedLanguage['Checkout'] ?? "Checkout",
            onBackPressed: () {
              _.resetColor();
              Get.back();
            },
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VSpace(20.h),
                  Container(
                    height: 180.h,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: Dimensions.kBorderRadius,
                      border: Border.all(
                          color: Get.isDarkMode
                              ? AppColors.black60
                              : AppColors.black30,
                          width: Dimensions.appThinBorder),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(storedLanguage['SubTotal'] ??"SubTotal",
                                    style: context.t.displayMedium?.copyWith(
                                        color: Get.isDarkMode
                                            ? AppColors.textFieldHintColor
                                            : AppColors.paragraphColor)),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", _.subTotal)}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.t.displayMedium),
                                )),
                              ],
                            ),
                          ),
                          Container(
                            height: .2,
                            color: Get.isDarkMode
                                ? AppColors.black60
                                : AppColors.black30,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(storedLanguage['Delivery Charge'] ??"Delivery Charge",
                                    style: context.t.displayMedium?.copyWith(
                                        color: Get.isDarkMode
                                            ? AppColors.textFieldHintColor
                                            : AppColors.paragraphColor)),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", _.deliveryCharge)}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.t.displayMedium?.copyWith(
                                        color: AppColors.redColor,
                                      )),
                                )),
                              ],
                            ),
                          ),
                          Container(
                            height: .2,
                            color: Get.isDarkMode
                                ? AppColors.black60
                                : AppColors.black30,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(storedLanguage['Discount'] ??"Discount",
                                    style: context.t.displayMedium?.copyWith(
                                        color: Get.isDarkMode
                                            ? AppColors.textFieldHintColor
                                            : AppColors.paragraphColor)),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", _.discount)}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.t.displayMedium),
                                )),
                              ],
                            ),
                          ),
                          Container(
                            height: .2,
                            color: Get.isDarkMode
                                ? AppColors.black60
                                : AppColors.black30,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${storedLanguage['Total'] ?? "Total"} (${HiveHelp.read(Keys.baseCurrency)})",
                                    style: context.t.displayMedium?.copyWith(
                                        color: Get.isDarkMode
                                            ? AppColors.textFieldHintColor
                                            : AppColors.paragraphColor)),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", _.totalPriceWithDeliveryCharge == 0.00 ? _.total : _.totalPriceWithDeliveryCharge.toString())}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.t.displayMedium?.copyWith(
                                        color: AppColors.greenColor,
                                      )),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  VSpace(40.h),
                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: _.areaColor == Colors.transparent
                              ? AppThemes.getSliderInactiveColor()
                              : _.areaColor),
                      borderRadius: Dimensions.kBorderRadius,
                    ),
                    child: AppCustomDropDown(
                      height: 50.h,
                      width: double.infinity,
                      items: _.areaList.map((e) => e.areaName).toList(),
                      selectedValue: _.selectedArea,
                      onChanged: (value) async {
                        await _.onAreaChanged(value);
                      },
                      hint:storedLanguage['Select Area'] ?? "Select Area",
                      hintStyle: context.t.displayMedium
                          ?.copyWith(color: AppColors.textFieldHintColor),
                      selectedStyle: context.t.displayMedium,
                      bgColor: Get.isDarkMode
                          ? AppColors.darkBgColor
                          : AppColors.fillColorColor,
                    ),
                  ),
                  VSpace(25.h),
                  CustomTextField(
                    hintext:storedLanguage['First Name'] ?? "First Name",
                    isPrefixIcon: true,
                    prefixIcon: 'edit',
                    controller: _.fNameEditingCtrlr,
                    borderColor: _.fNameColor == Colors.transparent
                        ? AppThemes.getSliderInactiveColor()
                        : _.fNameColor,
                    onChanged: _.fNameChanged,
                  ),
                  VSpace(25.h),
                  CustomTextField(
                    hintext:storedLanguage['Last Name'] ?? "Last Name",
                    isPrefixIcon: true,
                    prefixIcon: 'edit',
                    controller: _.lNameEditingCtrlr,
                    borderColor: _.lNameColor == Colors.transparent
                        ? AppThemes.getSliderInactiveColor()
                        : _.lNameColor,
                    onChanged: _.lNameChanged,
                  ),
                  VSpace(25.h),
                  CustomTextField(
                    hintext:storedLanguage['Email'] ?? "Email",
                    isPrefixIcon: true,
                    prefixIcon: 'email',
                    controller: _.emailEditingController,
                    borderColor: _.emailColor == Colors.transparent
                        ? AppThemes.getSliderInactiveColor()
                        : _.emailColor,
                    onChanged: _.emailChanged,
                  ),
                  VSpace(25.h),
                  CustomTextField(
                    hintext:storedLanguage['Phone'] ?? "Phone",
                    isPrefixIcon: true,
                    prefixIcon: 'call',
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: _.phoneEditingCtrlr,
                    borderColor: _.phoneColor == Colors.transparent
                        ? AppThemes.getSliderInactiveColor()
                        : _.phoneColor,
                    onChanged: _.phoneChanged,
                  ),
                  VSpace(25.h),
                  CustomTextField(
                    hintext: storedLanguage['Address'] ??"Address",
                    isPrefixIcon: true,
                    prefixIcon: 'location',
                    controller: _.addressEditingCtrlr,
                    borderColor: _.addressColor == Colors.transparent
                        ? AppThemes.getSliderInactiveColor()
                        : _.addressColor,
                    onChanged: _.addrChanged,
                  ),
                  VSpace(25.h),
                  CustomTextField(
                    hintext:storedLanguage['City/Town'] ?? "City/Town",
                    isPrefixIcon: true,
                    prefixIcon: 'location',
                    controller: _.cityEditingCtrlr,
                    borderColor: _.cityColor == Colors.transparent
                        ? AppThemes.getSliderInactiveColor()
                        : _.cityColor,
                    onChanged: _.cityChanged,
                  ),
                  VSpace(25.h),
                  CustomTextField(
                    hintext:storedLanguage['Zip Code'] ?? "Zip Code",
                    isPrefixIcon: true,
                    prefixIcon: 'zip',
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: _.zipCodeEditingCtrlr,
                    borderColor: _.zipColor == Colors.transparent
                        ? AppThemes.getSliderInactiveColor()
                        : _.zipColor,
                    onChanged: _.zipChanged,
                  ),
                  VSpace(25.h),
                  CustomTextField(
                    height: 132.h,
                    contentPadding:
                        EdgeInsets.only(left: 20.w, bottom: 0.h, top: 10.h),
                    alignment: Alignment.topLeft,
                    minLines: 3,
                    maxLines: 5,
                    isOnlyBorderColor: true,
                    isPrefixIcon: false,
                    controller: _.additionalInfoEditingCtrlr,
                    hintext: storedLanguage['Additional Information'] ??"Additional Information",
                  ),
                  VSpace(66.h),
                  Text(storedLanguage['Select Payment Method'] ??"Select Payment Method", style: context.t.bodyMedium),
                  VSpace(30.h),
                  buildTile(
                    context,
                    title:storedLanguage['Checkout'] ?? "Checkout",
                    img: "checkout",
                    selectedBgColor: _.selectedPaymentMethodIndex == 0
                        ? AppColors.secondaryColor
                        : null,
                    selectedDoneColor: _.selectedPaymentMethodIndex == 0
                        ? AppColors.whiteColor
                        : null,
                    selectedBorderColor: _.selectedPaymentMethodIndex == 0
                        ? AppColors.secondaryColor
                        : null,
                    onTap: () {
                      _.selectedPaymentMethodIndex = 0;
                      _.selectedPaymentMethod = "checkout";
                      _.update();
                    },
                  ),
                  buildTile(
                    context,
                    title:storedLanguage['Wallet Payment'] ?? "Wallet payment",
                    img: "wallet",
                    selectedBgColor: _.selectedPaymentMethodIndex == 1
                        ? AppColors.secondaryColor
                        : null,
                    selectedDoneColor: _.selectedPaymentMethodIndex == 1
                        ? AppColors.whiteColor
                        : null,
                    selectedBorderColor: _.selectedPaymentMethodIndex == 1
                        ? AppColors.secondaryColor
                        : null,
                    onTap: () {
                      _.selectedPaymentMethodIndex = 1;
                      _.selectedPaymentMethod = "wallet";
                      _.update();
                    },
                  ),
                  buildTile(
                    context,
                    title:storedLanguage['Cash on delivery'] ?? "Cash on delivery",
                    img: "cash-on-delivery",
                    selectedBgColor: _.selectedPaymentMethodIndex == 2
                        ? AppColors.secondaryColor
                        : null,
                    selectedDoneColor: _.selectedPaymentMethodIndex == 2
                        ? AppColors.whiteColor
                        : null,
                    selectedBorderColor: _.selectedPaymentMethodIndex == 2
                        ? AppColors.secondaryColor
                        : null,
                    onTap: () {
                      _.selectedPaymentMethodIndex = 2;
                      _.selectedPaymentMethod = "cash";
                      _.update();
                    },
                  ),
                  VSpace(30.h),
                  AppButton(
                      isLoading: _.isLoading || _.isPayment ? true : false,
                      onTap: _.isLoading || _.isPayment
                          ? null
                          : () async {
                              await _.checkValidate(context: context);
                            },
                      text:storedLanguage['Make Payment'] ?? "Make Payment"),
                  VSpace(66.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Padding buildTile(BuildContext context,
      {Color? selectedDoneColor,
      double? padding,
      void Function()? onTap,
      Color? selectedBgColor,
      Color? selectedBorderColor,
      String? title,
      String? img}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: InkWell(
        borderRadius: Dimensions.kBorderRadius,
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: AppThemes.getFillColor(),
            borderRadius: Dimensions.kBorderRadius,
          ),
          child: Row(
            children: [
              Container(
                height: 50.h,
                width: 50.h,
                padding: EdgeInsets.all(padding ?? 10.h),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? AppColors.darkBgColor
                      : AppColors.whiteColor,
                  borderRadius: Dimensions.kBorderRadius,
                ),
                child: Image.asset(
                  "$rootEcommerceDir/$img.png",
                  fit: BoxFit.cover,
                ),
              ),
              HSpace(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title ?? "",
                        style: context.t.bodyMedium?.copyWith(
                            fontSize: 18.sp, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Container(
                height: 18.h,
                width: 18.h,
                decoration: BoxDecoration(
                  color: selectedBgColor ?? Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedBorderColor ?? AppColors.greyColor,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.done,
                    size: 12.h,
                    color: selectedDoneColor ?? Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
