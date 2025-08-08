import '../../../../controllers/product_manage_controller.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/services/helpers.dart';
import '../../../../utils/services/localstorage/addCart_model.dart';
import '../../../../utils/services/localstorage/init_hive.dart';
import '../../../widgets/text_theme_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/dimensions.dart';
import '../../../../routes/routes_name.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/spacing.dart';

class MyCartScreen extends StatelessWidget {
  const MyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ProductManageController>(builder: (_) {
      return Scaffold(
        appBar: buildAppbar(context, storedLanguage),
        body: Padding(
          padding: Dimensions.kDefaultPadding,
          child: storedLocalCartItem == null || storedLocalCartItem.isEmpty
              ? Helpers.notFound(top: 0)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VSpace(20.h),
                    Expanded(
                        child: ListView.builder(
                            itemCount: storedLocalCartItem.length,
                            itemBuilder: (c, i) {
                              String key = storedLocalCartItem.keyAt(i);
                              AddCartModel data = storedLocalCartItem.getAt(i);
                              return InkWell(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: Container(
                                    height: 120.h,
                                    padding: EdgeInsets.all(12.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      color: Get.isDarkMode
                                          ? AppColors.darkCardColor
                                          : AppColors.secondaryColor
                                              .withOpacity(.1),
                                      border: Border.all(
                                        color: AppColors.secondaryColor,
                                        width: Dimensions.appThinBorder,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 100.h,
                                          width: 100.h,
                                          padding: EdgeInsets.all(8.h),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                            color: Get.isDarkMode
                                                ? AppColors.darkBgColor
                                                : AppColors.whiteColor,
                                          ),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 0,
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: InkWell(
                                                  onTap: () {
                                                    Get.to(() => Scaffold(
                                                        appBar: CustomAppBar(
                                                            title: data.title
                                                                .toString()),
                                                        body: PhotoView(
                                                          imageProvider:
                                                              NetworkImage(data
                                                                  .img
                                                                  .toString()),
                                                        )));
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.r),
                                                    child: CachedNetworkImage(
                                                      imageUrl: data.img,
                                                      height: 70.h,
                                                      width: 70.h,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      await _
                                                          .removeFromCart(key);
                                                      await _.calculateAmount();
                                                    },
                                                    child: Container(
                                                      height: 24.h,
                                                      width: 24.h,
                                                      padding:
                                                          EdgeInsets.all(4.h),
                                                      decoration: BoxDecoration(
                                                        color: AppThemes
                                                            .getDarkBgColor(),
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: AppColors
                                                                .secondaryColor,
                                                            width: .2),
                                                      ),
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 14.h,
                                                        color:
                                                            AppColors.redColor,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        HSpace(16.w),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(data.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w500)),
                                            Row(
                                              children: [
                                                RatingBar.builder(
                                                  initialRating: double.parse(
                                                      data.avgRating
                                                          .toString()),
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  ignoreGestures: true,
                                                  itemCount: 5,
                                                  itemSize: 15.h,
                                                  unratedColor: Get.isDarkMode
                                                      ? AppColors.black60
                                                      : AppColors.black30,
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color:
                                                        AppColors.yellowColor,
                                                    size: 15.h,
                                                  ),
                                                  onRatingUpdate: (v) {},
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: RichText(
                                                      text: TextSpan(children: [
                                                    TextSpan(
                                                      text:
                                                          "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", data.price)}/",
                                                      style: context
                                                          .t.bodyMedium
                                                          ?.copyWith(
                                                              fontSize: 16.sp),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "${Helpers.numberFormatWithAsFixed2("", data.quantityUnit.split(" ").first)} ${data.quantityUnit.split(" ").last}",
                                                      style: context
                                                          .t.bodyMedium
                                                          ?.copyWith(
                                                              fontSize: 16.sp),
                                                    ),
                                                  ])),
                                                ),
                                                Row(
                                                  children: [
                                                    InkResponse(
                                                      onTap: () async {
                                                        await _.manageQuantity(
                                                            i, key,
                                                            isDecrease: true);
                                                        await _
                                                            .calculateAmount();
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(4.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: AppThemes
                                                                .getSliderInactiveColor(),
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 20.h,
                                                          color: AppThemes
                                                              .getIconBlackColor(),
                                                        ),
                                                      ),
                                                    ),
                                                    HSpace(6.w),
                                                    Text("${data.quantity}",
                                                        style: context
                                                            .t.displayMedium),
                                                    HSpace(6.w),
                                                    InkResponse(
                                                      onTap: () async {
                                                        await _.manageQuantity(
                                                            i, key);
                                                        await _
                                                            .calculateAmount();
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(4.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: AppThemes
                                                                .getSliderInactiveColor(),
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Center(
                                                            child: Icon(
                                                          Icons.add,
                                                          size: 20.h,
                                                          color: AppThemes
                                                              .getIconBlackColor(),
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
        ),
        bottomNavigationBar: storedLocalCartItem == null ||
                storedLocalCartItem.isEmpty
            ? SizedBox(height: 0, width: 0)
            : SafeArea(
                child: Container(
                  height: 270.h,
                  padding: Dimensions.kDefaultPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                CustomTextField(
                                    height: 45.h,
                                    isBorderColor: false,
                                    isOnlyBorderColor: false,
                                    bgColor: Get.isDarkMode
                                        ? AppColors.darkCardColor
                                        : AppColors.secondaryColor
                                            .withOpacity(.2),
                                    borderColor: Get.isDarkMode
                                        ? AppColors.whiteColor
                                        : AppColors.blackColor,
                                    contentPadding: EdgeInsets.only(left: 15.w),
                                    hintext: storedLanguage['Input Code'] ??
                                        "Input Code",
                                    hintColor: Get.isDarkMode
                                        ? AppColors.paragraphColor
                                        : AppColors.black50,
                                    controller: _.couponEditingCtrl),
                                Positioned(
                                  top: 0,
                                  bottom: 0,
                                  right: 0,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: AppButton(
                                      buttonHeight: 40.h,
                                      buttonWidth: 150.w,
                                      isLoading: _.isLoading ? true : false,
                                      onTap: _.isLoading
                                          ? null
                                          : () async {
                                              await _.onApplyCoupon();
                                            },
                                      text: storedLanguage['Apply Coupon'] ??
                                          "Apply Coupon",
                                      style: context.t.displayMedium?.copyWith(
                                          color: AppColors.whiteColor),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacer(flex: 3),
                      Row(
                        children: [
                          Text(storedLanguage['Sub Total'] ?? "Sub Total",
                              style: t.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Get.isDarkMode
                                      ? AppColors.black30
                                      : AppColors.paragraphColor)),
                          Expanded(
                              child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", _.subTotal)}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.bodyMedium),
                          )),
                        ],
                      ),
                      Spacer(flex: 2),
                      Row(
                        children: [
                          Text(storedLanguage['Discount'] ?? "Discount",
                              style: t.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Get.isDarkMode
                                      ? AppColors.black30
                                      : AppColors.paragraphColor)),
                          Expanded(
                              child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", _.discount)}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.bodyMedium),
                          )),
                        ],
                      ),
                      Spacer(flex: 2),
                      Row(
                        children: [
                          Text(storedLanguage['Total'] ?? "Total",
                              style: t.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Get.isDarkMode
                                      ? AppColors.black30
                                      : AppColors.paragraphColor)),
                          Expanded(
                              child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", _.total)}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.bodyMedium
                                    ?.copyWith(color: AppColors.greenColor)),
                          )),
                        ],
                      ),
                      Spacer(flex: 4),
                      AppButton(
                        onTap: () {
                          ProductManageController.to.getAreaList();
                          Get.toNamed(RoutesName.checkoutScreen);
                        },
                        text: storedLanguage['Proceed to Checkout'] ??
                            "Proceed to Checkout",
                      ),
                      VSpace(20.h),
                    ],
                  ),
                ),
              ),
      );
    });
  }

  CustomAppBar buildAppbar(BuildContext context, dynamic storedLanguage) {
    return CustomAppBar(
      title: storedLanguage['My Cart'] ?? "My Cart",
      actions: [
        Container(
          width: 32.h,
          height: 32.h,
          padding: EdgeInsets.all(5.h),
          margin: EdgeInsets.only(right: 24.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.secondaryColor.withOpacity(.6),
              width: .5,
            ),
            color: AppColors.secondaryColor.withOpacity(.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Stack(
            alignment: Alignment.topRight,
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                "$rootEcommerceDir/bag.png",
                color: AppThemes.getIconBlackColor(),
                fit: BoxFit.cover,
              ),
              Positioned(
                top: -12.h,
                right: -5.h,
                child: Container(
                  padding: EdgeInsets.all(5.h),
                  decoration: BoxDecoration(
                    color: Color(0xff60A548),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      storedLocalCartItem == null || storedLocalCartItem.isEmpty
                          ? "0"
                          : "${storedLocalCartItem.length.toString()}",
                      style: context.t.bodySmall?.copyWith(
                          fontSize: 10.sp, color: AppColors.whiteColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
