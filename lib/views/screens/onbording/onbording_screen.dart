import 'dart:io';
import 'package:amarkhamar/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amarkhamar/utils/app_constants.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/circular_seek_bar.dart';
import '../../widgets/spacing.dart';
import 'onbording_data.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VSpace(20.h),
          SafeArea(
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(7.h),
                        height: 60.h,
                        width: 60.h,
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? AppColors.darkCardColor
                              : AppColors.sliderInActiveColor,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "$rootImageDir/amar_khamar_logo.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      HSpace(16.w),
                      Text(
                        "Amar Khamar",
                        style: t.bodyLarge?.copyWith(fontSize: 20.sp),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Get.offAllNamed(RoutesName.loginScreen);
                      HiveHelp.write(Keys.isNewUser, false);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        storedLanguage['Skip'] ?? "Skip",
                        style: t.displayMedium?.copyWith(
                          color: AppColors.greyColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: onBordingDataList.length,
                onPageChanged: (i) {
                  setState(() {
                    currentIndex = i;
                  });
                },
                itemBuilder: (context, i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (i == 0 || i == 1)
                        Center(
                          child: Image.asset(
                            onBordingDataList[i].imagePath,
                            height: i == 0
                                ? Platform.isAndroid
                                    ? 360.h
                                    : 300.h
                                : 420.h,
                            width: double.maxFinite,
                            fit: i == 0 ? BoxFit.fill : BoxFit.fitHeight,
                          ),
                        ),
                      if (i == 2)
                        SizedBox(
                          width: double.maxFinite,
                          height: 420.h,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: Image.asset(
                                  onBordingDataList[i].imagePath,
                                  height: 419.h,
                                  width: 280.w,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 20.w),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Image.asset(
                                    "$rootImageDir/onbording_text.png",
                                    height: 280.h,
                                    width: 87.w,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      VSpace(Platform.isAndroid ? 59.h : 40.h),
                      Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Text(
                          onBordingDataList[i].title,
                          style: t.titleSmall?.copyWith(
                            fontSize: 24.sp,
                          ),
                        ),
                      ),
                      VSpace(12.h),
                      Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Text(
                          onBordingDataList[i].description,
                          style: t.bodySmall?.copyWith(
                              height: 1.5,
                              fontSize: 16.sp,
                              color: AppThemes.getParagraphColor()),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
            margin: EdgeInsets.only(
                bottom: Platform.isAndroid ? 60.h : 30.h,
                top: Platform.isAndroid ? 40.h : 20.h),
            padding: Dimensions.kDefaultPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularSeekBar(
                      width: 56.h,
                      height: 56.h,
                      progress: currentIndex == 0
                          ? 33.33
                          : currentIndex == 1
                              ? 66.66
                              : 100,
                      barWidth: 3.w,
                      startAngle: 85,
                      sweepAngle: 230,
                      strokeCap: StrokeCap.round,
                      trackColor: Get.isDarkMode
                          ? AppColors.black80
                          : AppColors.mainColor,
                      progressGradientColors: [
                        AppColors.secondaryColor,
                        AppColors.secondaryColor,
                        AppColors.secondaryColor,
                      ],
                      dashWidth: 57.h,
                      dashGap: 25.h,
                      animation: true,
                      animDurationMillis: 600,
                    ),
                    Container(
                      width: 41.h,
                      height: 41.h,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkCardColor
                            : AppColors.mainColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          "${currentIndex + 1}/3",
                          style: t.bodySmall?.copyWith(
                              color: Get.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor),
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  borderRadius: Dimensions.kBorderRadius,
                  onTap: () {
                    (currentIndex == (onBordingDataList.length - 1))
                        ? Get.offAllNamed(RoutesName.loginScreen)
                        : controller.nextPage(
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.easeInOutQuint);
                    if ((currentIndex == (onBordingDataList.length - 1))) {
                      HiveHelp.write(Keys.isNewUser, false);
                    }
                  },
                  child: Ink(
                    width: (currentIndex == (onBordingDataList.length - 1))
                        ? 218.w
                        : 167.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: Dimensions.kBorderRadius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (currentIndex == (onBordingDataList.length - 1))
                              ? "Get Started"
                              : "Next",
                          style: t.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.whiteColor),
                        ),
                        HSpace(12.w),
                        Image.asset(
                          "$rootImageDir/big_arrow.png",
                          width: 36.w,
                          color: AppColors.whiteColor,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
