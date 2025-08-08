import 'package:amarkhamar/config/dimensions.dart';
import 'package:amarkhamar/controllers/project_controller.dart';
import 'package:amarkhamar/utils/app_constants.dart';
import 'package:amarkhamar/views/screens/project/project_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/arrow_button.dart';
import '../../widgets/spacing.dart';

class ProjectInvestScreen extends StatelessWidget {
  const ProjectInvestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ProjectController>(builder: (_) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
        appBar: CustomAppBar(
          bgColor:
              Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
          title: storedLanguage['Project Invest'] ?? "Project Invest",
        ),
        body: RefreshIndicator(
          color: AppColors.secondaryColor,
          onRefresh: () async {
            await _.getProjectInvestmentList();
          },
          child: _.isLoading
              ? Helpers.appLoader()
              : _.projectList.isEmpty
                  ? Helpers.notFound(top: 0)
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Column(
                          children: [
                            VSpace(20.h),
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _.projectList.length,
                                itemBuilder: (context, i) {
                                  var data = _.projectList[i];
                                  return Container(
                                    width: double.maxFinite,
                                    height: 130.h,
                                    margin: EdgeInsets.only(bottom: 12.h),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    decoration: BoxDecoration(
                                      color: AppThemes.getDarkCardColor(),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: InkWell(
                                      onTap: (){
                                        Get.to(() =>
                                            ProjectDetailsScreen(
                                                d: data));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: data.thumbnailImage
                                                      .toString(),
                                                  height: 44.h,
                                                  width: 44.h,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              HSpace(16.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        data.details == null
                                                            ? ""
                                                            : "${data.details?.title.toString()}",
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style: t.displayMedium),
                                                    VSpace(5.h),
                                                    Text(
                                                        data.fixedInvest == null
                                                            ? "${data.currencySymbol}${Helpers.numberFormatWithAsFixed2("", data.minimumInvest.toString())} - " +
                                                                "${data.currencySymbol}${Helpers.numberFormatWithAsFixed2("", data.maximumInvest.toString())}"
                                                            : "${data.currencySymbol}${Helpers.numberFormatWithAsFixed2("", data.fixedInvest.toString())}",
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style: t.bodySmall),
                                                  ],
                                                ),
                                              ),
                                              ArrowButton(
                                                arrowSize: 17.h,
                                                bgColor: Get.isDarkMode
                                                    ? AppColors.darkBgColor
                                                    : AppColors.pageBgColor,
                                                onTap: () {
                                                  Get.to(() =>
                                                      ProjectDetailsScreen(
                                                          d: data));
                                                },
                                                height: 30.h,
                                                width: 104.w,
                                                borderRadius:
                                                    BorderRadius.circular(4.r),
                                                t: t,
                                                text:storedLanguage['View More']?? "View More",
                                                style: t.bodySmall?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: AppThemes
                                                      .getIconBlackColor(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 1.h,
                                            width: double.maxFinite,
                                            color: Get.isDarkMode
                                                ? AppColors.darkCardColorDeep
                                                : AppColors.pageBgColor,
                                          ),
                                          Row(
                                            children: [
                                              Image.asset(
                                                "$rootImageDir/rio.png",
                                                height: 10.h,
                                                width: 10.h,
                                                fit: BoxFit.cover,
                                                color:
                                                    AppThemes.getParagraphColor(),
                                              ),
                                              HSpace(6.w),
                                              Text("ROI : ", style: t.bodySmall),
                                              Text(
                                                  data.returnType.toString() ==
                                                          "Fixed"
                                                      ? "${data.currencySymbol}${Helpers.numberFormatWithAsFixed2("", data.datumReturnMin.toString())} - ${Helpers.numberFormatWithAsFixed2("", data.datumReturnMax.toString())}"
                                                      : "${Helpers.numberFormatWithAsFixed2("", data.datumReturnMin.toString())}% - ${Helpers.numberFormatWithAsFixed2("", data.datumReturnMax.toString())}%",
                                                  style: t.bodySmall?.copyWith(
                                                      color: AppThemes
                                                          .getIconBlackColor())),
                                              Spacer(),
                                              Image.asset(
                                                "$rootImageDir/watch.png",
                                                height: 12.h,
                                                width: 12.h,
                                                fit: BoxFit.cover,
                                                color:
                                                    AppThemes.getParagraphColor(),
                                              ),
                                              HSpace(6.w),
                                              Text(storedLanguage['Duration']??"Duration : ",
                                                  style: t.bodySmall),
                                              Text(
                                                  data.projectDuration == null
                                                      ?storedLanguage['Lifetime']?? "Lifetime"
                                                      : "${data.projectDuration.toString()} ${data.projectDurationType.toString()}",
                                                  style: t.bodySmall?.copyWith(
                                                      color: AppThemes
                                                          .getIconBlackColor())),
                                            ],
                                          ),
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
