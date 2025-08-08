import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:amarkhamar/config/dimensions.dart';
import 'package:amarkhamar/views/widgets/text_theme_extension.dart';
import 'package:photo_view/photo_view.dart';
import '../../../../config/app_colors.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../controllers/verification_controller.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class ProfileSettingScreen extends StatefulWidget {
  final bool? isFromHomePage;
  final bool? isIdentityVerification;
  const ProfileSettingScreen(
      {super.key,
      this.isFromHomePage = false,
      this.isIdentityVerification = false});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  var controller = Get.put(ProfileController());
  @override
  void initState() {
    if (controller.profileList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        controller.getProfile();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (HiveHelp.read(Keys.isDark) == null) {
      Get.find<AppController>().selectedIndex = 0;
    } else if (HiveHelp.read(Keys.isDark) == true) {
      Get.find<AppController>().selectedIndex = 1;
    } else if (HiveHelp.read(Keys.isDark) == false) {
      Get.find<AppController>().selectedIndex = 2;
    }
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AppController>(builder: (_) {
      var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
      return GetBuilder<ProfileController>(builder: (profileController) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (widget.isIdentityVerification == true) {
              Get.offAllNamed(RoutesName.mainDrawerScreen);
            } else {
              Get.back();
            }
          },
          child: Scaffold(
            backgroundColor:
                Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
            appBar: CustomAppBar(
              bgColor: Get.isDarkMode
                  ? AppColors.darkBgColor
                  : AppColors.pageBgColor,
              title: storedLanguage['Profile'] ?? "Profile",
              leading: widget.isFromHomePage == true
                  ? IconButton(
                      onPressed: () {
                        if (widget.isIdentityVerification == true) {
                          Get.offAllNamed(RoutesName.mainDrawerScreen);
                        } else {
                          Get.back();
                        }
                      },
                      icon: Image.asset(
                        "$rootImageDir/back.png",
                        height: 22.h,
                        width: 22.h,
                        color: Get.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.blackColor,
                        fit: BoxFit.fitHeight,
                      ))
                  : const SizedBox(),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: Dimensions.kDefaultPadding,
                child: Column(
                  children: [
                    VSpace(10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${profileController.userName}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.bodyMedium),
                              VSpace(4.h),
                              Text("${profileController.userEmail}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.bodySmall?.copyWith(
                                      color: Get.isDarkMode
                                          ? AppColors.black20
                                          : Color(0xff4A4A4A))),
                              VSpace(20.h),
                              SizedBox(
                                width: 144.w,
                                child: LinearPercentIndicator(
                                  animation: true,
                                  animationDuration: 1600,
                                  padding: EdgeInsets.zero,
                                  lineHeight: 8.h,
                                  percent: profileController.percent,
                                  barRadius: Radius.circular(20.r),
                                  backgroundColor: Get.isDarkMode
                                      ? AppColors.darkCardColorDeep
                                      : AppColors.mainColor,
                                  progressColor: AppColors.secondaryColor,
                                ),
                              ),
                              VSpace(12.h),
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                    begin: 0,
                                    end: profileController.percent * 100),
                                duration: const Duration(milliseconds: 1600),
                                builder: (context, value, child) {
                                  return Text(
                                    "${value.toInt()}% Complete Profile",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.t.bodySmall,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (Get.find<ProfileController>().userPhoto !=
                                        '' &&
                                    !Get.find<ProfileController>()
                                        .userPhoto
                                        .contains("default")) {
                                  Get.to(() => Scaffold(
                                      appBar: const CustomAppBar(title: ""),
                                      body: PhotoView(
                                        imageProvider: NetworkImage(
                                            Get.find<ProfileController>()
                                                .userPhoto),
                                      )));
                                } else {
                                  Get.to(() => Scaffold(
                                      appBar: const CustomAppBar(title: ""),
                                      body: PhotoView(
                                        imageProvider: AssetImage(
                                            "$rootImageDir/demo_avatar.png"),
                                      )));
                                }
                              },
                              child: Container(
                                height: 76.h,
                                width: 76.h,
                                padding: EdgeInsets.all(16.h),
                                decoration: BoxDecoration(
                                  color: Get.isDarkMode
                                      ? AppColors.darkCardColor
                                      : AppColors.mainColor,
                                  borderRadius: Dimensions.kBorderRadius,
                                ),
                                child: Get.find<ProfileController>()
                                        .userPhoto
                                        .contains("default")
                                    ? Image.asset(
                                        "$rootImageDir/demo_avatar.png",
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                Dimensions.kBorderRadius / 2.1,
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                Get.find<ProfileController>()
                                                    .userPhoto,
                                              ),
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                              ),
                            ),
                            VSpace(16.h),
                            InkWell(
                              borderRadius: Dimensions.kBorderRadius / 2,
                              onTap: () {
                                Get.toNamed(RoutesName.editProfileScreen);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  borderRadius: Dimensions.kBorderRadius / 2,
                                  border: Border.all(
                                      color: Get.isDarkMode
                                          ? AppColors.darkCardColorDeep
                                          : AppColors.mainColor),
                                  color: Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "$rootImageDir/profile_edit.png",
                                      fit: BoxFit.cover,
                                      height: 14.h,
                                      width: 14.h,
                                      color: AppThemes.getIconBlackColor(),
                                    ),
                                    HSpace(8.w),
                                    Text(
                                      storedLanguage['Edit Profile'] ??
                                          "Edit Profile",
                                      style: t.bodySmall?.copyWith(
                                          color: AppThemes.getIconBlackColor()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    VSpace(40.h),

                    // FOOTER PORTION
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12.h,
                              height: 12.h,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Get.isDarkMode
                                          ? AppColors.black70
                                          : AppColors.secondaryColor,
                                      width: 2.h)),
                            ),
                            Expanded(
                              child: Container(
                                height: 2.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Get.isDarkMode
                                          ? AppColors.black70
                                          : AppColors
                                              .secondaryColor,
                                      AppColors.secondaryColor.withOpacity(
                                          0),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              storedLanguage['Dark Mode'] ?? "Dark Mode",
                              style: context.t.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Container(
                                height: 2.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.mainColor.withOpacity(0),
                                      Get.isDarkMode
                                          ? AppColors.black70
                                          : AppColors.secondaryColor,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 12.h,
                              height: 12.h,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Get.isDarkMode
                                          ? AppColors.black70
                                          : AppColors.secondaryColor,
                                      width: 2.h)),
                            ),
                          ],
                        ),
                        VSpace(16.h),
                        buildThemeWidget(_, context),
                        VSpace(40.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 20.h),
                          decoration: BoxDecoration(
                            color: AppThemes.getDarkCardColor(),
                            borderRadius: Dimensions.kBorderRadius,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                storedLanguage['Profile Settings'] ??
                                    "Profile Settings",
                                style: t.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.sp),
                              ),
                              VSpace(25.h),
                              widget.isIdentityVerification == true
                                  ? buildWidget(t, storedLanguage)
                                  : buildWidget2(t, storedLanguage),
                            ],
                          ),
                        ),
                        if (widget.isIdentityVerification == true) VSpace(40.h),
                        if (widget.isIdentityVerification == true)
                          Text(
                            "N.B. Please click on ''KYC Information'' to complete your identity verification.",
                            style: context.t.displayMedium
                                ?.copyWith(color: AppColors.redColor),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    });
  }

  Container buildThemeWidget(AppController _, BuildContext context) {
    return Container(
      height: 48.h,
      width: double.maxFinite,
      padding: EdgeInsets.all(6.h),
      decoration: BoxDecoration(
        color: AppThemes.getDarkCardColor(),
        borderRadius: Dimensions.kBorderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: Dimensions.kBorderRadius / 2,
              onTap: () {
                _.selectedIndex = 0;
                _.onChanged(null);
                _.update();
              },
              child: Ink(
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 25.w),
                decoration: BoxDecoration(
                  color: _.selectedIndex == 0
                      ? Get.isDarkMode
                          ? AppColors.darkBgColor
                          : AppColors.mainColor
                      : Colors.transparent,
                  borderRadius: Dimensions.kBorderRadius / 2,
                ),
                child: Text("Auto",
                    style: context.t.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        color: _.selectedIndex == 0
                            ? AppColors.blackColor
                            : Get.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.blackColor)),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: Dimensions.kBorderRadius / 2,
              onTap: () {
                _.selectedIndex = 1;
                _.onChanged(true);
                _.update();
              },
              child: Ink(
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 25.w),
                decoration: BoxDecoration(
                  color: _.selectedIndex == 1
                      ? Get.isDarkMode
                          ? AppColors.darkBgColor
                          : AppColors.mainColor
                      : Colors.transparent,
                  borderRadius: Dimensions.kBorderRadius / 2,
                ),
                child: Text("On",
                    style: context.t.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        color: _.selectedIndex == 1
                            ? AppColors.whiteColor
                            : Get.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.blackColor)),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: Dimensions.kBorderRadius / 2,
              onTap: () {
                _.selectedIndex = 2;
                _.onChanged(false);
                _.update();
              },
              child: Ink(
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 25.w),
                decoration: BoxDecoration(
                  color: _.selectedIndex == 2
                      ? AppColors.mainColor
                      : Colors.transparent,
                  borderRadius: Dimensions.kBorderRadius / 2,
                ),
                child: Text("Off",
                    style: context.t.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        color: _.selectedIndex == 2
                            ? AppColors.blackColor
                            : Get.isDarkMode
                                ? AppColors.mainColor
                                : AppColors.blackColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListView buildWidget2(TextTheme t, dynamic storedLanguage) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 7,
        itemBuilder: (context, i) {
          if(i==4 || i == 5){
            return SizedBox.shrink();
          }
          return ListTile(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: Dimensions.kBorderRadius,
            ),
            onTap: () {
              if (i == 0) {
                Get.toNamed(RoutesName.notificationPermissionScreen);
              }
              if (i == 1) {
                Get.toNamed(RoutesName.editProfileScreen);
              } else if (i == 2) {
                Get.toNamed(RoutesName.changePasswordScreen);
              } else if (i == 3) {
                Get.find<VerificationController>().getVerificationList();
                Get.toNamed(RoutesName.verificationListScreen);
              } else if (i == 4) {
                Get.find<VerificationController>().getTwoFa();
                Get.toNamed(RoutesName.twoFaVerificationScreen);
              } else if (i == 5) {
                Get.toNamed(RoutesName.deleteAccountScreen);
              } else if (i == 6) {
                buildLogoutDialog(context, t, storedLanguage);
              }
            },
            leading: Container(
              height: i == 2 ? 38.h : 36.h,
              width: i == 2 ? 38.h : 36.h,
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                color: Get.isDarkMode
                    ? AppColors.darkBgColor
                    : AppColors.fillColorColor,
              ),
              child: i == 0
                  ? Image.asset(
                      "$rootImageDir/notification.png",
                      color: AppThemes.getIconBlackColor(),
                    )
                  : i == 1
                      ? Image.asset(
                          "$rootImageDir/profile_edit.png",
                          color: AppThemes.getIconBlackColor(),
                        )
                      : i == 2
                          ? Image.asset(
                              "$rootImageDir/lock_main.png",
                              color: AppThemes.getIconBlackColor(),
                            )
                          : i == 3
                              ? Image.asset(
                                  "$rootImageDir/verification.png",
                                  color: AppThemes.getIconBlackColor(),
                                )
                              : i == 4
                                  ? Image.asset(
                                      "$rootImageDir/2fa.png",
                                      color: AppThemes.getIconBlackColor(),
                                    )
                                  : i == 5
                                      ? Image.asset(
                                          "$rootEcommerceDir/delete_account.png",
                                          color: AppThemes.getIconBlackColor(),
                                        )
                                      : Image.asset(
                                          "$rootImageDir/log_out.png",
                                          color: AppColors.redColor,
                                        ),
            ),
            title: Text(
                i == 0
                    ? storedLanguage['Notification Settings'] ??
                        "Notification Settings"
                    : i == 1
                        ? storedLanguage['Edit Profile'] ?? "Edit Profile"
                        : i == 2
                            ? storedLanguage['Change Password'] ??
                                "Change Password"
                            : i == 3
                                ? storedLanguage['KYC information'] ??
                                    "KYC information"
                                : i == 4
                                    ? storedLanguage['2FA Security'] ??
                                        "2FA Security"
                                    : i == 5
                                        ? storedLanguage['Delete Account'] ??
                                            "Delete Account"
                                        : storedLanguage['Log Out'] ??
                                            "Log Out",
                style: t.displayMedium),
            trailing: i == 6
                ? const SizedBox.shrink()
                : Container(
                    height: 32.h,
                    width: 32.h,
                    padding: EdgeInsets.all(8.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: Get.isDarkMode
                          ? AppColors.darkBgColor
                          : AppColors.fillColorColor,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 14.h,
                    ),
                  ),
          );
        });
  }

  ListView buildWidget(TextTheme t, dynamic storedLanguage) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, i) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: Dimensions.kBorderRadius,
            ),
            onTap: () {
              if (i == 0) {
                Get.toNamed(RoutesName.changePasswordScreen);
              } else if (i == 1) {
                Get.find<VerificationController>().getVerificationList();
                Get.toNamed(RoutesName.verificationListScreen);
              } else if (i == 2) {
                buildLogoutDialog(context, t, storedLanguage);
              }
            },
            leading: Container(
              height: 36.h,
              width: 36.h,
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                color: Get.isDarkMode
                    ? AppColors.darkBgColor
                    : AppColors.fillColorColor,
              ),
              child: i == 0
                  ? Image.asset(
                      "$rootImageDir/lock_main.png",
                      color: AppThemes.getIconBlackColor(),
                    )
                  : i == 1
                      ? Image.asset(
                          "$rootImageDir/verification.png",
                          color: AppThemes.getIconBlackColor(),
                        )
                      : Image.asset(
                          "$rootImageDir/log_out.png",
                          color: AppColors.redColor,
                        ),
            ),
            title: Text(
                i == 0
                    ? storedLanguage['Change Password'] ?? "Change Password"
                    : i == 1
                        ? storedLanguage['KYC information'] ?? "KYC information"
                        : storedLanguage['Log Out'] ?? "Log Out",
                style: t.displayMedium),
            trailing: i == 2
                ? const SizedBox.shrink()
                : Container(
                    height: 32.h,
                    width: 32.h,
                    padding: EdgeInsets.all(8.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: Get.isDarkMode
                          ? AppColors.darkBgColor
                          : AppColors.fillColorColor,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 14.h,
                    ),
                  ),
          );
        });
  }
}

Future<dynamic> buildLogoutDialog(
    BuildContext context, TextTheme t, dynamic storedLanguage) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          storedLanguage['Log Out'] ?? "Log Out",
          style: t.bodyLarge?.copyWith(fontSize: 20.sp),
        ),
        content: Text(
          storedLanguage['Do you want to Log Out?'] ??
              "Do you want to Log Out?",
          style: t.bodyMedium,
        ),
        actions: [
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                storedLanguage['No'] ?? "No",
                style: t.bodyLarge,
              )),
          MaterialButton(
              onPressed: () async {
                HiveHelp.remove(Keys.token);
                Get.offAllNamed(RoutesName.loginScreen);
              },
              child: Text(
                storedLanguage['Yes'] ?? "Yes",
                style: t.bodyLarge,
              )),
        ],
      );
    },
  );
}
