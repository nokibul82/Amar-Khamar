import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/bindings/controller_index.dart';
import '../../../../config/app_colors.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../../utils/services/pop_app.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final Connectivity _connectivity = Connectivity();
  Future<void> getFcmToken() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    String getFcm = token.toString();
    if (getFcm != "null" && getFcm.isNotEmpty) {
      await Get.put(FcmController()).saveFcmToken(fcm_token: getFcm);
    }
  }

  @override
  void initState() {
    _connectivity.onConnectivityChanged
        .listen(Get.find<AppController>().updateConnectionStatus);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.put(ProfileController()).getProfile();
      if (HiveHelp.read(Keys.token) != null) {
        getFcmToken();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (_) {
      return GetBuilder<BottomNavController>(builder: (controller) {
        return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              return PopApp.onWillPop();
            },
            child: Scaffold(
              body: controller.currentScreen,
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 24.w, right: 24.w, bottom: 10.h),
                  child: Ink(
                    height: 52.h,
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: _.isDarkMode() == true
                          ? AppColors.darkCardColor
                          : AppColors.mainColor,
                      borderRadius: BorderRadius.circular(60.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkResponse(
                          onTap: () {
                            controller.changeScreen(0);
                          },
                          child: Container(
                            width: 45.h,
                            height: 45.h,
                            padding: EdgeInsets.all(10.h),
                            decoration: BoxDecoration(
                              color: controller.selectedIndex == 0
                                  ? _.isDarkMode() == true
                                      ? AppColors.darkBgColor
                                      : AppColors.whiteColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              controller.selectedIndex == 0
                                  ? "$rootImageDir/home1.png"
                                  : "$rootImageDir/home.png",
                              height: 24.h,
                              color: _.isDarkMode() == true
                                  ? AppColors.black10
                                  : controller.selectedIndex == 0
                                      ? AppColors.blackColor
                                      : AppColors.paragraphColor,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        InkResponse(
                          onTap: () {
                            controller.changeScreen(1);
                          },
                          child: Container(
                            width: 45.h,
                            height: 45.h,
                            padding: EdgeInsets.all(10.h),
                            decoration: BoxDecoration(
                              color: controller.selectedIndex == 1
                                  ? _.isDarkMode() == true
                                      ? AppColors.darkBgColor
                                      : AppColors.whiteColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              controller.selectedIndex == 1
                                  ? "$rootImageDir/transaction1.png"
                                  : "$rootImageDir/transaction.png",
                              height: 24.h,
                              color: _.isDarkMode() == true
                                  ? AppColors.black10
                                  : controller.selectedIndex == 1
                                      ? AppColors.blackColor
                                      : AppColors.paragraphColor,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        InkResponse(
                          onTap: () {
                            controller.changeScreen(2);
                          },
                          child: Container(
                            width: 45.h,
                            height: 45.h,
                            padding: EdgeInsets.all(
                                controller.selectedIndex == 2 ? 8.h : 10.h),
                            decoration: BoxDecoration(
                              color: controller.selectedIndex == 2
                                  ? _.isDarkMode() == true
                                      ? AppColors.darkBgColor
                                      : AppColors.whiteColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              controller.selectedIndex == 2
                                  ? "$rootImageDir/wallet1.png"
                                  : "$rootImageDir/wallet.png",
                              height: 24.h,
                              color: _.isDarkMode() == true
                                  ? AppColors.black10
                                  : controller.selectedIndex == 2
                                      ? AppColors.blackColor
                                      : AppColors.paragraphColor,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        HiveHelp.read(Keys.token) != null
                            ? InkResponse(
                                onTap: () {
                                  controller.changeScreen(3);
                                },
                                child: Container(
                                  width: 45.h,
                                  height: 45.h,
                                  padding: EdgeInsets.all(10.h),
                                  decoration: BoxDecoration(
                                    color: controller.selectedIndex == 3
                                        ? _.isDarkMode() == true
                                            ? AppColors.darkBgColor
                                            : AppColors.whiteColor
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    controller.selectedIndex == 3
                                        ? "$rootImageDir/person2.png"
                                        : "$rootImageDir/person.png",
                                    color: _.isDarkMode() == true
                                        ? AppColors.black10
                                        : controller.selectedIndex == 3
                                            ? AppColors.blackColor
                                            : AppColors.paragraphColor,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              )
                            : InkResponse(
                                onTap: () {
                                  Get.offAllNamed(RoutesName.signUpScreen);
                                  // controller.changeScreen(3);
                                },
                                child: Container(
                                  width: 45.h,
                                  height: 45.h,
                                  padding: EdgeInsets.all(10.h),
                                  decoration: BoxDecoration(
                                    color: controller.selectedIndex == 3
                                        ? _.isDarkMode() == true
                                            ? AppColors.darkBgColor
                                            : AppColors.whiteColor
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    controller.selectedIndex == 3
                                        ? "$rootImageDir/login2.png"
                                        : "$rootImageDir/login.png",
                                    color: _.isDarkMode() == true
                                        ? AppColors.black10
                                        : controller.selectedIndex == 3
                                            ? AppColors.blackColor
                                            : AppColors.paragraphColor,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ));
      });
    });
  }
}
