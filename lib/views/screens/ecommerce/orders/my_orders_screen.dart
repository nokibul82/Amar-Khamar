import '../../../../../controllers/bindings/controller_index.dart';
import '../../../../../utils/services/localstorage/hive.dart';
import '../../../widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/dimensions.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/services/helpers.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/appDialog.dart';
import '../../../widgets/spacing.dart';
import '../../home/home_screen.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
     var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<MyOrderController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(title:storedLanguage['My Orders'] ??"My Orders"),
        body: RefreshIndicator(
          color: AppColors.secondaryColor,
          onRefresh: () async {
            _.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await _.getOrderList(page: 1);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _.scrollController,
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                children: [
                  VSpace(20.h),
                  _.isLoading
                      ? buildTransactionLoader(
                          itemCount: 10, isReverseColor: true)
                      : _.orderList.isEmpty
                          ? Helpers.notFound()
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: _.orderList.length,
                              itemBuilder: (context, i) {
                                var data = _.orderList[i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: InkWell(
                                    borderRadius: Dimensions.kBorderRadius,
                                    onTap: () {
                                      appDialog(
                                          context: context,
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkResponse(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(7.h),
                                                  decoration: BoxDecoration(
                                                    color: AppThemes
                                                        .getFillColor(),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 14.h,
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 60.h,
                                                height: 60.h,
                                                padding: EdgeInsets.all(12.h),
                                                decoration: BoxDecoration(
                                                  color: data.orderStatus
                                                              .toString() ==
                                                          "Pending"
                                                      ? AppColors.pendingColor
                                                          .withOpacity(.1)
                                                      : data.orderStatus
                                                                  .toString() ==
                                                              "Order Placed"
                                                          ? AppColors.random7
                                                              .withOpacity(.1)
                                                          : data.orderStatus
                                                                      .toString() ==
                                                                  "Delivered"
                                                              ? AppColors
                                                                  .greenColor
                                                                  .withOpacity(
                                                                      .1)
                                                              : AppColors
                                                                  .redColor
                                                                  .withOpacity(
                                                                      .1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  data.orderStatus.toString() ==
                                                          "Pending"
                                                      ? '$rootImageDir/pending.png'
                                                      : data.orderStatus
                                                                  .toString() ==
                                                              "Order Placed"
                                                          ? '$rootEcommerceDir/delivery.png'
                                                          : data.orderStatus
                                                                      .toString() ==
                                                                  "Delivered"
                                                              ? '$rootEcommerceDir/delivered.png'
                                                              : '$rootEcommerceDir/order_cancel.png',
                                                  color: data.orderStatus
                                                              .toString() ==
                                                          "Pending"
                                                      ? AppColors.pendingColor
                                                      : data.orderStatus
                                                                  .toString() ==
                                                              "Order Placed"
                                                          ? AppColors.random7
                                                          : data.orderStatus
                                                                      .toString() ==
                                                                  "Delivered"
                                                              ? AppColors
                                                                  .greenColor
                                                              : AppColors
                                                                  .redColor,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              VSpace(12.h),
                                              Text(
                                              storedLanguage['Status'] ??  "Status",
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: Get.isDarkMode
                                                            ? AppColors
                                                                .whiteColor
                                                            : AppColors
                                                                .blackColor),
                                              ),
                                              Text(
                                                "${data.orderStatus}",
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: AppThemes
                                                            .getBlack50Color()),
                                              ),
                                              VSpace(12.h),
                                              Container(
                                                color: Colors.transparent,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                    storedLanguage['Order Number'] ??  "Order Number",
                                                      style: t.displayMedium
                                                          ?.copyWith(
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? AppColors
                                                                      .whiteColor
                                                                  : AppColors
                                                                      .blackColor),
                                                    ),
                                                    SelectableText(
                                                      '${data.orderNumber}',
                                                      style: t.displayMedium
                                                          ?.copyWith(
                                                              color: AppThemes
                                                                  .getBlack50Color()),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              VSpace(12.h),
                                              Text(
                                              storedLanguage['Price'] ??  "Price",
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: Get.isDarkMode
                                                            ? AppColors
                                                                .whiteColor
                                                            : AppColors
                                                                .blackColor),
                                              ),
                                              Text(
                                                "${Helpers.numberFormat(data.total.toString())} ${HiveHelp.read(Keys.baseCurrency)}",
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: AppThemes
                                                            .getBlack50Color()),
                                              ),
                                              VSpace(12.h),
                                              Text(
                                               storedLanguage['Date and Time'] ?? "Date and Time",
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: Get.isDarkMode
                                                            ? AppColors
                                                                .whiteColor
                                                            : AppColors
                                                                .blackColor),
                                              ),
                                              Text(
                                                "${DateFormat('d MMMM, yyyy').format(DateTime.parse(data.date.toString()))}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: t.bodySmall?.copyWith(
                                                    color: AppThemes
                                                        .getBlack50Color()),
                                              ),
                                              VSpace(12.h),
                                            ],
                                          ));
                                    },
                                    child: Ink(
                                      width: double.maxFinite,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 40.h,
                                            height: 40.h,
                                            padding: EdgeInsets.all(8.h),
                                            decoration: BoxDecoration(
                                              color: data.orderStatus
                                                          .toString() ==
                                                      "Pending"
                                                  ? AppColors.pendingColor
                                                      .withOpacity(.1)
                                                  : data.orderStatus
                                                              .toString() ==
                                                          "Order Placed"
                                                      ? AppColors.random7
                                                          .withOpacity(.1)
                                                      : data.orderStatus
                                                                  .toString() ==
                                                              "Delivered"
                                                          ? AppColors.greenColor
                                                              .withOpacity(.1)
                                                          : AppColors.redColor
                                                              .withOpacity(.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.asset(
                                              data.orderStatus.toString() ==
                                                      "Pending"
                                                  ? '$rootImageDir/pending.png'
                                                  : data.orderStatus
                                                              .toString() ==
                                                          "Order Placed"
                                                      ? '$rootEcommerceDir/delivery.png'
                                                      : data.orderStatus
                                                                  .toString() ==
                                                              "Delivered"
                                                          ? '$rootEcommerceDir/delivered.png'
                                                          : '$rootEcommerceDir/order_cancel.png',
                                              color: data.orderStatus
                                                          .toString() ==
                                                      "Pending"
                                                  ? AppColors.pendingColor
                                                  : data.orderStatus
                                                              .toString() ==
                                                          "Order Placed"
                                                      ? AppColors.random7
                                                      : data.orderStatus
                                                                  .toString() ==
                                                              "Delivered"
                                                          ? AppColors.greenColor
                                                          : AppColors.redColor,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          HSpace(12.w),
                                          Expanded(
                                            flex: 10,
                                            child: Column(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: SelectableText(
                                                            "Order${data.orderNumber}",
                                                            maxLines: 1,
                                                            style:
                                                                t.displayMedium,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: InkWell(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.r),
                                                              onTap: _.selectedIndex ==
                                                                          i &&
                                                                      _.isGettingDetails
                                                                  ? null
                                                                  : () async {
                                                                      _.selectedIndex =
                                                                          i;
                                                                      _.update();
                                                                      await _.getOrderDetailsList(
                                                                          id: data
                                                                              .id
                                                                              .toString());
                                                                    },
                                                              child: Ink(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            5.h,
                                                                        horizontal:
                                                                            9.w),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Get
                                                                          .isDarkMode
                                                                      ? AppColors
                                                                          .darkCardColor
                                                                      : AppColors
                                                                          .sliderInActiveColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4.r),
                                                                ),
                                                                child: _.selectedIndex ==
                                                                            i &&
                                                                        _.isGettingDetails
                                                                    ? SizedBox(
                                                                        height:
                                                                            20.h,
                                                                        width:
                                                                            20.h,
                                                                        child: CircularProgressIndicator(
                                                                            color:
                                                                                AppColors.secondaryColor),
                                                                      )
                                                                    : Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                            "View",
                                                                            style:
                                                                                t.bodySmall?.copyWith(
                                                                              fontSize: 14.sp,
                                                                              color: Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                                                                            ),
                                                                          ),
                                                                          HSpace(
                                                                              5.w),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(top: 3.h),
                                                                            child:
                                                                                Image.asset(
                                                                              "$rootImageDir/confirm_arrow.png",
                                                                              color: AppThemes.getIconBlackColor(),
                                                                              height: 12.h,
                                                                              width: 12.h,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    VSpace(5.h),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                              "${DateFormat('d MMMM, yyyy').format(DateTime.parse(data.date.toString()))}",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: t.bodySmall
                                                                  ?.copyWith(
                                                                color: AppThemes
                                                                    .getBlack50Color(),
                                                              )),
                                                        ),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                                "${Helpers.numberFormat(data.total.toString())} ${HiveHelp.read(Keys.baseCurrency)}",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: t
                                                                    .displayMedium),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 12.h),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .darkCardColorDeep
                                                                : AppColors
                                                                    .black20,
                                                            width:
                                                                Get.isDarkMode
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
                                  ),
                                );
                              }),
                  if (_.isLoadMore == true)
                    Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                        child: Helpers.appLoader(isButton: true)),
                  VSpace(20.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
