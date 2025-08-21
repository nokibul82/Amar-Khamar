import 'package:amarkhamar/controllers/profile_controller.dart';
import 'package:amarkhamar/data/models/plan_investment_model.dart';
import 'package:amarkhamar/utils/app_constants.dart';
import 'package:amarkhamar/utils/services/localstorage/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/plan_controller.dart';
import '../../../controllers/transaction_controller.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/arrow_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class PlanInvestScreen extends StatelessWidget {
  const PlanInvestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<PlanController>(builder: (_) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
        appBar: CustomAppBar(
          bgColor:
              Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
          title: storedLanguage['Investment Plan'] ?? "Investment Plan",
        ),
        body: RefreshIndicator(
          color: AppColors.secondaryColor,
          onRefresh: () async {
            await _.getPlanInvestmentList();
          },
          child: _.isLoading
              ? Helpers.appLoader()
              : _.planList.isEmpty
                  ? Helpers.notFound(top: 0)
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Column(
                          children: [
                            VSpace(20.h),
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _.planList.length,
                                itemBuilder: (context, i) {
                                  var data = _.planList[i];
                                  return Container(
                                    width: double.maxFinite,
                                    height: 130.h,
                                    margin: EdgeInsets.only(bottom: 12.h),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    decoration: BoxDecoration(
                                      color: AppThemes.getDarkCardColor(),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("${data.planName}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: t.displayMedium),
                                                  VSpace(5.h),
                                                  Text(
                                                      data.minInvest == "0.00"
                                                          ? "${data.currencySymbol}${Helpers.numberFormat(data.planPrice.toString())}"
                                                          : "${data.currencySymbol}${Helpers.numberFormat(data.minInvest.toString())} - ${data.currencySymbol}${Helpers.numberFormat(data.maxInvest.toString())}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: t.bodySmall),
                                                ],
                                              ),
                                            ),
                                            ArrowButton(
                                              arrowSize: 17.h,
                                              bgColor: Get.isDarkMode
                                                  ? AppColors.darkBgColor
                                                  : AppColors.pageBgColor,
                                              onTap: () {
                                                _.getSelectedVal(data);
                                                buildDialog(context, t, data, _,
                                                    storedLanguage);
                                              },
                                              height: 30.h,
                                              width: 104.w,
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                              t: t,
                                              text: storedLanguage[
                                                      'Invest Now'] ??
                                                  "Invest Now",
                                              style: t.bodySmall?.copyWith(
                                                fontSize: 12.sp,
                                                color: AppThemes
                                                    .getIconBlackColor(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 1.h,
                                          width: double.maxFinite,
                                          color: Get.isDarkMode
                                              ? AppColors.darkCardColorDeep
                                              : AppColors.pageBgColor,
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "$rootImageDir/rio.png",
                                              height: 10.h,
                                              width: 10.h,
                                              color:
                                                  AppThemes.getParagraphColor(),
                                              fit: BoxFit.cover,
                                            ),
                                            HSpace(6.w),
                                            Text("ROI : ", style: t.bodySmall),
                                            Text(
                                                "${double.parse(data.profit.toString()) == double.parse(data.profit.toString()).toInt() ? double.parse(data.profit.toString()).toInt().toString() : double.parse(data.profit.toString()).toStringAsFixed(2)}%",
                                                style: t.bodySmall?.copyWith(
                                                    color: AppThemes
                                                        .getIconBlackColor())),
                                            Spacer(),
                                            Image.asset(
                                              "$rootImageDir/cycle.png",
                                              height: 12.h,
                                              width: 12.h,
                                              fit: BoxFit.cover,
                                              color:
                                                  AppThemes.getParagraphColor(),
                                            ),
                                            HSpace(6.w),
                                            Text("Cycle : ",
                                                style: t.bodySmall),
                                            Text(
                                                "Every ${data.returnPeriod} ${data.returnPeriodType}",
                                                style: t.bodySmall?.copyWith(
                                                    color: AppThemes
                                                        .getIconBlackColor())),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
        ),
      );
    });
  }

  buildDialog(BuildContext context, TextTheme t, Datum data, PlanController _,
      dynamic storedLanguage) {
    appDialog(
        insetPadding: Dimensions.kDefaultPadding,
        context: context,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkResponse(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.all(7.h),
                decoration: BoxDecoration(
                  color: AppThemes.getFillColor(),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 14.h,
                  color: Get.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  storedLanguage['Maturity'] ?? "Maturity",
                  style: t.displayMedium
                      ?.copyWith(color: AppThemes.getParagraphColor()),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      data.maturity.toString() == "null"
                          ? ""
                          : "${double.parse(data.maturity.toString().split(" ").first).toInt() > 1 ? data.maturity.toString() : data.maturity.toString().split(" ").first + ' Day'}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.displayMedium,
                    ),
                  ),
                ),
              ],
            ),
            VSpace(8.h),
            Container(
              width: double.maxFinite,
              height: 1,
              color: Get.isDarkMode
                  ? AppColors.black80
                  : AppColors.mainColor.withOpacity(.5),
            ),
            VSpace(24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  storedLanguage['Number of Return'] ?? "Number of Return",
                  style: t.displayMedium
                      ?.copyWith(color: AppThemes.getParagraphColor()),
                ),
                Text(
                  data.numberOfProfitReturn == null
                      ? storedLanguage['Lifetime Earning'] ?? "Lifetime Earning"
                      : "${data.numberOfProfitReturn.toString()} Times",
                  style: t.displayMedium,
                ),
              ],
            ),
            VSpace(8.h),
            Container(
              width: double.maxFinite,
              height: 1,
              color: Get.isDarkMode
                  ? AppColors.black80
                  : AppColors.mainColor.withOpacity(.5),
            ),
            VSpace(24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  storedLanguage['Capital Back'] ?? "Capital Back",
                  style: t.displayMedium
                      ?.copyWith(color: AppThemes.getParagraphColor()),
                ),
                Text(
                  data.capitalBack.toString() == "1"
                      ? storedLanguage['Yes'] ?? "Yes"
                      : storedLanguage['No'] ?? "No",
                  style: t.displayMedium?.copyWith(
                      color: data.capitalBack.toString() == "1"
                          ? AppColors.greenColor
                          : AppColors.redColor),
                ),
              ],
            ),
            VSpace(8.h),
            Container(
              width: double.maxFinite,
              height: 1,
              color: Get.isDarkMode
                  ? AppColors.black80
                  : AppColors.mainColor.withOpacity(.5),
            ),
            VSpace(32.h),
            Text(
              storedLanguage['Select Wallet'] ?? "Select Wallet",
              style: t.displayMedium,
            ),
            VSpace(12.h),
            GetBuilder<PlanController>(builder: (_) {
              return Container(
                height: 50.h,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Get.isDarkMode
                          ? AppColors.black80
                          : AppColors.sliderInActiveColor),
                  borderRadius: Dimensions.kBorderRadius,
                ),
                child: AppCustomDropDown(
                  height: 50.h,
                  width: double.infinity,
                  items: ProfileController.to.walletList,
                  selectedValue: _.selectedWallet,
                  onChanged: (value) {
                    _.selectedWallet = value;
                    _.update();
                  },
                  hint: storedLanguage['Select currency'] ?? "Select currency",
                  selectedStyle: t.displayMedium,
                  bgColor: Get.isDarkMode
                      ? AppColors.darkBgColor
                      : AppColors.fillColorColor,
                ),
              );
            }),
            VSpace(20.h),
            Text(storedLanguage['Amount'] ?? 'Amount', style: t.displayMedium),
            VSpace(12.h),
            GetBuilder<PlanController>(builder: (_) {
              return CustomTextField(
                isOnlyBorderColor: true,
                borderColor: Get.isDarkMode
                    ? AppColors.black80
                    : AppColors.sliderInActiveColor,
                isSuffixIcon:
                    _.amountVal == null || _.amountVal.toString().isEmpty
                        ? false
                        : true,
                suffixIcon: _.isValidAmountRange ? "check" : "warning",
                suffixIconColor: _.isValidAmountRange
                    ? AppColors.greenColor
                    : AppColors.redColor,
                suffixIconSize: 20.h,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                hintStyle:
                    t.bodySmall?.copyWith(color: AppColors.textFieldHintColor),
                contentPadding: EdgeInsets.only(left: 20.w),
                hintext: storedLanguage['Enter Amount'] ?? 'Enter Amount',
                controller: _.amountCtrl,
                onChanged: _.onAmountChange,
              );
            }),
            VSpace(40.h),
            GetBuilder<PlanController>(builder: (_) {
              return AppButton(
                isLoading: _.isPayment ? true : false,
                onTap: _.isPayment
                    ? null
                    : () async {
                        if (HiveHelp.read(Keys.token) != null) {
                          await _.onMakePaymentBtnClick(
                              context: context, planId: data.id.toString());
                        } else {
                          Get.find<TransactionController>().transactionList =
                              [];
                          Get.find<TransactionController>().update();
                          Get.offAllNamed(RoutesName.loginScreen);
                        }
                      },
                text: storedLanguage['Make Payment'] ?? "Make Payment",
              );
            }),
            VSpace(20.h),
            AppButton(
              bgColor: AppColors.redColor,
              onTap: () {
                Get.back();
              },
              text: storedLanguage['Cancel This Payment'] ??
                  "Cancel This Payment",
            ),
          ],
        ));
  }
}
