
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amarkhamar/config/dimensions.dart';
import 'package:amarkhamar/controllers/bindings/controller_index.dart';
import 'package:amarkhamar/views/widgets/custom_appbar.dart';
import 'package:amarkhamar/views/widgets/spacing.dart';
import 'package:amarkhamar/views/widgets/text_theme_extension.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/search_dialog.dart';
import '../home/home_screen.dart';

class ReferListScreen extends StatelessWidget {
  const ReferListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ReferralBonusController>(builder: (_) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
        appBar: buildAppbar(storedLanguage, context, _),
        body: RefreshIndicator(
          color: AppColors.secondaryColor,
          onRefresh: () async {
            _.textEditingController.clear();
            _.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await _.getBonusList(
                page: 1, type: '', remark: '', start_date: '', end_date: '');
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
                      ? buildTransactionLoader(itemCount: 10)
                      : _.bonusList.isEmpty
                          ? Helpers.notFound()
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: _.bonusList.length,
                              itemBuilder: (context, i) {
                                var data = _.bonusList[i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12.r),
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
                                                width: 58.h,
                                                height: 58.h,
                                                padding: EdgeInsets.all(13.h),
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .secondaryColor
                                                      .withOpacity(.1),
                                                  borderRadius:
                                                      Dimensions.kBorderRadius,
                                                ),
                                                child: Image.asset(
                                                  "$rootImageDir/bonus.png",
                                                  color:
                                                      AppColors.secondaryColor,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              VSpace(18.h),
                                              Text(
                                            storedLanguage['Type']??    "Type",
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: Get.isDarkMode
                                                            ? AppColors
                                                                .whiteColor
                                                            : AppColors
                                                                .blackColor),
                                              ),
                                              Text(
                                                "${data.commissionType}",
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
                                                      storedLanguage['Transaction ID']??  "Transaction ID",
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
                                                storedLanguage['Amount']??"Amount",
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: Get.isDarkMode
                                                            ? AppColors
                                                                .whiteColor
                                                            : AppColors
                                                                .blackColor),
                                              ),
                                              Text(
                                                "${_.currency_symbol}${Helpers.numberFormat(data.amount)}",
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: AppThemes
                                                            .getBlack50Color()),
                                              ),
                                              VSpace(12.h),
                                              Text(
                                               storedLanguage['Remarks']?? "Remarks",
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: Get.isDarkMode
                                                            ? AppColors
                                                                .whiteColor
                                                            : AppColors
                                                                .blackColor),
                                              ),
                                              SelectableText(
                                                "${data.remarks}",
                                                textAlign: TextAlign.center,
                                                style: t.displayMedium
                                                    ?.copyWith(
                                                        color: AppThemes
                                                            .getBlack50Color()),
                                              ),
                                              VSpace(12.h),
                                              Text(
                                               storedLanguage['Date and Time']?? "Date and Time",
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
                                      padding: EdgeInsets.all(16.h),
                                      decoration: BoxDecoration(
                                        color: AppThemes.getDarkCardColor(),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 48.h,
                                            height: 48.h,
                                            padding: EdgeInsets.all(15.h),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondaryColor
                                                  .withOpacity(.1),
                                              borderRadius:
                                                  Dimensions.kBorderRadius,
                                            ),
                                            child: Image.asset(
                                              "$rootImageDir/bonus.png",
                                              color: AppColors.secondaryColor,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          HSpace(12.w),
                                          Expanded(
                                            child: Column(
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
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Bonus from${data.remarks.toString().split("From").last}",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            style: context
                                                                .t.displayMedium
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                          ),
                                                          VSpace(7.h),
                                                          Text(
                                                            "${DateFormat('d MMMM, yyyy').format(DateTime.parse(data.createdAt.toString()))}",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: context
                                                                .t.bodySmall
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
                                                      flex: 6,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          "${_.currency_symbol}${Helpers.numberFormat(data.amount)}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: context
                                                              .t.displayMedium,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  CustomAppBar buildAppbar(
      storedLanguage, BuildContext context, ReferralBonusController _) {
    return CustomAppBar(
      bgColor: Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
      title: storedLanguage['Referral Bonus'] ?? "Referral Bonus",
      actions: [
        InkResponse(
          onTap: () {
            searchDialog(
                isRemarkField: true,
                context: context,
                transaction: _.typeEditingCtrlr,
                transactionHintext:storedLanguage['Type']?? "Type",
                remark: _.remarkEditingCtrlr,
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
                      .getBonusList(
                    page: 1,
                    type: _.typeEditingCtrlr.text,
                    remark: _.remarkEditingCtrlr.text,
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
