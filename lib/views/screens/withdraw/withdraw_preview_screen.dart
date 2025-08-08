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
class WithdrawPreviewScreen extends StatelessWidget {
  WithdrawPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WithdrawController.to.paystackSelectedBank = null;
    WithdrawController.to.selectedPaypalValue = null;
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
                              Text(storedLanguage['Payout by']??"Payout by",
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
                              Text(storedLanguage['Charge']??"Charge",
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
                              Text(storedLanguage['Payout Amount']??"Payout Amount",
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
                VSpace(24.h),
                Form(
                  key: _.formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //=====================if the gateway is paypal==============
                        if (_.gatewayName == "Paypal")
                          Text("Select Recipient Type",
                              style: context.t.displayMedium),
                        if (_.gatewayName == "Paypal") VSpace(12.h),
                        if (_.gatewayName == "Paypal")
                          Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppThemes.getSliderInactiveColor(),
                                width: 1,
                              ),
                              borderRadius: Dimensions.kBorderRadius,
                            ),
                            child: AppCustomDropDown(
                              height: 46.h,
                              width: double.infinity,
                              items: ["Email", "Phone", "Paypal Id"],
                              selectedValue: _.selectedPaypalValue,
                              onChanged: (value) async {
                                _.selectedPaypalValue = value;
                                _.update();
                              },
                              hint: storedLanguage['Select type'] ??
                                  "Select type",
                              selectedStyle: context.t.displayMedium,
                            ),
                          ),

                        if (_.selectedDynamicList.isNotEmpty) ...[
                          VSpace(25.h),
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _.selectedDynamicList.length,
                            itemBuilder: (context, index) {
                              final dynamicField = _.selectedDynamicList[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (dynamicField.type == "file")
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              dynamicField.fieldLevel!,
                                              style: context.t.displayMedium,
                                            ),
                                            dynamicField.validation ==
                                                    'required'
                                                ? const SizedBox()
                                                : Text(
                                                    " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                    style:
                                                        context.t.displayMedium,
                                                  ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Container(
                                          height: 45.5,
                                          width: double.maxFinite,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w, vertical: 10.h),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppThemes
                                                    .getSliderInactiveColor()),
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                          ),
                                          child: Row(
                                            children: [
                                              HSpace(12.w),
                                              Text(
                                                _.imagePickerResults[
                                                            dynamicField
                                                                .fieldName] !=
                                                        null
                                                    ? storedLanguage[
                                                            '1 File selected'] ??
                                                        "1 File selected"
                                                    : storedLanguage[
                                                            'No File selected'] ??
                                                        "No File selected",
                                                style: context.t.bodySmall?.copyWith(
                                                    color: _.imagePickerResults[
                                                                dynamicField
                                                                    .fieldName] !=
                                                            null
                                                        ? AppColors.greenColor
                                                        : AppColors.black60),
                                              ),
                                              const Spacer(),
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () async {
                                                    Helpers.hideKeyboard();

                                                    await _.pickFile(
                                                        dynamicField
                                                            .fieldName!);
                                                  },
                                                  borderRadius:
                                                      Dimensions.kBorderRadius,
                                                  child: Ink(
                                                    width: 113.w,
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .secondaryColor,
                                                      borderRadius: Dimensions
                                                              .kBorderRadius /
                                                          2,
                                                      border: Border.all(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: .2),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                            storedLanguage[
                                                                    'Choose File'] ??
                                                                'Choose File',
                                                            style: context
                                                                .t.bodySmall
                                                                ?.copyWith(
                                                                    color: AppColors
                                                                        .whiteColor))),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16.h,
                                        ),
                                      ],
                                    ),
                                  if (dynamicField.type == "text")
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              dynamicField.fieldLevel!,
                                              style: context.t.displayMedium,
                                            ),
                                            dynamicField.validation ==
                                                    'required'
                                                ? const SizedBox()
                                                : Text(
                                                    " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                    style:
                                                        context.t.displayMedium,
                                                  ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        TextFormField(
                                          validator: (value) {
                                            // Perform validation based on the 'validation' property
                                            if (dynamicField.validation ==
                                                    "required" &&
                                                value!.isEmpty) {
                                              return storedLanguage[
                                                      'Field is required'] ??
                                                  "Field is required";
                                            }
                                            return null;
                                          },
                                          onChanged: (v) {
                                            _
                                                .textEditingControllerMap[
                                                    dynamicField.fieldName]!
                                                .text = v;
                                          },
                                          controller:
                                              _.textEditingControllerMap[
                                                  dynamicField.fieldName],
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 16),
                                            filled:
                                                true, // Fill the background with color
                                            hintStyle: TextStyle(
                                              color:
                                                  AppColors.textFieldHintColor,
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
                                          height: index ==
                                                  _.selectedDynamicList.length -
                                                      1
                                              ? 0
                                              : 16.h,
                                        ),
                                      ],
                                    ),
                                  if (dynamicField.type == 'textarea')
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              dynamicField.fieldLevel!,
                                              style: context.t.displayMedium,
                                            ),
                                            dynamicField.validation ==
                                                    'required'
                                                ? const SizedBox()
                                                : Text(
                                                    " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                    style:
                                                        context.t.displayMedium,
                                                  ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        TextFormField(
                                          validator: (value) {
                                            if (dynamicField.validation ==
                                                    "required" &&
                                                value!.isEmpty) {
                                              return storedLanguage[
                                                      'Field is required'] ??
                                                  "Field is required";
                                            }
                                            return null;
                                          },
                                          controller:
                                              _.textEditingControllerMap[
                                                  dynamicField.fieldName],
                                          maxLines: 7,
                                          minLines: 5,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 16),
                                            filled: true,
                                            hintStyle: TextStyle(
                                              color:
                                                  AppColors.textFieldHintColor,
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
                                                  BorderRadius.circular(25.r),
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

                        if (_.gatewayName == "Paystack" &&
                            _.bankFromCurrencyList.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 15.h),
                            child: Text("Select Bank",
                                style: context.t.displayMedium),
                          ),
                        if (_.gatewayName == "Paystack" &&
                            _.bankFromCurrencyList.isNotEmpty)
                          VSpace(12.h),
                        if (_.gatewayName == "Paystack" &&
                            _.bankFromCurrencyList.isNotEmpty)
                          CustomSearchableDropDown(
                            padding: EdgeInsets.all(4),
                            items: _.bankFromCurrencyList,
                            prefixIcon: SizedBox(),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppThemes.getSliderInactiveColor()),
                              borderRadius: Dimensions.kBorderRadius,
                            ),
                            label:
                                storedLanguage['Select Bank'] ?? 'Select Bank',
                            dropdownItemStyle: TextStyle(
                              color: Colors.black,
                            ),
                            labelStyle: context.t.bodySmall?.copyWith(
                                color: Get.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.blackColor),
                            dropDownMenuItems: [
                              for (int i = 0;
                                  i < _.bankFromCurrencyList.length;
                                  i++)
                                _.bankFromCurrencyList[i].name,
                            ],
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: _.bankFromCurrencyList.isEmpty
                                  ? Colors.grey[400]
                                  : Get.isDarkMode
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor,
                            ),
                            onChanged: (value) {
                              _.paystackSelectedBank = value.name;
                              var data = _.bankFromCurrencyList
                                  .firstWhere((e) => e.name == value.name);
                              _.paystackSelectedBankNumber =
                                  data.code.toString();
                              _.paystackSelectedType = data.type.toString();

                              _.update();
                            },
                          ),
                        //=========================if ther selected gateway is other=====================//

                        VSpace(40.h),
                        Material(
                          color: Colors.transparent,
                          child: AppButton(
                            isLoading: _.isPayoutSubmitting ? true : false,
                            onTap: _.isPayoutSubmitting
                                ? null
                                : () async {
                                    Helpers.hideKeyboard();
                                    // if the payment gateway is paystack
                                    if (_.gatewayName == "Paystack") {
                                      if (_.selectedCurrency == null) {
                                        Helpers.showSnackBar(
                                            msg: "Please select bank currency");
                                      } else if (_.paystackSelectedBank ==
                                          null) {
                                        Helpers.showSnackBar(
                                            msg: "Please select bank");
                                      } else if (_.formKey.currentState!
                                          .validate()) {
                                        Map<String, String> body = {
                                          "bank": _.paystackSelectedBankNumber,
                                          "currency_code": _.selectedCurrency,
                                        };
                                        _.textEditingControllerMap
                                            .forEach((key, value) {
                                          body[key] = value.text;
                                        });
                                        await Future.delayed(
                                            Duration(milliseconds: 100));
                                        await _.submitPaystackPayout(
                                            context: context, fields: body);
                                      } else {
                                        print(
                                            "required type file list===========================: ${_.requiredTypeFileList}");
                                        Helpers.showSnackBar(
                                            msg:
                                                "Please fill in all required fields.");
                                      }
                                    }
                                    // if the payment gateway is other
                                    else {
                                      if (_.gatewayName == "Paypal" &&
                                          _.selectedPaypalValue == null) {
                                        Helpers.showSnackBar(
                                            msg: "Please select bank currency");
                                      } else if (_.formKey.currentState!
                                          .validate()) {
                                        Map<String, String> body = {
                                          if (_.selectedCurrency != null)
                                            "currency_code": _.selectedCurrency,
                                          if (_.gatewayName == "Paypal")
                                            "recipient_type":
                                                _.selectedPaypalValue,
                                        };
                                        _.textEditingControllerMap
                                            .forEach((key, value) {
                                          body[key] = value.text;
                                        });

                                        await Future.delayed(
                                            Duration(milliseconds: 100));
                                        if (_.fileMap.isNotEmpty) {
                                          await _.submitPayout(
                                              fileList: _.fileMap.entries
                                                  .map((e) => e.value)
                                                  .toList(),
                                              fields: body,
                                              context: context);
                                        }
                                        if (_.fileMap.isEmpty) {
                                          await _.submitPayout(
                                              fileList: null,
                                              fields: body,
                                              context: context);
                                        }
                                      } else {
                                        if (!_.formKey.currentState!
                                            .validate()) {
                                          Helpers.showSnackBar(
                                              msg:
                                                  "Please fill in all required fields.");
                                        } else if (_
                                            .requiredTypeFileList.isNotEmpty) {
                                          Helpers.showSnackBar(
                                              msg: _.requiredTypeFileList
                                                      .join('\n') +
                                                  " field is required");
                                        }
                                        print(
                                            "required type file list===========================: ${_.requiredTypeFileList}");
                                      }
                                    }
                                  },
                            text:
                                storedLanguage['Confirm Now'] ?? 'Confirm Now',
                          ),
                        ),
                        VSpace(40.h),
                      ]),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
