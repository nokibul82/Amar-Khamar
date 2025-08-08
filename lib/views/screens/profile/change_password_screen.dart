import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/profile_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};

    return Scaffold(
      backgroundColor:
          Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
      appBar: CustomAppBar(
        bgColor: Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
        title: storedLanguage['Change Password'] ?? "Change Password",
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VSpace(Dimensions.screenHeight * .03),
            Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VSpace(42.h),
                  Text(storedLanguage['Current Password'] ?? "Current Password",
                      style: t.displayMedium),
                  VSpace(10.h),
                  GetBuilder<ProfileController>(builder: (_) {
                    return Container(
                      height: 50.h,
                      width: double.maxFinite,
                      padding: EdgeInsets.only(left: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: Dimensions.kBorderRadius,
                        border: Border.all(
                            color: AppThemes.getSliderInactiveColor(),
                            width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 20.h,
                            color: Get.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.textFieldHintColor,
                          ),
                          Expanded(
                            child: CustomTextField(
                              isBorderColor: false,
                              isOnlyBorderColor: false,
                              height: 50.h,
                              obsCureText:
                                  controller.currentPassShow ? true : false,
                              hintext:
                                  storedLanguage['Enter Current Password'] ??
                                      "Enter Current Password",
                              controller:
                                  controller.currentPassEditingController,
                              onChanged: (v) {
                                controller.currentPassVal.value = v;
                              },
                              bgColor: Colors.transparent,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                controller.currentPassObscure();
                              },
                              icon: Image.asset(
                                controller.currentPassShow
                                    ? "$rootImageDir/hide.png"
                                    : "$rootImageDir/show.png",
                                height: 20.h,
                                width: 20.w,
                              )),
                        ],
                      ),
                    );
                  }),
                  VSpace(24.h),
                  Text(storedLanguage['New Password'] ?? "New Password",
                      style: t.displayMedium),
                  VSpace(10.h),
                  GetBuilder<ProfileController>(builder: (controller) {
                    return Container(
                      height: 50.h,
                      width: double.maxFinite,
                      padding: EdgeInsets.only(left: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: Dimensions.kBorderRadius,
                        border: Border.all(
                            color: AppThemes.getSliderInactiveColor(),
                            width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 20.h,
                            color: Get.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.textFieldHintColor,
                          ),
                          Expanded(
                            child: CustomTextField(
                              isBorderColor: false,
                              isOnlyBorderColor: false,
                              height: 50.h,
                              obsCureText:
                                  controller.isNewPassShow ? true : false,
                              hintext: storedLanguage['Enter New Password'] ??
                                  "Enter New Password",
                              controller: controller.newPassEditingController,
                              onChanged: (v) {
                                controller.newPassVal.value = v;
                              },
                              bgColor: Colors.transparent,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                controller.newPassObscure();
                              },
                              icon: Image.asset(
                                controller.isNewPassShow
                                    ? "$rootImageDir/hide.png"
                                    : "$rootImageDir/show.png",
                                height: 20.h,
                                width: 20.w,
                              )),
                        ],
                      ),
                    );
                  }),
                  VSpace(24.h),
                  Text(storedLanguage['Confirm Password'] ?? "Confirm Password",
                      style: t.displayMedium),
                  VSpace(10.h),
                  GetBuilder<ProfileController>(builder: (_) {
                    return Container(
                        height: 50.h,
                        width: double.maxFinite,
                        padding: EdgeInsets.only(left: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: Dimensions.kBorderRadius,
                          border: Border.all(
                              color: AppThemes.getSliderInactiveColor(),
                              width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 20.h,
                              color: Get.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.textFieldHintColor,
                            ),
                            Expanded(
                              child: CustomTextField(
                                isBorderColor: false,
                                isOnlyBorderColor: false,
                                height: 50.h,
                                obsCureText:
                                    controller.isConfirmPassShow ? true : false,
                                hintext: storedLanguage['Confirm Password'] ??
                                    "Confirm Password",
                                controller: controller.confirmEditingController,
                                onChanged: (v) {
                                  controller.confirmPassVal.value = v;
                                },
                                bgColor: Colors.transparent,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  controller.confirmPassObscure();
                                },
                                icon: Image.asset(
                                  controller.isConfirmPassShow
                                      ? "$rootImageDir/hide.png"
                                      : "$rootImageDir/show.png",
                                  height: 20.h,
                                  width: 20.w,
                                )),
                          ],
                        ));
                  }),
                  VSpace(40.h),
                  GetBuilder<ProfileController>(builder: (controller) {
                    return InkWell(
                      onTap: controller.isLoading
                          ? null
                          : () {
                              if (controller.currentPassVal.value.isEmpty) {
                                Helpers.showSnackBar(
                                    msg: "Current Password is required");
                              } else if (controller.newPassVal.value.isEmpty) {
                                Helpers.showSnackBar(
                                    msg: "New Password is required");
                              } else if (controller
                                  .confirmPassVal.value.isEmpty) {
                                Helpers.showSnackBar(
                                    msg: "Confirm Password is required");
                              } else {
                                Helpers.hideKeyboard();
                                controller.validateUpdatePass(context);
                              }
                            },
                      borderRadius: Dimensions.kBorderRadius,
                      child: Ink(
                        width: double.maxFinite,
                        height: Dimensions.buttonHeight,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: Dimensions.kBorderRadius,
                        ),
                        child: Center(
                          child: controller.isLoading
                              ? Helpers.appLoader(color: AppColors.whiteColor,isButton: true)
                              : Text(
                                  storedLanguage['Update Password'] ??
                                      "Update Password",
                                  style: t.bodyLarge
                                      ?.copyWith(color: AppColors.whiteColor),
                                ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
