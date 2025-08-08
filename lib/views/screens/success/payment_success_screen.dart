import 'dart:math';
import 'package:amarkhamar/utils/services/helpers.dart';
import 'package:amarkhamar/utils/services/localstorage/hive.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:amarkhamar/config/dimensions.dart';
import 'package:amarkhamar/controllers/bindings/controller_index.dart';
import 'package:amarkhamar/routes/routes_name.dart';
import 'package:amarkhamar/themes/themes.dart';
import 'package:amarkhamar/utils/app_constants.dart';
import 'package:amarkhamar/views/widgets/app_button.dart';
import 'package:amarkhamar/views/widgets/spacing.dart';
import 'package:amarkhamar/views/widgets/text_theme_extension.dart';
import '../../../../config/app_colors.dart';
import '../../../utils/services/localstorage/keys.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  late ConfettiController _centerController;

  @override
  void initState() {
    super.initState();
    _centerController =
        ConfettiController(duration: const Duration(seconds: 40));
    _centerController.play();
  }

  @override
  void dispose() {
    _centerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DepositController>(builder: (_) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Get.offAllNamed(RoutesName.mainDrawerScreen);
        },
        child: Scaffold(
          backgroundColor:
              Get.isDarkMode ? AppColors.darkBgColor : AppColors.fillColorColor,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Image.asset(
                        "$rootImageDir/success_top.png",
                        width: 295.w,
                        height: 127.h,
                        fit: BoxFit.fitHeight,
                        color: Get.isDarkMode
                            ? AppColors.darkCardColor
                            : AppColors.mainColor,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 40.h),
                        child: Text("Success", style: context.t.bodyLarge),
                      ),
                    ],
                  ),
                ),
                VSpace(50.h),
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ConfettiWidget(
                        confettiController: _centerController,
                        blastDirection: pi / 2,
                        maxBlastForce: 5,
                        minBlastForce: 1,
                        emissionFrequency: 0.03,
                        numberOfParticles: 10,
                        gravity: 0,
                      ),
                    ),
                  ],
                ),
                VSpace(40.h),
                Padding(
                  padding: Dimensions.kDefaultPadding,
                  child: Ink(
                      width: double.maxFinite,
                      height: 153.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkCardColor
                            : AppColors.mainColor,
                        border: Border.all(
                            color: Get.isDarkMode
                                ? AppColors.darkCardColorDeep
                                : AppColors.secondaryColor,
                            width: Get.isDarkMode ? 1.h : .5),
                        borderRadius: Dimensions.kBorderRadius,
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -35.h,
                            child: Container(
                              height: 70.h,
                              width: 70.h,
                              padding: EdgeInsets.all(8.h),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Get.isDarkMode
                                        ? AppColors.darkCardColorDeep
                                        : AppColors.secondaryColor,
                                    width: Get.isDarkMode ? 1.h : .5),
                                color: Get.isDarkMode
                                    ? AppColors.darkCardColor
                                    : AppColors.mainColor,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "$rootImageDir/success.gif",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              VSpace(35.h),
                              Text("In Base Currency",
                                  style: context.t.bodyMedium
                                      ?.copyWith(fontSize: 18.sp)),
                              VSpace(10.h),
                              Text(
                                  "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", _.totalPayableAmountInBaseCurrency)}",
                                  style: context.t.bodyMedium?.copyWith(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
                        ],
                      )),
                ),
                VSpace(40.h),
                Padding(
                  padding: Dimensions.kDefaultPadding,
                  child: Ink(
                      width: double.maxFinite,
                      height: 200.h,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkCardColor
                            : AppColors.mainColor,
                        border: Border.all(
                            color: Get.isDarkMode
                                ? AppColors.darkCardColorDeep
                                : AppColors.secondaryColor,
                            width: Get.isDarkMode ? 1.h : .5),
                        borderRadius: Dimensions.kBorderRadius,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Payable Amount",
                                  style: context.t.displayMedium?.copyWith(
                                      color: AppThemes.getParagraphColor()),
                                ),
                                Text(
                                  "${Helpers.numberFormatWithAsFixed2("", _.totalChargedAmount)} ${_.selectedCurrency}",
                                  style: context.t.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            height: Get.isDarkMode ? 1 : .2,
                            color: Get.isDarkMode
                                ? AppColors.darkCardColorDeep
                                : AppColors.secondaryColor,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Charge",
                                  style: context.t.displayMedium?.copyWith(
                                      color: AppThemes.getParagraphColor()),
                                ),
                                Text(
                                  "${_.charge} ${_.selectedCurrency}",
                                  style: context.t.bodyMedium
                                      ?.copyWith(color: AppColors.redColor),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            height: Get.isDarkMode ? 1 : .2,
                            color: Get.isDarkMode
                                ? AppColors.darkCardColorDeep
                                : AppColors.secondaryColor,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              children: [
                                Text(
                                  "Gateway",
                                  style: context.t.displayMedium?.copyWith(
                                      color: AppThemes.getParagraphColor()),
                                ),
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("${_.gatewayName}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.t.bodyMedium),
                                )),
                              ],
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            height: Get.isDarkMode ? 1 : .2,
                            color: Get.isDarkMode
                                ? AppColors.darkCardColorDeep
                                : AppColors.secondaryColor,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              children: [
                                Text(
                                  "Date",
                                  style: context.t.displayMedium?.copyWith(
                                      color: AppThemes.getParagraphColor()),
                                ),
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      "${DateFormat('MMM d, yyyy').format(DateTime.now())}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.t.bodyMedium),
                                )),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                VSpace(40.h),
                Padding(
                  padding: Dimensions.kDefaultPadding,
                  child: AppButton(
                    onTap: () {
                      Get.offAllNamed(RoutesName.mainDrawerScreen);
                    },
                    text: "Return Home",
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
