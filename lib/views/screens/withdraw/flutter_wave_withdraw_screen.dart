import 'package:amarkhamar/views/widgets/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/withdraw_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_searchable_dropdown.dart';
import '../../widgets/spacing.dart';

// ignore: must_be_immutable
class FlutterWaveWithdrawScreen extends StatelessWidget {
  FlutterWaveWithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WithdrawController.to.flutterWaveSelectedTransfer = null;
    WithdrawController.to.bankFromBankDynamicList = [];
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<WithdrawController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(
          title: storedLanguage['Payout Preview'] ?? 'Payout Preview',
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Dimensions.kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VSpace(20.h),
                VSpace(20.h),
                Container(
                  height: 220.h,
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
                              Text("Payout by",
                                  style: context.t.displayMedium?.copyWith(
                                      color: Get.isDarkMode
                                          ? AppColors.textFieldHintColor
                                          : AppColors.paragraphColor)),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.centerRight,
                                child: Text("${_.gatewayName}",
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
                              Text("Amount In ${_.selectedCurrency}",
                                  style: context.t.displayMedium?.copyWith(
                                      color: Get.isDarkMode
                                          ? AppColors.textFieldHintColor
                                          : AppColors.paragraphColor)),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    "${_.amountValue} ${_.selectedCurrency}",
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
                              Text("Charge",
                                  style: context.t.displayMedium?.copyWith(
                                      color: Get.isDarkMode
                                          ? AppColors.textFieldHintColor
                                          : AppColors.paragraphColor)),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.centerRight,
                                child: Text("${_.charge} ${_.selectedCurrency}",
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
                              Text("Payout Amount",
                                  style: context.t.displayMedium?.copyWith(
                                      color: Get.isDarkMode
                                          ? AppColors.textFieldHintColor
                                          : AppColors.paragraphColor)),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    "${_.totalChargedAmount} ${_.selectedCurrency}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.t.displayMedium?.copyWith(
                                      color: AppColors.greenColor,
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
                              Text(
                                  storedLanguage['In Base Currency'] ??
                                      "In Base Currency",
                                  style: context.t.displayMedium?.copyWith(
                                      color: Get.isDarkMode
                                          ? AppColors.textFieldHintColor
                                          : AppColors.paragraphColor)),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    "${_.totalPayoutAmountInBaseCurrency} ${HiveHelp.read(Keys.baseCurrency)}",
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
                if (_.flutterwaveTransferList.isNotEmpty)
                  Text(storedLanguage['Select Transfer'] ?? "Select Transfer",
                      style: context.t.displayMedium),
                if (_.flutterwaveTransferList.isNotEmpty) VSpace(10.h),
                if (_.flutterwaveTransferList.isNotEmpty)
                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: Dimensions.kBorderRadius,
                      border: Border.all(
                          color: AppThemes.getSliderInactiveColor(), width: 1),
                    ),
                    child: AppCustomDropDown(
                      height: 46.h,
                      width: double.infinity,
                      items: _.flutterwaveTransferList.map((e) => e).toList(),
                      selectedValue: _.flutterWaveSelectedTransfer,
                      onChanged: (value) async {
                        _.flutterWaveSelectedTransfer = value;
                        _.getBankFromBank(bankName: value);
                        _.update();
                      },
                      paddingLeft: 10.w,
                      hint: storedLanguage['Select Transfer'] ??
                          "Select Transfer",
                      selectedStyle: context.t.bodySmall
                          ?.copyWith(color: AppThemes.getIconBlackColor()),
                    ),
                  ),
                if (_.bankFromBankList.isNotEmpty) VSpace(25.h),
                if (_.bankFromBankList.isNotEmpty)
                  Text(storedLanguage['Select Bank'] ?? "Select Bank",
                      style: context.t.displayMedium),
                if (_.bankFromBankList.isNotEmpty) VSpace(10.h),
                if (_.bankFromBankList.isNotEmpty)
                  CustomSearchableDropDown(
                    padding: EdgeInsets.all(4),
                    items: _.bankFromBankList,
                    prefixIcon: SizedBox(),
                    decoration: BoxDecoration(
                      borderRadius: Dimensions.kBorderRadius,
                      border: Border.all(
                          color: AppThemes.getSliderInactiveColor(), width: 1),
                    ),
                    label: storedLanguage['Select Bank'] ?? 'Select Bank',
                    dropdownItemStyle: TextStyle(
                      color: Colors.black,
                    ),
                    labelStyle: context.t.bodySmall?.copyWith(
                        color: Get.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.blackColor),
                    dropDownMenuItems: [
                      for (int i = 0; i < _.bankFromBankList.length; i++)
                        _.bankFromBankList[i].name,
                    ],
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: _.bankFromBankList.isEmpty
                          ? Colors.grey[400]
                          : Get.isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.blackColor,
                    ),
                    onChanged: (value) {
                      _.flutterWaveSelectedBank = value.name;
                      var data = _.bankFromBankList
                          .firstWhere((e) => e.name == value.name);
                      _.flutterwaveSelectedBankNumber = data.code.toString();
                      _.update();
                    },
                  ),
                VSpace(24.h),
                Form(
                  key: _.formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_.isBankLoading) Helpers.appLoader(),
                        if (_.bankFromBankDynamicList.isNotEmpty) ...[
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _.bankFromBankDynamicList.length,
                            itemBuilder: (context, index) {
                              var data = _.bankFromBankDynamicList[index];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.replaceAll("_", " "),
                                        style: context.t.displayMedium,
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          // Perform validation based on the 'validation' property
                                          if (value!.isEmpty) {
                                            return storedLanguage[
                                                    'Field is required'] ??
                                                "Field is required";
                                          }
                                          return null;
                                        },
                                        onChanged: (v) {
                                          _
                                              .bankFromBanktextEditingControllerMap[
                                                  data]!
                                              .text = v;
                                        },
                                        controller:
                                            _.bankFromBanktextEditingControllerMap[
                                                data],
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 16),
                                          filled:
                                              true, // Fill the background with color
                                          hintStyle: TextStyle(
                                            color: AppColors.textFieldHintColor,
                                          ),
                                          fillColor: Colors
                                              .transparent, // Background color
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppThemes
                                                  .getSliderInactiveColor(),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                            borderSide: BorderSide(
                                                color:
                                                    AppColors.secondaryColor),
                                          ),
                                        ),
                                        style: context.t.displayMedium,
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ]),
                ),
                if (_.flutterWaveSelectedTransfer != null &&
                    _.flutterWaveSelectedBank != null)
                  Material(
                    color: Colors.transparent,
                    child: AppButton(
                      isLoading: _.isPayoutSubmitting ? true : false,
                      onTap: _.isPayoutSubmitting
                          ? null
                          : () async {
                              Helpers.hideKeyboard();
                              if (_.selectedCurrency == null) {
                                Helpers.showSnackBar(
                                    msg: "Please select bank currency");
                              } else if (_.flutterWaveSelectedBank == null) {
                                Helpers.showSnackBar(msg: "Please select bank");
                              } else if (_.formKey.currentState!.validate()) {
                                Map<String, String> body = {
                                  "transfer_name":
                                      _.flutterWaveSelectedTransfer,
                                  "currency_code": _.selectedCurrency,
                                  "bank": _.flutterwaveSelectedBankNumber,
                                };
                                print(body);
                                _.bankFromBanktextEditingControllerMap
                                    .forEach((key, value) {
                                  body[key] = value.text;
                                });
                                await Future.delayed(
                                    Duration(milliseconds: 100));
                                await _.submitFlutterwavePayout(
                                    context: context, fields: body);
                              } else {
                                if (!_.formKey.currentState!.validate()) {
                                  Helpers.showSnackBar(
                                      msg:
                                          "Please fill in all required fields.");
                                } else if (_.requiredTypeFileList.isNotEmpty) {
                                  Helpers.showSnackBar(
                                      msg: _.requiredTypeFileList.join('\n') +
                                          " field is required");
                                }
                                print(
                                    "required type file list===========================: ${_.requiredTypeFileList}");
                              }
                            },
                      text: storedLanguage['Confirm Now'] ?? 'Confirm Now',
                      borderRadius: Dimensions.kBorderRadius,
                    ),
                  ),
                VSpace(40.h),
              ],
            ),
          ),
        ),
      );
    });
  }
}
