import '../../../../controllers/product_list_controller.dart';
import '../../../../controllers/product_manage_controller.dart';
import '../../../../controllers/wishlist_controller.dart';
import '../../home/home_screen.dart';
import '../../../widgets/text_theme_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/dimensions.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/services/helpers.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/spacing.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ProductListController>(builder: (productListCtrl) {
      return GetBuilder<WishlistController>(builder: (_) {
        return GetBuilder<ProductManageController>(
            builder: (productManageCtrl) {
          return Scaffold(
            appBar:
                CustomAppBar(title: storedLanguage['Wishlist'] ?? "Wishlist"),
            body: RefreshIndicator(
              color: AppColors.secondaryColor,
              onRefresh: () async {
                _.resetDataAfterSearching(isFromOnRefreshIndicator: true);
                await _.getProductList(page: 1);
              },
              child: SingleChildScrollView(
                controller: _.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: Dimensions.kDefaultPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VSpace(20.h),
                      _.isLoading
                          ? buildTransactionLoader(
                              itemCount: 20, imgSize: 100.h)
                          : _.wishList.isEmpty
                              ? Helpers.notFound()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _.wishList.length,
                                  itemBuilder: (c, i) {
                                    var data = _.wishList[i];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        onTap: productListCtrl.isLoading
                                            ? null
                                            : () {
                                                productListCtrl
                                                    .selectedDetailsIndex = i;
                                                productListCtrl.update();
                                                productListCtrl
                                                    .getProductDetails(
                                                        id: data.productId
                                                            .toString());
                                              },
                                        child: Container(
                                          height: 120.h,
                                          width: double.maxFinite,
                                          padding: EdgeInsets.all(12.h),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                            color: Get.isDarkMode
                                                ? AppColors.darkCardColor
                                                : AppColors.secondaryColor
                                                    .withOpacity(.1),
                                            border: Border.all(
                                              color: AppColors.secondaryColor,
                                              width: Dimensions.appThinBorder,
                                            ),
                                          ),
                                          child: productListCtrl
                                                          .selectedDetailsIndex ==
                                                      i &&
                                                  productListCtrl.isLoading
                                              ? Helpers.appLoader(
                                                  isButton: true)
                                              : Row(
                                                  children: [
                                                    Container(
                                                      height: 100.h,
                                                      width: 100.h,
                                                      padding:
                                                          EdgeInsets.all(8.h),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.r),
                                                        color: Get.isDarkMode
                                                            ? AppColors
                                                                .darkBgColor
                                                            : AppColors
                                                                .whiteColor,
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Positioned(
                                                            top: 0,
                                                            bottom: 0,
                                                            left: 0,
                                                            right: 0,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.r),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: data
                                                                    .productImage
                                                                    .toString(),
                                                                height: 70.h,
                                                                width: 70.h,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    HSpace(16.w),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            data.productName ??
                                                                "",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: t
                                                                .displayMedium
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                        Row(
                                                          children: [
                                                            RatingBar.builder(
                                                              initialRating:
                                                                  double.parse(data
                                                                      .avgRating
                                                                      .toString()),
                                                              minRating: 1,
                                                              direction: Axis
                                                                  .horizontal,
                                                              allowHalfRating:
                                                                  true,
                                                              ignoreGestures:
                                                                  true,
                                                              itemCount: 5,
                                                              itemSize: 15.h,
                                                              unratedColor: Get
                                                                      .isDarkMode
                                                                  ? AppColors
                                                                      .black60
                                                                  : AppColors
                                                                      .black30,
                                                              itemBuilder:
                                                                  (context,
                                                                          _) =>
                                                                      Icon(
                                                                Icons.star,
                                                                color: AppColors
                                                                    .yellowColor,
                                                                size: 15.h,
                                                              ),
                                                              onRatingUpdate:
                                                                  (v) {},
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: RichText(
                                                                  text: TextSpan(
                                                                      children: [
                                                                    TextSpan(
                                                                      text:
                                                                          "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", data.price.toString().split(" ").last)}",
                                                                      style: context
                                                                          .t
                                                                          .bodyMedium,
                                                                    ),
                                                                  ])),
                                                            ),
                                                            Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: InkWell(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.r),
                                                                onTap: productManageCtrl
                                                                        .isLoading
                                                                    ? null
                                                                    : () async {
                                                                        await productManageCtrl.addToWishlist(
                                                                            id: data.productId.toString());
                                                                        if (productManageCtrl.isAddedToWishlist ==
                                                                            false) {
                                                                          _.wishList
                                                                              .removeAt(i);
                                                                          _.update();
                                                                        }
                                                                      },
                                                                child: Ink(
                                                                  width: 54.w,
                                                                  height: 40.h,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(10
                                                                              .h),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: AppColors
                                                                            .secondaryColor,
                                                                        width:
                                                                            .3),
                                                                    color: Get
                                                                            .isDarkMode
                                                                        ? AppColors
                                                                            .darkCardColorDeep
                                                                        : AppColors
                                                                            .whiteColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.r),
                                                                  ),
                                                                  child: Image
                                                                      .asset(
                                                                    "$rootEcommerceDir/delete_account.png",
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    color: AppColors
                                                                        .redColor,
                                                                  ),
                                                                ),
                                                              ),
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
                                  }),
                      if (_.isLoadMore == true)
                        Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                            child: Helpers.appLoader(isButton: true)),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      });
    });
  }
}
