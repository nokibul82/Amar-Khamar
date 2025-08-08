import 'dart:io';
import 'package:amarkhamar/utils/services/helpers.dart';
import 'package:amarkhamar/views/screens/deposit/deposit_screen.dart';
import 'package:amarkhamar/views/screens/withdraw/withdraw_screen.dart';
import 'package:amarkhamar/views/widgets/mediaquery_extension.dart';
import 'package:amarkhamar/views/widgets/text_theme_extension.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amarkhamar/controllers/bindings/controller_index.dart';
import 'package:amarkhamar/routes/routes_name.dart';
import 'package:intl/intl.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_button.dart';
import '../../widgets/arrow_button.dart';
import '../../widgets/spacing.dart';
import '../transaction/transaction_screen.dart';
import 'drawer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isTapped = false;
  bool _showBalance = false;
  bool _isButtonDisabled = false;
  double _iconPosition = 5.w;
  final double _finalPosition = 193.w - 40.w;
  void _reverseAnimation() {
    Future.delayed(Duration(seconds: 5), () {
      if (mounted)
        setState(() {
          _isTapped = false;
        });

      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted)
          setState(() {
            _showBalance = false;
            _isButtonDisabled = false;
          });
      });
    });
  }

  final int hour = DateTime.now().hour;
  String greetingMessage() {
    if (hour >= 5 && hour < 12) {
      return "Good Morning,";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon,";
    } else {
      return "Good Evening,";
    }
  }

  int selectedIndex = 0;
  String getDeviceToken = "";
  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    getDeviceToken = token.toString();
  }

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    getDeviceTokenToSendNotification();
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AppController>(builder: (appCtrl) {
      return GetBuilder<AuthController>(builder: (_) {
        return GetBuilder<TransactionController>(builder: (transactionCtrl) {
          return GetBuilder<ProfileController>(builder: (profileCtrl) {
            return Scaffold(
                body: Column(
              children: [
                // VSpace(50),
                // SelectableText(getDeviceToken),
                // VSpace(50),
                Container(
                  height: Platform.isAndroid
                      ? context.mQuery.height * .28
                      : context.mQuery.height * .31,
                  decoration: Get.isDarkMode
                      ? BoxDecoration(
                          color: AppColors.darkCardColor,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(16.r)),
                        )
                      : BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFDAFFF6),
                              Color(0xFFC0EFB7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(16.r)),
                          image: DecorationImage(
                            image:
                                AssetImage("$rootImageDir/home_header_bg.png"),
                            opacity: .15,
                            fit: BoxFit.cover,
                          ),
                        ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeArea(
                        bottom: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VSpace(10.h),
                            Padding(
                              padding: Dimensions.kDefaultPadding / 3.5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        drawerController.toggle!();
                                      },
                                      icon: Container(
                                        width: 34.h,
                                        height: 34.h,
                                        padding: EdgeInsets.all(8.5.h),
                                        decoration: BoxDecoration(
                                          color: AppThemes.getDarkBgColor(),
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          border: Border.all(
                                              color: Get.isDarkMode
                                                  ? AppColors.darkCardColorDeep
                                                  : Colors.transparent),
                                        ),
                                        child: Image.asset(
                                          "$rootImageDir/menu.png",
                                          height: 32.h,
                                          width: 32.h,
                                          color: AppThemes.getIconBlackColor(),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      )),
                                  // Material(
                                  //   color: Colors.transparent,
                                  //   child: InkWell(
                                  //     borderRadius: BorderRadius.circular(60.r),
                                  //     onTap: _isButtonDisabled
                                  //         ? null
                                  //         : () {
                                  //             Future.delayed(
                                  //                 Duration(milliseconds: 200),
                                  //                 () {
                                  //               if (mounted)
                                  //                 setState(() {
                                  //                   _isButtonDisabled = true;
                                  //                   _isTapped = true;
                                  //                 });
                                  //             });
                                  //
                                  //             Future.delayed(
                                  //                 Duration(milliseconds: 700),
                                  //                 () {
                                  //               if (mounted)
                                  //                 setState(() {
                                  //                   _showBalance = true;
                                  //                 });
                                  //             });
                                  //             _reverseAnimation();
                                  //           },
                                  //     child: Ink(
                                  //       width: 193.w,
                                  //       height: 40.h,
                                  //       decoration: BoxDecoration(
                                  //         color: AppThemes.getDarkBgColor(),
                                  //         borderRadius:
                                  //             BorderRadius.circular(60.r),
                                  //         border: Border.all(
                                  //             color: Get.isDarkMode
                                  //                 ? AppColors.darkCardColorDeep
                                  //                 : Colors.transparent),
                                  //       ),
                                  //       child: Stack(
                                  //         alignment: Alignment.centerLeft,
                                  //         children: [
                                  //           AnimatedPositioned(
                                  //             duration: const Duration(
                                  //                 milliseconds: 600),
                                  //             left: _isTapped
                                  //                 ? _finalPosition
                                  //                 : _iconPosition,
                                  //             child: AnimatedOpacity(
                                  //               opacity: _isTapped ? .6 : 1.0,
                                  //               duration:
                                  //                   Duration(milliseconds: 500),
                                  //               child: AvatarGlow(
                                  //                 animate: true,
                                  //                 startDelay: const Duration(
                                  //                     milliseconds: 1000),
                                  //                 glowColor: Get.isDarkMode
                                  //                     ? AppColors.greyColor
                                  //                     : AppColors
                                  //                         .secondaryColor,
                                  //                 glowShape: BoxShape.circle,
                                  //                 curve: Curves.fastOutSlowIn,
                                  //                 glowRadiusFactor: .5,
                                  //                 child: Container(
                                  //                   width: 30.h,
                                  //                   height: 30.h,
                                  //                   alignment: Alignment.center,
                                  //                   decoration: BoxDecoration(
                                  //                     color: AppColors
                                  //                         .secondaryColor,
                                  //                     shape: BoxShape.circle,
                                  //                   ),
                                  //                   child: Center(
                                  //                     child: Text(
                                  //                       ProfileController
                                  //                           .to.currency_symbol
                                  //                           .toString(),
                                  //                       textAlign:
                                  //                           TextAlign.center,
                                  //                       style: TextStyle(
                                  //                           color: AppColors
                                  //                               .whiteColor),
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           Center(
                                  //               child: _showBalance
                                  //                   ? AnimatedOpacity(
                                  //                       opacity:
                                  //                           _isTapped == false
                                  //                               ? 0.0
                                  //                               : 1.0,
                                  //                       duration: Duration(
                                  //                           milliseconds: 300),
                                  //                       child: Text(
                                  //                         "${ProfileController.to.balance.toString()}",
                                  //                         style: t.bodySmall
                                  //                             ?.copyWith(
                                  //                           color: AppThemes
                                  //                               .getIconBlackColor(),
                                  //                           fontSize: 14.sp,
                                  //                           fontWeight:
                                  //                               FontWeight.w500,
                                  //                         ),
                                  //                       ),
                                  //                     )
                                  //                   : AnimatedOpacity(
                                  //                       opacity: _isTapped
                                  //                           ? 0.0
                                  //                           : 1.0,
                                  //                       duration: Duration(
                                  //                           milliseconds: 300),
                                  //                       child: Text(
                                  //                         "Tap for Balance",
                                  //                         style: t.bodySmall
                                  //                             ?.copyWith(
                                  //                           color: AppThemes
                                  //                               .getIconBlackColor(),
                                  //                           fontSize: 14.sp,
                                  //                         ),
                                  //                       ),
                                  //                     )),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Text("Amar Khamar",style: t.titleMedium?.copyWith(color: AppColors.darkBgColor),),
                                  IconButton(
                                      onPressed: () {
                                        Get.toNamed(
                                            RoutesName.notificationScreen);
                                      },
                                      icon: Container(
                                        height: 33.h,
                                        width: 33.h,
                                        padding: EdgeInsets.all(8.h),
                                        decoration: BoxDecoration(
                                          color: AppThemes.getDarkBgColor(),
                                          border: Border.all(
                                              color: Get.isDarkMode
                                                  ? AppColors.darkCardColorDeep
                                                  : AppColors.mainColor,
                                              width: Get.isDarkMode ? 1 : .02),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                              "$rootImageDir/notification.png",
                                              color:
                                                  AppThemes.getIconBlackColor(),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildWidget(
                              t,
                              img: "$rootImageDir/wallet.png",
                              text: storedLanguage['Deposit'] ?? "Deposit",
                              onTap: () {
                                Get.to(DepositScreen(isFromBottomNav: false));
                              },
                            ),
                            buildWidget(
                              t,
                              img: "$rootImageDir/payout.png",
                              text: storedLanguage['Withdraw'] ?? "Withdraw",
                              onTap: () {
                                Get.to(() => WithdrawScreen());
                              },
                            ),
                            buildWidget(
                              t,
                              img: "$rootImageDir/plan.png",
                              text: "Plan",
                              onTap: () {
                                Get.toNamed(RoutesName.planInvestScreen);
                              },
                            ),
                            buildWidget(
                              t,
                              img: "$rootImageDir/project.png",
                              text: storedLanguage['Project'] ?? "Project",
                              onTap: () {
                                Get.toNamed(RoutesName.projectInvestScreen);
                              },
                            ),
                          ],
                        ),
                      ),
                      VSpace(24.h),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.secondaryColor,
                    onRefresh: () async {
                      Get.put(ProfileController()).getProfile();
                      transactionCtrl.resetDataAfterSearching();
                      transactionCtrl.getTransactionList(
                          page: 1,
                          transaction_id: "",
                          start_date: "",
                          end_date: "");
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VSpace(20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    selectedIndex = 0;
                                    setState(() {});
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                          storedLanguage['Project Invest'] ??
                                              'Project Invest',
                                          style: t.bodyLarge?.copyWith(
                                            fontSize: 20.sp,
                                            color: selectedIndex == 0
                                                ? AppThemes.getIconBlackColor()
                                                : AppThemes.getParagraphColor(),
                                          )),
                                      Container(
                                        width: 123.w,
                                        height: 2.h,
                                        color: selectedIndex == 0
                                            ? AppColors.secondaryColor
                                            : Colors.transparent,
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    selectedIndex = 1;
                                    setState(() {});
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                          storedLanguage['Plan Invest'] ??
                                              'Plan Invest',
                                          style: t.bodyLarge?.copyWith(
                                            fontSize: 20.sp,
                                            color: selectedIndex == 1
                                                ? AppThemes.getIconBlackColor()
                                                : AppThemes.getParagraphColor(),
                                          )),
                                      Container(
                                        width: 100.w,
                                        height: 2.h,
                                        color: selectedIndex == 1
                                            ? AppColors.secondaryColor
                                            : Colors.transparent,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            VSpace(16.h),
                            if (selectedIndex == 0) ...[
                              InvestWidget(
                                t: t,
                                title: "Harvest Hills Vineyard",
                                description:
                                    "Harvest Hills Vineyard is renowned\nfor its exceptional wines...",
                                img: "$rootImageDir/project_woman.png",
                                onTap: () {
                                  Get.toNamed(RoutesName.projectInvestScreen);
                                },
                              ),
                            ],
                            if (selectedIndex == 1) ...[
                              InvestWidget(
                                t: t,
                                title: "Business Plan",
                                description:
                                    "Uniquely reconceptualize resource\nsucking technology before...",
                                img: "$rootImageDir/plan_woman.png",
                                onTap: () {
                                  Get.toNamed(RoutesName.planInvestScreen);
                                },
                              ),
                            ],
                            if (HiveHelp.read(Keys.ecommerceStatus) == true)
                              VSpace(28.h),
                            if (HiveHelp.read(Keys.ecommerceStatus) == true)
                              Container(
                                width: double.maxFinite,
                                height: 145.h,
                                decoration: Get.isDarkMode
                                    ? BoxDecoration(
                                        color: AppColors.darkCardColor,
                                        borderRadius: Dimensions.kBorderRadius,
                                      )
                                    : BoxDecoration(
                                        color: AppColors.mainColor,
                                        borderRadius: Dimensions.kBorderRadius,
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "$rootImageDir/project_invest_bg.png"),
                                          fit: BoxFit.cover,
                                          opacity: .1,
                                        ),
                                      ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Image.asset(
                                          "$rootEcommerceDir/lemon.png",
                                          width: 143.w,
                                          height: 132.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -50.h,
                                      right: -50.w,
                                      child: Container(
                                        width: 244.w,
                                        height: 221.h,
                                        padding: EdgeInsets.only(
                                            top: 80.h, left: 40.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(140.r),
                                          color: Get.isDarkMode
                                              ? AppColors.darkCardColorDeep
                                              : Color(0xffF3FAF2),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  storedLanguage[
                                                          'Testy & Pure'] ??
                                                      "Testy & Pure",
                                                  style: context.t.bodySmall
                                                      ?.copyWith(
                                                    color: AppThemes
                                                        .getIconBlackColor(),
                                                  ),
                                                ),
                                                HSpace(6.w),
                                                Container(
                                                  height: 1,
                                                  width: 27.w,
                                                  color: AppThemes
                                                      .getIconBlackColor(),
                                                )
                                              ],
                                            ),
                                            VSpace(8.h),
                                            Text(
                                              storedLanguage['Round Lemon'] ??
                                                  "Round Lemon",
                                              style: context.t.bodyLarge,
                                            ),
                                            VSpace(15.h),
                                            ArrowButton(
                                              t: t,
                                              text:
                                                  storedLanguage['Show Now'] ??
                                                      "Show Now",
                                              bgColor: AppColors.secondaryColor,
                                              textColor: AppColors.whiteColor,
                                              arrowColor: AppColors.whiteColor,
                                              onTap: () {
                                                Get.toNamed(
                                                    RoutesName.productScreen);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            VSpace(20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    storedLanguage['Transactions'] ??
                                        'Transactions',
                                    style:
                                        t.bodyLarge?.copyWith(fontSize: 20.sp)),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => TransactionScreen(
                                        isFromHomePage: true));
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: Text(
                                        storedLanguage['See All'] ?? 'See All',
                                        style: t.displayMedium?.copyWith(
                                          color: AppThemes.getBlack50Color(),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            VSpace(5.h),
                            transactionCtrl.isLoading
                                ? buildTransactionLoader(isReverseColor: true)
                                : transactionCtrl.transactionList.isEmpty
                                    ? Center(
                                        child: Container(
                                          height: 140.h,
                                          width: 140.h,
                                          margin: EdgeInsets.only(top: 50.h),
                                          child: Image.asset(
                                            Get.isDarkMode
                                                ? "$rootImageDir/not_found_dark.png"
                                                : "$rootImageDir/not_found.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemCount: transactionCtrl
                                                    .transactionList.length >
                                                12
                                            ? 12
                                            : transactionCtrl
                                                .transactionList.length,
                                        itemBuilder: (context, i) {
                                          var clampedIndex = i.clamp(
                                              i,
                                              transactionCtrl
                                                  .transactionList.length);
                                          var data = transactionCtrl
                                              .transactionList[clampedIndex];
                                          return InkWell(
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    insetPadding: Dimensions
                                                        .kDefaultPadding,
                                                    backgroundColor: AppThemes
                                                        .getDarkBgColor(),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius: Dimensions
                                                          .kBorderRadius,
                                                    ),
                                                    surfaceTintColor:
                                                        AppColors.whiteColor,
                                                    content: Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Positioned(
                                                          top: -60.h,
                                                          left: 0,
                                                          right: 0,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Container(
                                                              height: 90.h,
                                                              width: 90.h,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          24.h),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Get
                                                                            .isDarkMode
                                                                        ? AppColors
                                                                            .black80
                                                                        : AppColors
                                                                            .mainColor),
                                                                color: AppThemes
                                                                    .getDarkCardColor(),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child:
                                                                  Image.asset(
                                                                "$rootImageDir/like.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              double.maxFinite,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              VSpace(60.h),
                                                              Text(
                                                                  storedLanguage[
                                                                          'Transaction Success'] ??
                                                                      "Transaction Success",
                                                                  style: context
                                                                      .t
                                                                      .titleSmall),
                                                              VSpace(12.h),
                                                              Text(
                                                                  "${data.currency_symbol}${Helpers.numberFormat(data.amount.toString())}",
                                                                  style: context
                                                                      .t
                                                                      .titleLarge
                                                                      ?.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w600)),
                                                              VSpace(32.h),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    storedLanguage[
                                                                            'Transaction Id'] ??
                                                                        "Transaction Id",
                                                                    style: context
                                                                        .t
                                                                        .displayMedium
                                                                        ?.copyWith(
                                                                            color:
                                                                                AppThemes.getParagraphColor()),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child: SelectableText(
                                                                          "${data.trxId}",
                                                                          maxLines:
                                                                              1,
                                                                          style: context
                                                                              .t
                                                                              .displayMedium),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              VSpace(8.h),
                                                              Container(
                                                                height: 1,
                                                                width: double
                                                                    .maxFinite,
                                                                color: Get
                                                                        .isDarkMode
                                                                    ? AppColors
                                                                        .black80
                                                                    : AppColors
                                                                        .pageBgColor,
                                                              ),
                                                              VSpace(20.h),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    storedLanguage[
                                                                            'Amount'] ??
                                                                        "Amount",
                                                                    style: context
                                                                        .t
                                                                        .displayMedium
                                                                        ?.copyWith(
                                                                            color:
                                                                                AppThemes.getParagraphColor()),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child: Text(
                                                                          "${Helpers.numberFormat(data.amount.toString())} ${data.base_currency}",
                                                                          maxLines:
                                                                              1,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          style: context
                                                                              .t
                                                                              .displayMedium),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              VSpace(8.h),
                                                              Container(
                                                                height: 1,
                                                                width: double
                                                                    .maxFinite,
                                                                color: Get
                                                                        .isDarkMode
                                                                    ? AppColors
                                                                        .black80
                                                                    : AppColors
                                                                        .pageBgColor,
                                                              ),
                                                              VSpace(20.h),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    storedLanguage[
                                                                            'Charge'] ??
                                                                        "Charge",
                                                                    style: context
                                                                        .t
                                                                        .displayMedium
                                                                        ?.copyWith(
                                                                            color:
                                                                                AppThemes.getParagraphColor()),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child: Text(
                                                                          "${Helpers.numberFormat(data.charge.toString())} ${data.base_currency}",
                                                                          maxLines:
                                                                              1,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          style: context
                                                                              .t
                                                                              .displayMedium
                                                                              ?.copyWith(color: AppColors.redColor)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              VSpace(8.h),
                                                              Container(
                                                                height: 1,
                                                                width: double
                                                                    .maxFinite,
                                                                color: Get
                                                                        .isDarkMode
                                                                    ? AppColors
                                                                        .black80
                                                                    : AppColors
                                                                        .pageBgColor,
                                                              ),
                                                              VSpace(20.h),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    storedLanguage[
                                                                            'Gateway'] ??
                                                                        "Gateway",
                                                                    style: context
                                                                        .t
                                                                        .displayMedium
                                                                        ?.copyWith(
                                                                            color:
                                                                                AppThemes.getParagraphColor()),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child: Text(
                                                                          "${data.remarks}",
                                                                          maxLines:
                                                                              1,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          style: context
                                                                              .t
                                                                              .displayMedium),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              VSpace(8.h),
                                                              Container(
                                                                height: 1,
                                                                width: double
                                                                    .maxFinite,
                                                                color: Get
                                                                        .isDarkMode
                                                                    ? AppColors
                                                                        .black80
                                                                    : AppColors
                                                                        .pageBgColor,
                                                              ),
                                                              VSpace(20.h),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    storedLanguage[
                                                                            'Date'] ??
                                                                        "Date",
                                                                    style: context
                                                                        .t
                                                                        .displayMedium
                                                                        ?.copyWith(
                                                                            color:
                                                                                AppThemes.getParagraphColor()),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child: Text(
                                                                          "${DateFormat('d MMMM, yyyy').format(DateTime.parse(data.createdAt.toString()))}",
                                                                          maxLines:
                                                                              1,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          style: context
                                                                              .t
                                                                              .displayMedium),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              VSpace(40.h),
                                                              AppButton(
                                                                onTap: () {
                                                                  Get.back();
                                                                },
                                                                text: storedLanguage[
                                                                        'Close'] ??
                                                                    "Close",
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Ink(
                                              width: double.maxFinite,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 14.h),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 36.h,
                                                    height: 36.h,
                                                    child: Image.asset(
                                                      data.trxType == "+"
                                                          ? "$rootImageDir/increment.png"
                                                          : "$rootImageDir/decrement.png",
                                                    ),
                                                  ),
                                                  HSpace(12.w),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 10,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      data.remarks
                                                                          .toString(),
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                      style: t
                                                                          .displayMedium),
                                                                  VSpace(3.h),
                                                                  Text(
                                                                    "${DateFormat('d MMMM, yyyy').format(DateTime.parse(data.createdAt.toString()))}",
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: t
                                                                        .bodySmall
                                                                        ?.copyWith(
                                                                      color: AppThemes
                                                                          .getBlack50Color(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            HSpace(3.w),
                                                            Flexible(
                                                              flex: 7,
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                  "${Helpers.numberFormat(data.amount.toString())} ${data.base_currency}",
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: t
                                                                      .displayMedium,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 12.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    color: Get
                                                                            .isDarkMode
                                                                        ? AppColors
                                                                            .darkCardColorDeep
                                                                        : AppColors
                                                                            .black20,
                                                                    width: Get
                                                                            .isDarkMode
                                                                        ? .6
                                                                        : .2)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ));
          });
        });
      });
    });
  }

  Container topProjectWidget(TextTheme t, storedLanguage,
      {required String img,
      AlignmentGeometry? alignment,
      EdgeInsetsGeometry? padding,
      required int selectedIndex}) {
    return Container(
      height: 118.h,
      width: 118.h,
      decoration: BoxDecoration(
          borderRadius: Dimensions.kBorderRadius / 2,
          image: DecorationImage(
            image: AssetImage(img),
            opacity: Get.isDarkMode ? .8 : 1,
            fit: BoxFit.cover,
          )),
      child: Stack(
        alignment: alignment ?? Alignment.bottomCenter,
        children: [
          Padding(
            padding: padding ?? EdgeInsets.only(bottom: 8.h),
            child: ArrowButton(
              onTap: () {
                if (selectedIndex == 0) {
                  Get.toNamed(RoutesName.projectInvestScreen);
                } else {
                  Get.toNamed(RoutesName.planInvestScreen);
                }
              },
              height: 26.h,
              width: 102.w,
              borderRadius: BorderRadius.circular(4.r),
              t: t,
              text: storedLanguage['Invest Now'] ?? "Invest Now",
              style: t.bodySmall?.copyWith(
                fontSize: 12.sp,
                color: AppThemes.getIconBlackColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWidget(TextTheme t,
      {required String img, required String text, void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              width: 50.h,
              height: 50.h,
              padding: EdgeInsets.all(13.r),
              decoration: BoxDecoration(
                color: AppThemes.getDarkBgColor(),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Get.isDarkMode
                        ? AppColors.darkCardColorDeep
                        : Colors.transparent),
              ),
              child: Image.asset(
                img,
                fit: BoxFit.fitHeight,
                color: AppColors.secondaryColor,
              ),
            ),
            VSpace(8.h),
            Text(
              text,
              style: t.bodySmall?.copyWith(
                color: AppThemes.getIconBlackColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvestWidget extends StatelessWidget {
  const InvestWidget({
    super.key,
    required this.t,
    required this.title,
    required this.description,
    required this.img,
    this.onTap,
  });

  final TextTheme t;
  final String title;
  final String description;
  final String img;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 155.h,
      padding: EdgeInsets.all(8.h),
      decoration: Get.isDarkMode
          ? BoxDecoration(
              color: AppColors.darkCardColor,
              borderRadius: Dimensions.kBorderRadius,
            )
          : BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: Dimensions.kBorderRadius,
              image: DecorationImage(
                image: AssetImage("$rootImageDir/project_invest_bg.png"),
                fit: BoxFit.cover,
                opacity: .1,
              ),
            ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 8.h,
                bottom: 8.h,
                left: 8.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: t.bodyMedium),
                  Text(description, style: t.bodySmall),
                  ArrowButton(
                    bgColor: Get.isDarkMode
                        ? AppColors.darkBgColor
                        : AppColors.whiteColor,
                    t: t,
                    text: "Invest Now",
                    onTap: onTap,
                  ),
                ],
              ),
            ),
          ),
          HSpace(12.w),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 105.h,
                width: 105.h,
                decoration: BoxDecoration(
                  color:
                      Get.isDarkMode ? AppColors.black80 : AppColors.whiteColor,
                  shape: BoxShape.circle,
                ),
              ),
              ClipOval(
                child: Image.asset(
                  img,
                  height: 130.h,
                  width: 130.h,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget buildTransactionLoader(
    {int? itemCount = 8, bool? isReverseColor = false, double? imgSize}) {
  return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, i) {
        return Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isReverseColor == true
                ? AppThemes.getFillColor()
                : AppThemes.getDarkCardColor(),
            borderRadius: Dimensions.kBorderRadius,
            border: Border.all(
                color: AppThemes.borderColor(),
                width: Dimensions.appThinBorder),
          ),
          child: Row(
            children: [
              Container(
                width: imgSize ?? 40.h,
                height: imgSize ?? 40.h,
                padding: EdgeInsets.all(10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Get.isDarkMode
                      ? AppColors.darkBgColor
                      : isReverseColor == true
                          ? AppColors.whiteColor
                          : AppColors.fillColorColor,
                ),
              ),
              HSpace(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10.h,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkBgColor
                            : isReverseColor == true
                                ? AppColors.whiteColor
                                : AppColors.fillColorColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    VSpace(5.h),
                    Container(
                      height: 10.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkBgColor
                            : isReverseColor == true
                                ? AppColors.whiteColor
                                : AppColors.fillColorColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}
