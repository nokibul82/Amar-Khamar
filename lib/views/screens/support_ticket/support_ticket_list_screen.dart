import 'package:amarkhamar/controllers/bindings/controller_index.dart';
import 'package:amarkhamar/themes/themes.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';
import '../home/home_screen.dart';
import 'support_ticket_view_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class SupportTicketListScreen extends StatelessWidget {
  const SupportTicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<SupportTicketController>(builder: (_) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
        appBar: CustomAppBar(
          title: storedLanguage['Support Ticket'] ?? "Support Ticket",
          bgColor:
              Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
        ),
        body: RefreshIndicator(
          color: AppColors.secondaryColor,
          onRefresh: () async {
            _.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await _.getTicketList(page: 1);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _.scrollController,
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VSpace(25.h),
                  _.isLoading
                      ? buildTransactionLoader(itemCount: 10)
                      : _.ticketList.isEmpty
                          ? Helpers.notFound()
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: _.ticketList.length,
                              itemBuilder: (context, i) {
                                var data = _.ticketList[i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 24.h),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8.r),
                                    onTap: () {
                                      Get.to(() => SupportTicketViewScreen(
                                          ticketId: data.id.toString()));
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Ink(
                                          height: 108.h,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            color: AppThemes.getDarkCardColor(),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            border: Border.all(
                                              color: Get.isDarkMode
                                                  ? AppColors.darkCardColorDeep
                                                  : AppColors.black5,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 58.h,
                                                height: 58.h,
                                                margin:
                                                    EdgeInsets.only(left: 15.w),
                                                padding: EdgeInsets.all(15.h),
                                                decoration: BoxDecoration(
                                                  color: Get.isDarkMode
                                                      ? AppColors.darkBgColor
                                                      : AppColors
                                                          .fillColorColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  checkStatusIcon(
                                                      data.status.toString()),
                                                  width: 28.w,
                                                  height: 26.h,
                                                ),
                                              ),
                                              HSpace(
                                                  Dimensions.screenWidth * .1),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${data.subject}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: t.displayMedium,
                                                    ),
                                                    VSpace(16.h),
                                                    RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      TextSpan(
                                                        text: "Last reply: ",
                                                        style: t.displayMedium
                                                            ?.copyWith(
                                                                color: Get
                                                                        .isDarkMode
                                                                    ? AppColors
                                                                        .black30
                                                                    : AppColors
                                                                        .black50),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              " ${timeago.format(DateTime.parse(data.lastReply.toString()))}",
                                                          style:
                                                              t.displayMedium),
                                                    ]))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: Dimensions.screenWidth * .17,
                                          top: -13.h,
                                          child: Container(
                                            height: 33.h,
                                            width: 33.h,
                                            decoration: BoxDecoration(
                                              color: Get.isDarkMode
                                                  ? AppColors.darkBgColor
                                                  : AppColors.pageBgColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            left: Dimensions.screenWidth * .205,
                                            bottom: -13.h,
                                            child: SizedBox(
                                              height: 102.h,
                                              child: DottedLine(
                                                dashColor: Get.isDarkMode
                                                    ? AppColors.black80
                                                    : AppColors.black20,
                                                direction: Axis.vertical,
                                              ),
                                            )),
                                        Positioned(
                                          left: Dimensions.screenWidth * .17,
                                          bottom: -13.h,
                                          child: Container(
                                            height: 33.h,
                                            width: 33.h,
                                            decoration: BoxDecoration(
                                              color: Get.isDarkMode
                                                  ? AppColors.darkBgColor
                                                  : AppColors.pageBgColor,
                                              shape: BoxShape.circle,
                                            ),
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.secondaryColor,
          onPressed: () {
            Get.toNamed(RoutesName.createSupportTicketScreen);
          },
          child: const Icon(
            Icons.add,
            color: AppColors.whiteColor,
          ),
        ),
      );
    });
  }

  checkStatusIcon(dynamic status) {
    if (status == "2") {
      return "$rootImageDir/replied.png";
    } else if (status == "3") {
      return "$rootImageDir/closed.png";
    } else {
      return "$rootImageDir/open.png";
    }
  }
}
