import 'package:amarkhamar/views/widgets/app_button.dart';
import 'package:amarkhamar/views/widgets/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amarkhamar/controllers/bindings/controller_index.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/search_dialog.dart';
import '../../widgets/spacing.dart';
import '../home/home_screen.dart';

class TransactionScreen extends StatelessWidget {
  final bool? isFromHomePage;
  TransactionScreen({super.key, this.isFromHomePage = false});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<TransactionController>(builder: (_) {
      return Scaffold(
        appBar: buildAppbar(storedLanguage, context, _, isFromHomePage),
        body: RefreshIndicator(
          color: AppColors.secondaryColor,
          onRefresh: () async {
            _.textEditingController.clear();
            _.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await _.getTransactionList(
                page: 1, transaction_id: '', start_date: '', end_date: '');
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
                      : _.transactionList.isEmpty
                          ? Helpers.notFound()
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: _.transactionList.length,
                              itemBuilder: (context, i) {
                                var data = _.transactionList[i];
                                return InkWell(
                                  borderRadius: Dimensions.kBorderRadius,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          insetPadding:
                                              Dimensions.kDefaultPadding,
                                          backgroundColor:
                                              AppThemes.getDarkBgColor(),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                Dimensions.kBorderRadius,
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
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    height: 90.h,
                                                    width: 90.h,
                                                    padding:
                                                        EdgeInsets.all(24.h),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Get.isDarkMode
                                                              ? AppColors
                                                                  .black80
                                                              : AppColors
                                                                  .mainColor),
                                                      color: Get.isDarkMode
                                                          ? AppColors
                                                              .darkCardColorDeep
                                                          : AppColors
                                                              .whiteColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Image.asset(
                                                      "$rootImageDir/like.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: double.maxFinite,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    VSpace(60.h),
                                                    Text(storedLanguage['Transaction Success']??"Transaction Success",
                                                        style: context
                                                            .t.titleSmall),
                                                    VSpace(12.h),
                                                    Text(
                                                        "${data.currency_symbol}${Helpers.numberFormat(data.amount.toString())}",
                                                        style: context
                                                            .t.titleLarge
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                    VSpace(32.h),
                                                    Row(
                                                      children: [
                                                        Text(
                                                         storedLanguage['Transaction Id']?? "Transaction Id",
                                                          style: context
                                                              .t.displayMedium
                                                              ?.copyWith(
                                                                  color: AppThemes
                                                                      .getParagraphColor()),
                                                        ),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: SelectableText(
                                                                "${data.trxId}",
                                                                maxLines: 1,
                                                                style: context.t
                                                                    .displayMedium),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    VSpace(8.h),
                                                    Container(
                                                      height: 1,
                                                      width: double.maxFinite,
                                                      color: Get.isDarkMode
                                                          ? AppColors.black80
                                                          : AppColors
                                                              .pageBgColor,
                                                    ),
                                                    VSpace(20.h),
                                                    Row(
                                                      children: [
                                                        Text(
                                                         storedLanguage['Amount']?? "Amount",
                                                          style: context
                                                              .t.displayMedium
                                                              ?.copyWith(
                                                                  color: AppThemes
                                                                      .getParagraphColor()),
                                                        ),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                                "${Helpers.numberFormat(data.amount.toString())} ${data.base_currency}",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: context.t
                                                                    .displayMedium),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    VSpace(8.h),
                                                    Container(
                                                      height: 1,
                                                      width: double.maxFinite,
                                                      color: Get.isDarkMode
                                                          ? AppColors.black80
                                                          : AppColors
                                                              .pageBgColor,
                                                    ),
                                                    VSpace(20.h),
                                                    Row(
                                                      children: [
                                                        Text(
                                                         storedLanguage['Charge']?? "Charge",
                                                          style: context
                                                              .t.displayMedium
                                                              ?.copyWith(
                                                                  color: AppThemes
                                                                      .getParagraphColor()),
                                                        ),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                                "${data.charge} ${data.base_currency}",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: context.t
                                                                    .displayMedium
                                                                    ?.copyWith(
                                                                        color: AppColors
                                                                            .redColor)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    VSpace(8.h),
                                                    Container(
                                                      height: 1,
                                                      width: double.maxFinite,
                                                      color: Get.isDarkMode
                                                          ? AppColors.black80
                                                          : AppColors
                                                              .pageBgColor,
                                                    ),
                                                    VSpace(20.h),
                                                    Row(
                                                      children: [
                                                        Text(
                                                         storedLanguage['Gateway']?? "Gateway",
                                                          style: context
                                                              .t.displayMedium
                                                              ?.copyWith(
                                                                  color: AppThemes
                                                                      .getParagraphColor()),
                                                        ),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                                "${data.remarks}",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: context.t
                                                                    .displayMedium),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    VSpace(8.h),
                                                    Container(
                                                      height: 1,
                                                      width: double.maxFinite,
                                                      color: Get.isDarkMode
                                                          ? AppColors.black80
                                                          : AppColors
                                                              .pageBgColor,
                                                    ),
                                                    VSpace(20.h),
                                                    Row(
                                                      children: [
                                                        Text(
                                                        storedLanguage['Date']??  "Date",
                                                          style: context
                                                              .t.displayMedium
                                                              ?.copyWith(
                                                                  color: AppThemes
                                                                      .getParagraphColor()),
                                                        ),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                                "${DateFormat('d MMMM, yyyy').format(DateTime.parse(data.createdAt.toString()))}",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: context.t
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
                                                      text: storedLanguage['Close']??"Close",
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
                                        horizontal: 8.w, vertical: 14.h),
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
                                                CrossAxisAlignment.start,
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
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            style: t
                                                                .displayMedium),
                                                        VSpace(3.h),
                                                        Text(
                                                          "${DateFormat('d MMMM, yyyy').format(DateTime.parse(data.createdAt.toString()))}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: t.bodySmall
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
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        "${Helpers.numberFormat(data.amount.toString())} ${data.base_currency}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: t.displayMedium,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 12.h),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Get.isDarkMode
                                                              ? AppColors
                                                                  .darkCardColorDeep
                                                              : AppColors
                                                                  .black20,
                                                          width: Get.isDarkMode
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

  CustomAppBar buildAppbar(storedLanguage, BuildContext context,
      TransactionController _, isFromHomePage) {
    return CustomAppBar(
      title: storedLanguage['Transaction'] ?? "Transaction",
      leading: isFromHomePage == true ? null : const SizedBox(),
      actions: [
        InkResponse(
          onTap: () {
            searchDialog(
                isRemarkField: false,
                context: context,
                transaction: _.transactionIdEditingCtrlr,
                date: _.textEditingController,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is PickerDateRange) {
                    _.startDateTimeEditingCtrlr.text =
                        DateFormat('yyyy-MM-dd').format(args.value.startDate);
                    _.endDateTimeEditingCtrlr.text = DateFormat('yyyy-MM-dd')
                        .format(args.value.endDate ?? args.value.startDate);
                    _.textEditingController.text =
                        _.startDateTimeEditingCtrlr.text +
                            " to " +
                            _.endDateTimeEditingCtrlr.text;
                  }
                },
                onSubmit: (Object? value) {
                  if (value is PickerDateRange) {
                    _.startDateTimeEditingCtrlr.text =
                        DateFormat('yyyy-MM-dd').format(value.startDate!);
                    _.endDateTimeEditingCtrlr.text = DateFormat('yyyy-MM-dd')
                        .format(value.endDate ?? value.startDate!);
                  }
                  Navigator.pop(context);
                },
                onSearchPressed: () async {
                  _.resetDataAfterSearching();

                  Get.back();
                  await _
                      .getTransactionList(
                    page: 1,
                    transaction_id: _.transactionIdEditingCtrlr.text,
                    start_date: _.startDateTimeEditingCtrlr.text,
                    end_date: _.endDateTimeEditingCtrlr.text,
                  )
                      .then((value) {
                    _.startDateTimeEditingCtrlr.clear();
                    _.endDateTimeEditingCtrlr.clear();
                  });
                });
          },
          child: Container(
            width: 34.h,
            height: 34.h,
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
              color:
                  Get.isDarkMode ? AppColors.darkBgColor : AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                  color: Get.isDarkMode
                      ? AppColors.darkCardColorDeep
                      : AppColors.mainColor,
                  width: Get.isDarkMode ? .7 : .2),
            ),
            child: Image.asset(
              "$rootImageDir/filter_3.png",
              height: 32.h,
              width: 32.h,
              color:
                  Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        HSpace(20.w),
      ],
    );
  }
}
