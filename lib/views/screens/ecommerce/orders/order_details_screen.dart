import '../../../../controllers/my_order_controller.dart';
import '../../home/home_screen.dart';
import '../../../widgets/text_theme_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/dimensions.dart';
import '../../../../utils/services/helpers.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/spacing.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String? id;
  const OrderDetailsScreen({super.key, this.id = "0"});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<MyOrderController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(
          title: storedLanguage['Order Details'] ?? "Order Details",
        ),
        body: _.isLoading
            ? buildTransactionLoader(itemCount: 20, imgSize: 100.h)
            : _.orderDetailsList.isEmpty
                ? Helpers.notFound()
                : RefreshIndicator(
                    color: AppColors.secondaryColor,
                    onRefresh: () async {
                      await _.getOrderDetailsList(id: id.toString());
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VSpace(20.h),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _.orderDetailsList.length,
                                itemBuilder: (c, i) {
                                  var data = _.orderDetailsList[i];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
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
                                                                    .productImage
                                                                    .toString()),
                                                          )));
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.r),
                                                      child: CachedNetworkImage(
                                                        imageUrl: data
                                                            .productImage
                                                            .toString(),
                                                        height: 70.h,
                                                        width: 70.h,
                                                        fit: BoxFit.fill,
                                                      ),
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
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(data.title ?? "",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: t.displayMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Quantity: ${data.quantity.toString()}"
                                                            "  |  " +
                                                        "Price: ${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", data.price.toString().split(" ").last)}",
                                                    style: t.displayMedium,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      TextSpan(
                                                        text:
                                                            "Subtotal: ${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", data.subtotal.toString().split(" ").last)}",
                                                        style: context
                                                            .t.bodyMedium
                                                            ?.copyWith(
                                                                fontSize: 16.sp,
                                                                color: AppColors
                                                                    .secondaryColor),
                                                      ),
                                                    ])),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
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
      );
    });
  }
}
