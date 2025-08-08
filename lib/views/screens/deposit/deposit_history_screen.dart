import '../../../controllers/bindings/controller_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/search_dialog.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';
import '../home/home_screen.dart';

class DepositHistoryScreen extends StatelessWidget {
  const DepositHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<DepositHistoryController>(builder: (_) {
      return Scaffold(
        appBar: buildAppbar(storedLanguage, context, _),
        body: RefreshIndicator(
          color: AppColors.secondaryColor,
          onRefresh: () async {
            _.textEditingController.clear();
            _.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await _.getDepositHistoryList(
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
                      : _.depositHistoryList.isEmpty
                          ? Helpers.notFound()
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: _.depositHistoryList.length,
                              itemBuilder: (context, i) {
                                var data = _.depositHistoryList[i];
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
                                                height: 60.h,
                                                width: 60.h,
                                                padding: EdgeInsets.all(12.h),
                                                decoration: BoxDecoration(
                                                  color: data.status
                                                              .toString() ==
                                                          "0"
                                                      ? AppColors.pendingColor
                                                          .withOpacity(.1)
                                                      : data.status
                                                                  .toString() ==
                                                              "1"
                                                          ? AppColors.greenColor
                                                              .withOpacity(.1)
                                                          : data.status
                                                                      .toString() ==
                                                                  "2"
                                                              ? AppColors
                                                                  .random7
                                                                  .withOpacity(
                                                                      .1)
                                                              : AppColors
                                                                  .redColor
                                                                  .withOpacity(
                                                                      .1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  data.status.toString() == "0"
                                                      ? '$rootImageDir/pending.png'
                                                      : data.status
                                                                  .toString() ==
                                                              "1"
                                                          ? '$rootImageDir/approved.png'
                                                          : data.status
                                                                      .toString() ==
                                                                  "2"
                                                              ? '$rootImageDir/request.png'
                                                              : '$rootImageDir/rejected.png',
                                                  color: data.status
                                                              .toString() ==
                                                          "0"
                                                      ? AppColors.pendingColor
                                                      : data.status
                                                                  .toString() ==
                                                              "1"
                                                          ? AppColors.greenColor
                                                          : data.status
                                                                      .toString() ==
                                                                  "2"
                                                              ? AppColors
                                                                  .random7
                                                              : AppColors
                                                                  .redColor,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              VSpace(12.h),
                                              Text(
                                               storedLanguage['Status'] ?? "Status",
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: Get.isDarkMode
                                                            ? AppColors
                                                                .whiteColor
                                                            : AppColors
                                                                .blackColor),
                                              ),
                                              Text(
                                                "${data.status.toString() == "0" ? "Pending" : data.status.toString() == "1" ? "Success" : data.status.toString() == "2" ? "Request" : "Rejected"}",
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: AppThemes
                                                            .getBlack50Color()),
                                              ),
                                              VSpace(12.h),
                                              InkWell(
                                                onTap: () {
                                                  ScaffoldMessenger.of(context)
                                                      .removeCurrentSnackBar();
                                                  Clipboard.setData(
                                                      new ClipboardData(
                                                          text:
                                                              "${data.trxId}"));

                                                  Helpers.showSnackBar(
                                                      msg:
                                                          "Copied Successfully",
                                                      title: 'Success',
                                                      bgColor:
                                                          AppColors.greenColor);
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                       storedLanguage['Transaction ID'] ?? "Transaction ID",
                                                        style: t.displayMedium?.copyWith(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .blackColor),
                                                      ),
                                                      Text(
                                                        '${data.trxId}',
                                                        style: t.displayMedium
                                                            ?.copyWith(
                                                                color: AppThemes
                                                                    .getBlack50Color()),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              VSpace(12.h),
                                              Text(
                                              storedLanguage['Amount'] ??  "Amount",
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: Get.isDarkMode
                                                            ? AppColors
                                                                .whiteColor
                                                            : AppColors
                                                                .blackColor),
                                              ),
                                              Text(
                                                "${Helpers.numberFormat(data.amount)} ${data.baseCurrency}",
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: AppThemes
                                                            .getBlack50Color()),
                                              ),
                                              VSpace(12.h),
                                              Text(
                                             storedLanguage['Gateway'] ??   "Gateway",
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: Get.isDarkMode
                                                            ? AppColors
                                                                .whiteColor
                                                            : AppColors
                                                                .blackColor),
                                              ),
                                              Text(
                                                "${data.method}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: AppThemes
                                                            .getBlack50Color()),
                                              ),
                                              VSpace(12.h),
                                              Text(
                                              storedLanguage['Date and Time'] ??  "Date and Time",
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: Get.isDarkMode
                                                            ? AppColors
                                                                .whiteColor
                                                            : AppColors
                                                                .blackColor),
                                              ),
                                              Text(
                                                "${DateFormat('d MMMM, yyyy').format(DateTime.parse(data.createdAt.toString()))}",
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
                                            padding: EdgeInsets.all(9.h),
                                            decoration: BoxDecoration(
                                              color: data.status.toString() ==
                                                      "0"
                                                  ? AppColors.pendingColor
                                                      .withOpacity(.1)
                                                  : data.status.toString() ==
                                                          "1"
                                                      ? AppColors.greenColor
                                                          .withOpacity(.1)
                                                      : data.status
                                                                  .toString() ==
                                                              "2"
                                                          ? AppColors.random7
                                                              .withOpacity(.1)
                                                          : AppColors.redColor
                                                              .withOpacity(.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.asset(
                                              data.status.toString() == "0"
                                                  ? '$rootImageDir/pending.png'
                                                  : data.status.toString() ==
                                                          "1"
                                                      ? '$rootImageDir/approved.png'
                                                      : data.status
                                                                  .toString() ==
                                                              "2"
                                                          ? '$rootImageDir/request.png'
                                                          : '$rootImageDir/rejected.png',
                                              color: data.status.toString() ==
                                                      "0"
                                                  ? AppColors.pendingColor
                                                  : data.status.toString() ==
                                                          "1"
                                                      ? AppColors.greenColor
                                                      : data.status
                                                                  .toString() ==
                                                              "2"
                                                          ? AppColors.random7
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
                                                          child: Text(
                                                            "${data.method}",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            style:
                                                                t.displayMedium,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                                "${Helpers.numberFormat(data.amount)} ${data.baseCurrency}",
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
                                                    VSpace(5.h),
                                                    Text(
                                                        "${DateFormat('d MMMM, yyyy').format(DateTime.parse(data.createdAt.toString()))}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: t.bodySmall
                                                            ?.copyWith(
                                                          color: AppThemes
                                                              .getBlack50Color(),
                                                        )),
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

  CustomAppBar buildAppbar(
      storedLanguage, BuildContext context, DepositHistoryController _) {
    return CustomAppBar(
      title: storedLanguage['Deposit History'] ?? "Deposit History",
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
                      .getDepositHistoryList(
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
