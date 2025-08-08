import 'package:amarkhamar/views/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amarkhamar/config/dimensions.dart';
import 'package:amarkhamar/controllers/bindings/controller_index.dart';
import 'package:amarkhamar/routes/routes_name.dart';
import 'package:amarkhamar/themes/themes.dart';
import 'package:amarkhamar/utils/app_constants.dart';
import 'package:amarkhamar/views/widgets/app_button.dart';
import 'package:amarkhamar/views/widgets/spacing.dart';
import 'package:amarkhamar/views/widgets/text_theme_extension.dart';
import '../../../../config/app_colors.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';

class ProjectPaymentSuccessScreen extends StatelessWidget {
  const ProjectPaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.offAllNamed(RoutesName.mainDrawerScreen);
      },
      child: Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
        appBar: CustomAppBar(
          title:storedLanguage['Payment Success']?? "Payment Success",
          fontSize: 20.sp,
          bgColor:
              Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
        ),
        body: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 290.h,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppThemes.getDarkCardColor(),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: -130.h,
                      child: Container(
                        width: 190.w,
                        height: 190.h,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage(
                            "$rootImageDir/confetti.png",
                          ),
                          fit: BoxFit.cover,
                        )),
                      ),
                    ),
                    Positioned(
                      top: -40.h,
                      child: Container(
                        height: 80.h,
                        width: 80.h,
                        padding: EdgeInsets.all(19.h),
                        decoration: BoxDecoration(
                            color: AppThemes.getDarkCardColor(),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Get.isDarkMode
                                    ? AppColors.black80.withOpacity(.6)
                                    : AppColors.mainColor.withOpacity(.6))),
                        child: Image.asset(
                          "$rootImageDir/double_hand.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(storedLanguage['Thank You!']??"Thank You!",
                            style: context.t.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        VSpace(24.h),
                        Padding(
                          padding: Dimensions.kDefaultPadding,
                          child: Text(
                            "We really appreciate you giving us a moment of your time today. Thanks for being with us.",
                            textAlign: TextAlign.center,
                            style: context.t.bodySmall,
                          ),
                        ),
                        VSpace(32.h),
                        Material(
                          color: Colors.transparent,
                          child: AppButton(
                            buttonWidth: 224.w,
                            onTap: () {
                              Get.offAllNamed(RoutesName.mainDrawerScreen);
                            },
                            text: 
                              storedLanguage['Back to Home']??  "Back to Home",
                            style: context.t.bodyMedium
                                ?.copyWith(color: AppColors.whiteColor),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
