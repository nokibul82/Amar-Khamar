import '../../../../controllers/product_list_controller.dart';
import '../../../../controllers/product_manage_controller.dart';
import '../../../../utils/services/localstorage/hive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/dimensions.dart';
import '../../../../routes/routes_name.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/services/helpers.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/spacing.dart';
import 'filter_screen.dart';
import 'product_details_screen.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<ProductListController>(builder: (_) {
      return GetBuilder<ProductManageController>(builder: (productManageCtrl) {
        return Scaffold(
          appBar: CustomAppBar(
            title: storedLanguage['Products'] ?? "Products",
            actions: [
              InkWell(
                borderRadius: BorderRadius.circular(8.r),
                onTap: () {
                  Get.to(() => FilterScreen());
                },
                child: Container(
                  width: 34.h,
                  height: 34.h,
                  padding: EdgeInsets.all(10.5.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border:
                        Border.all(color: AppThemes.getSliderInactiveColor()),
                  ),
                  child: Image.asset(
                    "$rootImageDir/filter_3.png",
                    height: 32.h,
                    width: 32.h,
                    color: Get.isDarkMode
                        ? AppColors.whiteColor
                        : AppColors.blackColor,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              HSpace(20.w),
            ],
          ),
          body: _.isLoading
              ? Helpers.appLoader()
              : Padding(
                  padding: Dimensions.kDefaultPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VSpace(20.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              height: 40.h,
                              isPrefixIcon: true,
                              prefixIcon: "search",
                              hintext: storedLanguage['Search Product'] ??
                                  "Search Product",
                              controller: _.searchEditingCtrlr,
                              onChanged: _.onSearchChanged,
                            ),
                          ),
                          HSpace(16.w),
                          InkWell(
                            borderRadius: BorderRadius.circular(8.r),
                            onTap: () {
                              _.isGridView = !_.isGridView;
                              _.update();
                            },
                            child: Container(
                              height: 40.h,
                              padding: EdgeInsets.all(12.h),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: AppThemes.getSliderInactiveColor(),
                                ),
                              ),
                              child: Image.asset(
                                _.isGridView
                                    ? "$rootEcommerceDir/list.png"
                                    : "$rootEcommerceDir/grid.png",
                                fit: BoxFit.fill,
                                color: Get.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.paragraphColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      VSpace(32.h),
                      if (!_.isGridView)
                        Expanded(
                          child: RefreshIndicator(
                            color: AppColors.secondaryColor,
                            onRefresh: () async {
                              _.resetDataAfterSearching(
                                  isFromOnRefreshIndicator: true);
                              await _.getProductList(
                                  page: 1, min: "", max: "", sorting: "");
                            },
                            child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: _.scrollController,
                                itemCount: _.productList.isEmpty
                                    ? 1
                                    : _.isSearching
                                        ? _.searchedProductList.length
                                        : _.productList.length,
                                itemBuilder: (c, i) {
                                  if (_.productList.isEmpty)
                                    return Helpers.notFound();
                                  var data = _.isSearching
                                      ? _.searchedProductList[i]
                                      : _.productList[i];

                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20.r),
                                      onTap: () {
                                        Get.to(() => ProductDetailsScreen(
                                              data: data,
                                              id: data.id.toString(),
                                              img: data.thumbnailImage
                                                  .toString(),
                                              title: data.details == null
                                                  ? ""
                                                  : data.details!.title,
                                              description: data.details == null
                                                  ? ""
                                                  : data.details!.description,
                                              price: data.price.toString(),
                                              rating: data.avgRating.toString(),
                                              quantity: data.quantity
                                                      .toString() +
                                                  " " +
                                                  data.quantityUnit.toString(),
                                              review: data.reviews,
                                            ));
                                      },
                                      child: Ink(
                                        height: 120.h,
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
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.r),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            data.thumbnailImage,
                                                        height: 67.h,
                                                        width: 67.h,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      child: InkWell(
                                                        onTap: productManageCtrl
                                                                .isLoading
                                                            ? null
                                                            : () async {
                                                                await productManageCtrl
                                                                    .addToLocalWishlist(
                                                                        data);
                                                              },
                                                        child: Container(
                                                          height: 23.h,
                                                          width: 23.h,
                                                          padding: EdgeInsets.all(
                                                              productManageCtrl
                                                                      .wishListItem
                                                                      .contains(
                                                                          data.id)
                                                                  ? 5.h
                                                                  : 4.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppThemes
                                                                .getDarkBgColor(),
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .secondaryColor,
                                                                width: .2),
                                                          ),
                                                          child: productManageCtrl
                                                                  .wishListItem
                                                                  .contains(
                                                                      data.id)
                                                              ? Image.asset(
                                                                  "$rootEcommerceDir/love1.png",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  color: AppColors
                                                                      .secondaryColor,
                                                                )
                                                              : Image.asset(
                                                                  "$rootEcommerceDir/love.png",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  color: AppColors
                                                                      .secondaryColor,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    data.details == null
                                                        ? ""
                                                        : data.details!.title,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: t.displayMedium
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                                Row(
                                                  children: [
                                                    RatingBar.builder(
                                                      initialRating:
                                                          double.parse(data
                                                              .avgRating
                                                              .toString()),
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      ignoreGestures: true,
                                                      itemCount: 5,
                                                      itemSize: 15.h,
                                                      unratedColor: Get
                                                              .isDarkMode
                                                          ? AppColors.black60
                                                          : AppColors.black30,
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: AppColors
                                                            .yellowColor,
                                                        size: 15.h,
                                                      ),
                                                      onRatingUpdate: (v) {},
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            data.quantity
                                                                        .toString() ==
                                                                    "1.00"
                                                                ? "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", data.price)}/${data.quantityUnit}"
                                                                : "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", data.price)}/${Helpers.numberFormatWithAsFixed2("", data.quantity)} ${data.quantityUnit}",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                t.bodyMedium)),
                                                    Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r),
                                                        onTap: () {
                                                          productManageCtrl
                                                              .addToCart(data);
                                                        },
                                                        child: Ink(
                                                          width: 44.w,
                                                          height: 32.h,
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .secondaryColor,
                                                                width: .3),
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .darkCardColorDeep
                                                                : AppColors
                                                                    .whiteColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.r),
                                                          ),
                                                          child: Image.asset(
                                                            "$rootEcommerceDir/addCart.png",
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            color: AppColors
                                                                .secondaryColor,
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
                          ),
                        ),
                      if (_.isGridView)
                        Expanded(
                          child: RefreshIndicator(
                            color: AppColors.secondaryColor,
                            onRefresh: () async {
                              _.resetDataAfterSearching(
                                  isFromOnRefreshIndicator: true);
                              await _.getProductList(
                                  page: 1, min: "", max: "", sorting: "");
                            },
                            child: GridView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: _.scrollController,
                                itemCount: _.isSearching
                                    ? _.searchedProductList.length
                                    : _.productList.isEmpty
                                        ? 1
                                        : _.productList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20.w,
                                  mainAxisSpacing: 20.h,
                                  childAspectRatio: 3 / 4.4,
                                ),
                                itemBuilder: (c, i) {
                                  if (_.productList.isEmpty)
                                    return Helpers.notFound();
                                  var data = _.isSearching
                                      ? _.searchedProductList[i]
                                      : _.productList[i];
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(20.r),
                                    onTap: () {
                                      Get.to(() => ProductDetailsScreen(
                                            data: data,
                                            id: data.id.toString(),
                                            img: data.thumbnailImage.toString(),
                                            title: data.details == null
                                                ? ""
                                                : data.details!.title,
                                            description: data.details == null
                                                ? ""
                                                : data.details!.description,
                                            price: data.price.toString(),
                                            rating: data.avgRating.toString(),
                                            quantity: data.quantity.toString() +
                                                " " +
                                                data.quantityUnit.toString(),
                                            review: data.reviews,
                                          ));
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Container(
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
                                          child: Stack(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 144.h,
                                                    padding:
                                                        EdgeInsets.all(25.h),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      20.r)),
                                                      color: Get.isDarkMode
                                                          ? AppColors
                                                              .darkBgColor
                                                          : AppColors
                                                              .whiteColor,
                                                    ),
                                                    child: Stack(
                                                      clipBehavior: Clip.none,
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
                                                                    .thumbnailImage,
                                                                height: 70.h,
                                                                width: 70.h,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  VSpace(20.h),
                                                  Text(
                                                      data.details == null
                                                          ? ""
                                                          : data.details!.title,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: t.displayMedium),
                                                  VSpace(4.h),
                                                  Row(
                                                    children: [
                                                      RatingBar.builder(
                                                        initialRating:
                                                            double.parse(data
                                                                .avgRating
                                                                .toString()),
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        ignoreGestures: true,
                                                        itemCount: 5,
                                                        itemSize: 15.h,
                                                        unratedColor: Get
                                                                .isDarkMode
                                                            ? AppColors.black60
                                                            : AppColors.black30,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: AppColors
                                                              .yellowColor,
                                                          size: 15.h,
                                                        ),
                                                        onRatingUpdate: (v) {},
                                                      )
                                                    ],
                                                  ),
                                                  VSpace(4.h),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        data.quantity
                                                                    .toString() ==
                                                                "1.00"
                                                            ? "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", data.price)}/${data.quantityUnit}"
                                                            : "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", data.price)}/${Helpers.numberFormatWithAsFixed2("", data.quantity)} ${data.quantityUnit}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: t.bodyMedium
                                                            ?.copyWith(
                                                                fontSize:
                                                                    15.sp),
                                                      )),
                                                      Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.r),
                                                          onTap: () {
                                                            productManageCtrl
                                                                .addToCart(
                                                                    data);
                                                          },
                                                          child: Ink(
                                                            width: 38.w,
                                                            height: 32.h,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: AppColors
                                                                      .secondaryColor,
                                                                  width: .3),
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? AppColors
                                                                      .darkCardColorDeep
                                                                  : AppColors
                                                                      .whiteColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.r),
                                                            ),
                                                            child: Image.asset(
                                                              "$rootEcommerceDir/addCart.png",
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              color: AppColors
                                                                  .secondaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Positioned(
                                                  top: 10.h,
                                                  left: 10.h,
                                                  child: InkWell(
                                                    onTap: productManageCtrl
                                                            .isLoading
                                                        ? null
                                                        : () async {
                                                            await productManageCtrl
                                                                .addToLocalWishlist(
                                                                    data);
                                                          },
                                                    child: Container(
                                                      height: 24.h,
                                                      width: 24.h,
                                                      padding: EdgeInsets.all(
                                                          productManageCtrl
                                                                  .wishListItem
                                                                  .contains(
                                                                      data.id)
                                                              ? 5.h
                                                              : 4.h),
                                                      decoration: BoxDecoration(
                                                        color: Get.isDarkMode
                                                            ? AppColors
                                                                .darkBgColor
                                                            : AppColors
                                                                .whiteColor,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: AppColors
                                                                .secondaryColor,
                                                            width: .2),
                                                      ),
                                                      child: productManageCtrl
                                                              .wishListItem
                                                              .contains(data.id)
                                                          ? Image.asset(
                                                              "$rootEcommerceDir/love1.png",
                                                              fit: BoxFit.cover,
                                                              color: AppColors
                                                                  .secondaryColor,
                                                            )
                                                          : Image.asset(
                                                              "$rootEcommerceDir/love.png",
                                                              fit: BoxFit.cover,
                                                              color: AppColors
                                                                  .secondaryColor,
                                                            ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        )),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ),
                      if (_.isLoadMore == true)
                        Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                            child: Helpers.appLoader(isButton: true)),
                      if (_.isLoadMore == true) VSpace(20.h),
                    ],
                  ),
                ),
          floatingActionButton: SizedBox(
            width: 55.h,
            height: 55.h,
            child: FittedBox(
              child: FloatingActionButton(
                backgroundColor: AppColors.secondaryColor,
                onPressed: () async {
                  await ProductManageController.to.calculateAmount();
                  Get.toNamed(RoutesName.myCartScreen);
                },
                child: Image.asset(
                  "$rootEcommerceDir/addCart.png",
                  height: 32.h,
                  width: 32.h,
                  color: AppColors.whiteColor,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      });
    });
  }
}
