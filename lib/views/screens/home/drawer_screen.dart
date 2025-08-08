import 'package:amarkhamar/controllers/app_controller.dart';
import 'package:amarkhamar/controllers/product_manage_controller.dart';
import 'package:amarkhamar/controllers/profile_controller.dart';
import 'package:amarkhamar/themes/themes.dart';
import 'package:amarkhamar/views/widgets/spacing.dart';
import 'package:amarkhamar/views/widgets/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../../../config/app_colors.dart';
import '../../../routes/page_index.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';

final drawerController = ZoomDrawerController();

class MainDrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (_) {
      return ZoomDrawer(
        controller: drawerController,
        mainScreen: BottomNavBar(),
        menuScreen: DrawerScreen(),
        angle: 0,
        slideWidth: 300.w,
        showShadow: true,
        mainScreenTapClose: true,
        androidCloseOnBackTap: true,
        drawerShadowsBackgroundColor: _.isDarkMode() == true
            ? AppColors.darkCardColor
            : Color(0xffffffff),
        menuBackgroundColor: _.isDarkMode() == true
            ? AppColors.darkBgColor
            : AppColors.mainColor,
      );
    });
  }
}

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ProfileController>(builder: (profileCtrl) {
      return GetBuilder<AppController>(builder: (_) {
        return Scaffold(
          backgroundColor: _.isDarkMode() == true
              ? AppColors.darkBgColor
              : AppColors.mainColor.withOpacity(.9),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 100.h),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15.w),
                      margin: EdgeInsets.only(right: 20.w),
                      decoration: BoxDecoration(
                        color: AppThemes.getDarkCardColor(),
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(32.r)),
                      ),
                      child: ListTile(
                        visualDensity: VisualDensity(
                          vertical: -3.2.h,
                        ),
                        onTap: () {},
                        leading: Image.asset(
                          "$rootImageDir/home.png",
                          height: 19.h,
                          width: 19.h,
                          fit: BoxFit.cover,
                          color: AppColors.secondaryColor,
                        ),
                        title: Text(storedLanguage['Home'] ?? "Home",
                            style: context.t.displayMedium?.copyWith(
                                fontSize: 18.sp,
                                color: AppColors.secondaryColor)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildDrawerTile(context,
                              imgSize: 22.h,
                              imgPath: "plan_invest_history",
                              title: storedLanguage['Plan History'] ??
                                  "Plan History", onTap: () {
                            Get.toNamed(RoutesName.planinvestmentHistoryScreen);
                          }),
                          buildDrawerTile(context,
                              imgSize: 19.h,
                              imgPath: "project_invest_history",
                              title: storedLanguage['Project History'] ??
                                  "Project History", onTap: () {
                            Get.toNamed(
                                RoutesName.projectInvestmentHistoryScreen);
                          }),
                          if (HiveHelp.read(Keys.ecommerceStatus) == true)
                            Container(
                              margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                              height: 1.h,
                              width: 190.w,
                              color: _.isDarkMode() == true
                                  ? AppColors.darkCardColorDeep
                                  : AppColors.secondaryColor,
                            ),
                          if (HiveHelp.read(Keys.ecommerceStatus) == true)
                            buildDrawerTile(context,
                                imgSize: 19.h,
                                isFromShop: true,
                                imgPath: "product",
                                title: storedLanguage['Products'] ?? "Products",
                                onTap: () {
                              Get.toNamed(RoutesName.productScreen);
                            }),
                          if (HiveHelp.read(Keys.ecommerceStatus) == true)
                            buildDrawerTile(context,
                                imgSize: 19.h,
                                isFromShop: true,
                                imgPath: "orders",
                                title: storedLanguage['My Orders'] ??
                                    "My Orders", onTap: () {
                              Get.toNamed(RoutesName.myOrdersScreen);
                            }),
                          if (HiveHelp.read(Keys.ecommerceStatus) == true)
                            buildDrawerTile(context,
                                imgSize: 19.h,
                                isFromShop: true,
                                imgPath: "love",
                                title: storedLanguage['WishList'] ?? "WishList",
                                onTap: () {
                              Get.toNamed(RoutesName.wishlistScreen);
                            }),
                          if (HiveHelp.read(Keys.ecommerceStatus) == true)
                            buildDrawerTile(context,
                                imgSize: 19.h,
                                isFromShop: true,
                                imgPath: "addCart",
                                title: storedLanguage['My Cart'] ?? "My Cart",
                                onTap: () async {
                              await ProductManageController.to
                                  .calculateAmount();
                              Get.toNamed(RoutesName.myCartScreen);
                            }),
                          Container(
                            margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                            height: 1.h,
                            width: 190.w,
                            color: _.isDarkMode() == true
                                ? AppColors.darkCardColorDeep
                                : AppColors.secondaryColor,
                          ),
                          buildDrawerTile(context,
                              imgSize: 19.h,
                              imgPath: "deposit_history",
                              title: storedLanguage['Deposit History'] ??
                                  "Deposit History", onTap: () {
                            Get.toNamed(RoutesName.depositHistoryScreen);
                          }),
                          buildDrawerTile(context,
                              imgSize: 19.h,
                              imgPath: "payout_history",
                              title: storedLanguage['Withdraw History'] ??
                                  "Withdraw History", onTap: () {
                            Get.toNamed(RoutesName.withdrawHistoryScreen);
                          }),
                          Container(
                            margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                            height: 1.h,
                            width: 190.w,
                            color: _.isDarkMode() == true
                                ? AppColors.darkCardColorDeep
                                : AppColors.secondaryColor,
                          ),
                          buildDrawerTile(context,
                              imgPath: "referral",
                              title: storedLanguage['Referral'] ?? "Referral",
                              onTap: () {
                            Get.toNamed(RoutesName.referralScreen);
                          }),
                          buildDrawerTile(context,
                              imgPath: "bonus",
                              title: storedLanguage['Referral Bonus'] ??
                                  "Referral Bonus", onTap: () {
                            Get.toNamed(RoutesName.referralBonusScreen);
                          }),
                          buildDrawerTile(context,
                              imgPath: "support",
                              title: storedLanguage['Support Ticket'] ??
                                  "Support Ticket", onTap: () {
                            Get.toNamed(RoutesName.supportTicketListScreen);
                          }),
                          VSpace(50.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    });
  }

  Widget buildDrawerTile(BuildContext context,
      {required String imgPath,
      required String title,
      void Function()? onTap,
      bool? isFromShop = false,
      double? imgSize}) {
    return ListTile(
      onTap: onTap,
      leading: Image.asset(
          isFromShop == true
              ? "$rootEcommerceDir/$imgPath.png"
              : "$rootImageDir/$imgPath.png",
          height: imgSize ?? 17.h,
          width: imgSize ?? 17.h,
          fit: BoxFit.cover,
          color: AppThemes.getIconBlackColor()),
      title: Text(title,
          style: context.t.displayMedium?.copyWith(fontSize: 18.sp)),
    );
  }
}
