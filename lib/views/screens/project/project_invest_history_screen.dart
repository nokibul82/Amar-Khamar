import 'package:amarkhamar/controllers/project_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/search_dialog.dart';
import '../../widgets/spacing.dart';

class ProjectInvestmentHistoryScreen extends StatelessWidget {
  const ProjectInvestmentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ProjectHistoryController>(builder: (_) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
        appBar: buildAppbar(context, _, storedLanguage),
        body: RefreshIndicator(
          color: AppColors.secondaryColor,
          onRefresh: () async {
            _.textEditingController.clear();
            _.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await _.getProjectHistoryList(
                page: 1, name: '', start_date: '', end_date: '');
          },
          child: _.isLoading
              ? Helpers.appLoader()
              : _.projectHistoryList.isEmpty
                  ? Helpers.notFound()
                  : SingleChildScrollView(
                      controller: _.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Column(
                          children: [
                            VSpace(20.h),
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _.projectHistoryList.length,
                                itemBuilder: (context, i) {
                                  var data = _.projectHistoryList[i];

                                  var upComingTime = _.periodicTimerList[i];

                                  return Container(
                                    width: double.maxFinite,
                                    height: 298.h,
                                    margin: EdgeInsets.only(bottom: 12.h),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 20.h),
                                    decoration: BoxDecoration(
                                      color: AppThemes.getDarkCardColor(),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                            storedLanguage['Project']??  "Project",
                                              style: t.bodySmall?.copyWith(
                                                  color: AppThemes
                                                      .getParagraphColor()),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  "${data.projectTitle}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: t.bodySmall?.copyWith(
                                                      color: AppThemes
                                                          .getIconBlackColor()),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                             storedLanguage['No. of Unit']?? "No. of Unit",
                                              style: t.bodySmall?.copyWith(
                                                  color: AppThemes
                                                      .getParagraphColor()),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(8.h),
                                              decoration: BoxDecoration(
                                                color: AppThemes
                                                    .getSliderInactiveColor(),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                "${data.unit}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: t.bodySmall?.copyWith(
                                                    color: AppThemes
                                                        .getIconBlackColor()),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              storedLanguage['Price']??"Price",
                                              style: t.bodySmall?.copyWith(
                                                  color: AppThemes
                                                      .getParagraphColor()),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  "${data.currencySymbol}${Helpers.numberFormat(data.perUnitPrice)}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: t.bodySmall?.copyWith(
                                                      color: AppThemes
                                                          .getIconBlackColor()),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 1,
                                          width: double.maxFinite,
                                          color: AppThemes
                                              .getSliderInactiveColor(),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                             storedLanguage['Return Period']?? "Return Period",
                                              style: t.bodySmall?.copyWith(
                                                  color: AppThemes
                                                      .getParagraphColor()),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  "Every ${data.returnPeriod} ${data.returnPeriodType}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: t.bodySmall?.copyWith(
                                                      color: AppThemes
                                                          .getIconBlackColor()),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                            storedLanguage['Received Amount']??  "Received Amount",
                                              style: t.bodySmall?.copyWith(
                                                  color: AppThemes
                                                      .getParagraphColor()),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  "${data.datumReturn} x ${double.parse(data.totalReturn.toString() == "null" ? "0.0" : data.totalReturn.toString()).toInt()} = ${data.currencySymbol}${(double.parse(data.datumReturn.toString() == "null" ? "0.0" : data.datumReturn.toString()) * double.parse(data.totalReturn.toString() == "null" ? "0.0" : data.datumReturn.toString())).toInt()}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: t.bodySmall?.copyWith(
                                                      color: AppThemes
                                                          .getIconBlackColor()),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 1,
                                          width: double.maxFinite,
                                          color: AppThemes
                                              .getSliderInactiveColor(),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                            storedLanguage['Upcoming Payment']??  "Upcoming Payment",
                                              style: t.bodySmall?.copyWith(
                                                  color: AppThemes
                                                      .getParagraphColor()),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  "${upComingTime}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: t.bodySmall?.copyWith(
                                                      color: upComingTime ==
                                                              "Time has passed"
                                                          ? AppColors.redColor
                                                          : AppThemes
                                                              .getParagraphColor()),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            if (_.isLoadMore == true)
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.h, bottom: 20.h),
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
      BuildContext context, ProjectHistoryController _, storedLanguage) {
    return CustomAppBar(
      bgColor: Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
      title: storedLanguage['Project Investment History'] ??
          "Project Investment History",
      actions: [
        InkResponse(
          onTap: () {
            searchDialog(
                isRemarkField: false,
                context: context,
                transaction: _.nameEditingCtrlr,
                transactionHintext:storedLanguage['Plan Name']?? "Plan Name",
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
                      .getProjectHistoryList(
                    page: 1,
                    name: _.nameEditingCtrlr.text,
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
