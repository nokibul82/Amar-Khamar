import '../../../../controllers/product_list_controller.dart';
import '../../../../controllers/product_manage_controller.dart';
import '../../../../data/models/products_model.dart' as p;
import '../../../widgets/app_button.dart';
import '../../../widgets/text_theme_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/dimensions.dart';
import '../../../../config/styles.dart';
import '../../../../routes/routes_name.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/services/helpers.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/spacing.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String? id;
  final String? img;
  final String? title;
  final String? description;
  final String? price;
  final String? rating;
  final String? quantity;
  final List<p.Review>? review;
  final bool? isWishListIcon;
  final p.Product? data;
  const ProductDetailsScreen(
      {super.key,
      this.id = "",
      this.img = "",
      this.title = "",
      this.description = "",
      this.price = "",
      this.rating = "",
      this.quantity = "",
      this.isWishListIcon = true,
      this.review,
      this.data});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    ProductListController.to.quantity = 1;
    return GetBuilder<ProductListController>(builder: (_) {
      return GetBuilder<ProductManageController>(builder: (productManageCtrl) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: Dimensions.screenHeight * .35,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => Scaffold(
                              appBar: CustomAppBar(title: title.toString()),
                              body: PhotoView(
                                imageProvider: NetworkImage(img.toString()),
                              )));
                        },
                        child: Container(
                          height: Dimensions.screenHeight * .35,
                          width: double.maxFinite,
                          padding: EdgeInsets.all(50.h),
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? AppColors.darkCardColor
                                : AppColors.secondaryColor.withOpacity(.08),
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(24.r)),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: CachedNetworkImage(
                                imageUrl: img.toString(),
                                fit: BoxFit.fill,
                              )),
                        ),
                      ),
                      SafeArea(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: Dimensions.kDefaultPadding / 2,
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: Container(
                                        height: 30.h,
                                        width: 30.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                          color: Get.isDarkMode
                                              ? AppColors.darkCardColorDeep
                                              : AppColors.secondaryColor
                                                  .withOpacity(.2),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 5.w),
                                            child: Icon(
                                              Icons.arrow_back_ios,
                                              size: 14.h,
                                            ),
                                          ),
                                        ))),
                              ),
                              if (isWishListIcon == true)
                                InkResponse(
                                  onTap: productManageCtrl.isLoading
                                      ? null
                                      : () async {
                                          if (data != null) {
                                            await productManageCtrl
                                                .addToLocalWishlist(data!);
                                          } else {
                                            Helpers.showSnackBar(
                                                msg: "Product data not found");
                                          }
                                        },
                                  child: Padding(
                                    padding: EdgeInsets.all(22.h),
                                    child: Ink(
                                        height: productManageCtrl.wishListItem
                                                .contains(
                                                    int.parse(id.toString()))
                                            ? 24.h
                                            : 28.h,
                                        width: productManageCtrl.wishListItem
                                                .contains(
                                                    int.parse(id.toString()))
                                            ? 24.h
                                            : 28.h,
                                        padding: EdgeInsets.all(4.h),
                                        decoration: BoxDecoration(
                                          color: Get.isDarkMode
                                              ? AppColors.darkBgColor
                                              : AppColors.whiteColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AppColors.secondaryColor,
                                              width: .2),
                                        ),
                                        child: productManageCtrl.wishListItem
                                                .contains(
                                                    int.parse(id.toString()))
                                            ? Image.asset(
                                                "$rootEcommerceDir/love1.png",
                                                fit: BoxFit.cover,
                                                color: AppColors.secondaryColor,
                                              )
                                            : Image.asset(
                                                "$rootEcommerceDir/love.png",
                                                fit: BoxFit.cover,
                                                color: AppColors.secondaryColor,
                                              )),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                VSpace(24.h),
                Padding(
                  padding: Dimensions.kDefaultPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(title.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.t.titleSmall),
                          ),
                          HSpace(20.w),
                          InkWell(
                            onTap: () async {
                              await Share.share(
                                  AppConstants.baseUrl.split("/api").first);
                            },
                            child: Container(
                              padding: EdgeInsets.all(5.h),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryColor.withOpacity(.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.secondaryColor
                                        .withOpacity(.2)),
                              ),
                              child: Icon(
                                Icons.share,
                                size: 18.h,
                                color: AppThemes.getIconBlackColor(),
                              ),
                            ),
                          )
                        ],
                      ),
                      VSpace(24.h),
                      Row(
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text:
                                  "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", price)}/",
                              style: context.t.bodyLarge,
                            ),
                            TextSpan(
                              text:
                                  "${Helpers.numberFormatWithAsFixed2("", quantity!.split(" ").first)} ${quantity!.split(" ").last}",
                              style: context.t.displayMedium,
                            ),
                          ])),
                          Spacer(),
                          Row(
                            children: [
                              RatingBar.builder(
                                initialRating: double.parse(rating.toString()),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                ignoreGestures: true,
                                itemCount: 5,
                                itemSize: 20.h,
                                unratedColor: Get.isDarkMode
                                    ? AppColors.black60
                                    : AppColors.black30,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: AppColors.yellowColor,
                                  size: 20.h,
                                ),
                                onRatingUpdate: (v) {},
                              ),
                              HSpace(5.w),
                              Text(
                                review == null || review!.length < 1
                                    ? ""
                                    : "(${review!.length})",
                                style: context.t.displayMedium?.copyWith(
                                    color: AppThemes.getParagraphColor()),
                              ),
                            ],
                          ),
                        ],
                      ),
                      VSpace(32.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                storedLanguage['Quantity'] ?? "Quantity",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.t.bodyMedium),
                          ),
                          Container(
                            width: 155.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      AppColors.secondaryColor.withOpacity(.5),
                                  width: .4),
                              color: AppThemes.getDarkCardColor(),
                              borderRadius: Dimensions.kBorderRadius / 1.3,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkResponse(
                                  onTap: () {
                                    if (_.quantity > 1) {
                                      _.quantity -= 1;
                                      _.update();
                                    }
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 4.h,
                                          bottom: 4.h,
                                          right: 3.w,
                                          left: 12.w),
                                      child: Icon(
                                        Icons.remove,
                                        size: 21.h,
                                        color: AppThemes.getParagraphColor(),
                                      )),
                                ),
                                Container(
                                  height: double.maxFinite,
                                  width: 1,
                                  color: AppThemes.getSliderInactiveColor(),
                                ),
                                Text(
                                  "${_.quantity}",
                                  style: context.t.bodyMedium,
                                ),
                                Container(
                                  height: double.maxFinite,
                                  width: 1,
                                  color: AppThemes.getSliderInactiveColor(),
                                ),
                                InkResponse(
                                  onTap: () {
                                    _.quantity += 1;
                                    _.update();
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 4.h,
                                          bottom: 4.h,
                                          left: 3.w,
                                          right: 12.w),
                                      child: Icon(
                                        Icons.add,
                                        size: 21.h,
                                        color: AppThemes.getParagraphColor(),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      VSpace(23.h),
                      Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 3.h,
                                    color: AppThemes.getSliderInactiveColor(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _.selectedTabIndex = 0;
                                      _.update();
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 9.h),
                                      child: Text(
                                          storedLanguage['Description'] ??
                                              "Description",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.t.bodyMedium?.copyWith(
                                            color: _.selectedTabIndex == 0
                                                ? AppThemes.getIconBlackColor()
                                                : AppThemes.getParagraphColor(),
                                          )),
                                    ),
                                  ),
                                  Container(
                                    height: 3.h,
                                    width: 100.w,
                                    color: _.selectedTabIndex == 0
                                        ? AppColors.secondaryColor
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _.selectedTabIndex = 1;
                                      _.update();
                                    },
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 9.h),
                                      child: Text(
                                          storedLanguage['Reviews'] ??
                                              "Reviews",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.t.bodyMedium?.copyWith(
                                            color: _.selectedTabIndex == 1
                                                ? AppThemes.getIconBlackColor()
                                                : AppThemes.getParagraphColor(),
                                          )),
                                    ),
                                  ),
                                  Container(
                                    height: 3.h,
                                    width: 75.w,
                                    color: _.selectedTabIndex == 1
                                        ? AppColors.secondaryColor
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _.selectedTabIndex = 2;
                                      _.update();
                                    },
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 9.h),
                                      child: Text(
                                          storedLanguage['Comment'] ??
                                              "Comment",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.t.bodyMedium?.copyWith(
                                            color: _.selectedTabIndex == 2
                                                ? AppThemes.getIconBlackColor()
                                                : AppThemes.getParagraphColor(),
                                          )),
                                    ),
                                  ),
                                  Container(
                                    height: 3.h,
                                    width: 80.w,
                                    color: _.selectedTabIndex == 2
                                        ? AppColors.secondaryColor
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      // products description, customer reivew
                      VSpace(24.h),
                      if (_.selectedTabIndex == 0)
                        ReadMoreText(description.toString(),
                            trimLines: 5,
                            colorClickableText: AppColors.secondaryColor,
                            preDataTextStyle: context.t.bodySmall,
                            postDataTextStyle: context.t.bodySmall,
                            trimMode: TrimMode.Length,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: ' Show less',
                            lessStyle: context.t.displayMedium?.copyWith(
                                height: 1.5, color: AppColors.secondaryColor),
                            moreStyle: context.t.displayMedium?.copyWith(
                                height: 1.5, color: AppColors.secondaryColor),
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontFamily: Styles.appFontFamily,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: Get.isDarkMode
                                    ? AppColors.black40
                                    : AppColors.paragraphColor)),
                      if (_.selectedTabIndex == 1)
                        ListView.builder(
                          itemCount:
                              review == null ? [].length : review!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (c, index) {
                            var data = review![index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 42.h,
                                        height: 42.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AppColors.secondaryColor,
                                              width: 1.7.h),
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  data.user == null
                                                      ? ""
                                                      : data.user!.image
                                                          .toString()),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      HSpace(12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.user == null
                                                  ? ""
                                                  : data.user!.name.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: context.t.bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400),
                                            ),
                                            VSpace(5.h),
                                            Row(
                                              children: [
                                                RatingBar.builder(
                                                  initialRating: double.parse(
                                                      data.rating.toString()),
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  ignoreGestures: true,
                                                  itemCount: 5,
                                                  itemSize: 14.h,
                                                  unratedColor: Get.isDarkMode
                                                      ? AppColors.black60
                                                      : AppColors.black30,
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color:
                                                        AppColors.yellowColor,
                                                    size: 14.h,
                                                  ),
                                                  onRatingUpdate: (v) {},
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "${DateFormat('MMM dd, yyyy').format(DateTime.now())}",
                                        style: context.t.bodySmall,
                                      ),
                                    ],
                                  ),
                                  VSpace(15.h),
                                  ReadMoreText(data.comment,
                                      trimLines: 5,
                                      colorClickableText:
                                          AppColors.secondaryColor,
                                      preDataTextStyle: context.t.bodySmall,
                                      postDataTextStyle: context.t.bodySmall,
                                      trimMode: TrimMode.Length,
                                      trimCollapsedText:
                                          storedLanguage['Show more'] ??
                                              'Show more',
                                      trimExpandedText:
                                          storedLanguage['Show less'] ??
                                              ' Show less',
                                      lessStyle: context.t.displayMedium
                                          ?.copyWith(
                                              height: 1.5,
                                              color: AppColors.secondaryColor),
                                      moreStyle: context.t.displayMedium
                                          ?.copyWith(
                                              height: 1.5,
                                              color: AppColors.secondaryColor),
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontFamily: Styles.appFontFamily,
                                          fontWeight: FontWeight.w400,
                                          height: 1.5,
                                          color: Get.isDarkMode
                                              ? AppColors.black40
                                              : AppColors.paragraphColor)),
                                ],
                              ),
                            );
                          },
                        ),
                      if (_.selectedTabIndex == 1 && review!.isEmpty)
                        Center(
                          child: Text(
                            "No reviews found",
                            style: context.t.bodyMedium,
                          ),
                        ),
                      if (_.selectedTabIndex == 2)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                storedLanguage['Write a reivew'] ??
                                    "Write a review",
                                style: context.t.bodyMedium),
                            VSpace(20.h),
                            Row(
                              children: [
                                Text(
                                    storedLanguage['Your Rating'] ??
                                        "Your Rating",
                                    style: context.t.displayMedium),
                                HSpace(20.w),
                                Container(
                                  height: 20.h,
                                  width: 1,
                                  color: AppThemes.getParagraphColor(),
                                ),
                                HSpace(20.w),
                                RatingBar.builder(
                                  initialRating: productManageCtrl.rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 30.h,
                                  unratedColor: Get.isDarkMode
                                      ? AppColors.black60
                                      : AppColors.black30,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: AppColors.yellowColor,
                                    size: 30.h,
                                  ),
                                  onRatingUpdate:
                                      productManageCtrl.onRatingUpdate,
                                ),
                                HSpace(15.w),
                                productManageCtrl.ratingExpression(),
                              ],
                            ),
                            VSpace(30.h),
                            CustomTextField(
                              height: 132.h,
                              contentPadding: EdgeInsets.only(
                                  left: 20.w, bottom: 0.h, top: 10.h),
                              alignment: Alignment.topLeft,
                              minLines: 3,
                              maxLines: 5,
                              isOnlyBorderColor: true,
                              isPrefixIcon: false,
                              controller: productManageCtrl.reviewEditingCtrlr,
                              hintext: storedLanguage['Your Reviews'] ??
                                  "Your Reviews",
                            ),
                            VSpace(25.h),
                            CustomTextField(
                              isOnlyBorderColor: true,
                              controller:
                                  productManageCtrl.nameEditingController,
                              contentPadding: EdgeInsets.only(left: 20.w),
                              hintext:
                                  storedLanguage['Your Name'] ?? "Your Name",
                              isPrefixIcon: false,
                            ),
                            VSpace(25.h),
                            CustomTextField(
                              isOnlyBorderColor: true,
                              controller:
                                  productManageCtrl.emailEditingController,
                              contentPadding: EdgeInsets.only(left: 20.w),
                              hintext:
                                  storedLanguage['Your Email'] ?? "Your Email",
                              isPrefixIcon: false,
                            ),
                            VSpace(25.h),
                            AppButton(
                              text: storedLanguage['Submit Review'] ??
                                  "Submit Review",
                              fontSize: 17.sp,
                              isLoading:
                                  productManageCtrl.isLoading ? true : false,
                              onTap: productManageCtrl.isLoading
                                  ? null
                                  : () async {
                                      await productManageCtrl.onReviwSubmit(
                                          productId: id.toString());
                                    },
                            ),
                            VSpace(65.h),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 78.h,
            width: double.maxFinite,
            padding: Dimensions.kDefaultPadding,
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? AppColors.darkCardColor
                  : AppColors.secondaryColor.withOpacity(.2),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.r),
                    onTap: () {
                      productManageCtrl.addToCart(data!,
                          isQuantityUpdatedInProductDetailsPage:
                              _.quantity > 1 ? true : false);
                    },
                    child: Ink(
                      width: 50.h,
                      height: 50.h,
                      padding: EdgeInsets.all(12.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.secondaryColor.withOpacity(.6),
                          width: .5,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Image.asset(
                        "$rootEcommerceDir/bag.png",
                        fit: BoxFit.cover,
                        color: AppThemes.getIconBlackColor(),
                      ),
                    ),
                  ),
                ),
                HSpace(31.w),
                Expanded(
                    child: Material(
                  color: Colors.transparent,
                  child: AppButton(
                    text: "Buy Now",
                    onTap: () async {
                      await productManageCtrl.addToCart(data!,
                          isQuantityUpdatedInProductDetailsPage:
                              _.quantity > 1 ? true : false);
                      ProductManageController.to.getAreaList();
                      await ProductManageController.to.calculateAmount();
                      Get.toNamed(RoutesName.checkoutScreen);
                    },
                  ),
                )),
              ],
            ),
          ),
          floatingActionButton: SizedBox(
            width: 45.h,
            height: 45.h,
            child: FittedBox(
              child: FloatingActionButton(
                backgroundColor: AppColors.secondaryColor,
                onPressed: () async {
                  await ProductManageController.to.calculateAmount();
                  Get.toNamed(RoutesName.myCartScreen);
                },
                child: Image.asset(
                  "$rootEcommerceDir/addCart.png",
                  height: 35.h,
                  width: 35.h,
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
