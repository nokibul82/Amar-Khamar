import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:amarkhamar/config/dimensions.dart';
import 'package:amarkhamar/themes/themes.dart';
import 'package:amarkhamar/utils/app_constants.dart';
import 'package:amarkhamar/views/widgets/custom_appbar.dart';
import 'package:amarkhamar/views/widgets/spacing.dart';
import 'package:amarkhamar/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/referral_list_controller.dart';
import '../../../data/models/referral_list_model.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ReferralListController>(builder: (_) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
        appBar: CustomAppBar(
          title: storedLanguage['Referral'] ?? 'Referral',
          bgColor:
              Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
        ),
        body: RefreshIndicator(
          color: AppColors.secondaryColor,
          onRefresh: () async {
            await _.getInitialReferralList();
          },
          child: _.isLoading
              ? Helpers.appLoader()
              : _.referralDataCache.isEmpty
                  ? Helpers.notFound()
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VSpace(35.h),
                            Text(storedLanguage['Referral Link']??"Referral Link",
                                style: context.t.displayMedium),
                            VSpace(12.h),
                            Container(
                              height: 54.h,
                              width: double.maxFinite,
                              padding: EdgeInsets.all(8.h),
                              decoration: BoxDecoration(
                                color: AppThemes.getDarkCardColor(),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  HSpace(8.w),
                                  Expanded(
                                      child: Text(
                                    "${_.referralLink}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.t.bodySmall?.copyWith(
                                        color: AppThemes.getParagraphColor()),
                                  )),
                                  HSpace(24.w),
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text:
                                              "https://agri-wealth.bugfinder.net/register?ref=1"));

                                      Helpers.showToast(
                                          msg: "Copied Successfully",
                                          gravity: ToastGravity.CENTER,
                                          bgColor: AppColors.whiteColor,
                                          textColor: AppColors.blackColor);
                                    },
                                    child: Container(
                                      width: 38.h,
                                      padding: EdgeInsets.all(10.h),
                                      decoration: BoxDecoration(
                                        color: Get.isDarkMode
                                            ? AppColors.darkBgColor
                                            : AppColors.mainColor,
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(8.r)),
                                      ),
                                      child: Image.asset(
                                        "$rootImageDir/copy.png",
                                        color: AppThemes.getIconBlackColor(),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            VSpace(40.h),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _.referralDataCache[0]?.length ?? 0,
                              itemBuilder: (context, index) {
                                final data = _.referralDataCache[0]![index];
                                return _buildReferralTile(_, data, 1, context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
      );
    });
  }

  Widget _buildReferralTile(ReferralListController controller,
      ReferralUser data, int level, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Card(
        elevation: 0,
        color: Get.isDarkMode ? AppColors.darkCardColor : AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            backgroundColor: Get.isDarkMode
                ? AppColors.secondaryColor.withOpacity(.1)
                : AppColors.mainColor,
            collapsedIconColor:
                Get.isDarkMode ? AppColors.black20 : AppColors.black50,
            iconColor: AppColors.secondaryColor,
            trailing: data.hasReferralUser
                ? Icon(
                    controller.expandedState[data.id] == true
                        ? Icons.expand_less
                        : Icons.expand_more,
                  )
                : SizedBox(height: 0, width: 0),
            title: Row(
              children: [
                Text("${data.username}", style: context.t.displayMedium),
                HSpace(10.w),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                  decoration: BoxDecoration(
                    color: AppColors.greenColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    "Level $level",
                    style: context.t.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.greenColor,
                    ),
                  ),
                ),
              ],
            ),
            children: [
              if (controller.referralDataCache[data.id] != null)
                ...controller.referralDataCache[data.id]!
                    .map((nestedData) => Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: _buildReferralTile(
                              controller, nestedData, level + 1, context),
                        )),
              if (controller.referralDataCache[data.id] == null)
                SizedBox(
                    height: 30.h,
                    width: 30.h,
                    child: CircularProgressIndicator(
                        color: AppColors.secondaryColor)),
            ],
            onExpansionChanged: (isExpanded) async {
              controller.toggleExpansion(data.id, isExpanded);

              if (isExpanded &&
                  !controller.referralDataCache.containsKey(data.id)) {
                await controller.fetchNestedReferrals(data.id);
              }
            },
          ),
        ),
      ),
    );
  }
}
