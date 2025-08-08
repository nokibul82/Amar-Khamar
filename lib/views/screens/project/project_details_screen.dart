import 'package:amarkhamar/controllers/profile_controller.dart';
import 'package:amarkhamar/controllers/project_controller.dart';
import 'package:amarkhamar/themes/themes.dart';
import 'package:amarkhamar/utils/app_constants.dart';
import 'package:amarkhamar/utils/services/helpers.dart';
import 'package:amarkhamar/views/widgets/app_button.dart';
import 'package:amarkhamar/views/widgets/spacing.dart';
import 'package:amarkhamar/views/widgets/text_theme_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:readmore/readmore.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../config/styles.dart';
import '../../../data/models/project_model.dart' as p;
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import 'package:carousel_slider/carousel_slider.dart' as c;
import 'package:dots_indicator/dots_indicator.dart';

// ignore: must_be_immutable
class ProjectDetailsScreen extends StatelessWidget {
  final p.Datum? d;
  ProjectDetailsScreen({super.key, this.d});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    c.CarouselSliderController controller = c.CarouselSliderController();
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ProjectController>(builder: (_) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkBgColor : AppColors.pageBgColor,
        bottomNavigationBar: Container(
          padding: Dimensions.kDefaultPadding,
          height: 160.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(10.h),
              Padding(
                padding: Dimensions.kDefaultPadding / 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        storedLanguage['You are Sponsoring:'] ??
                            "You are Sponsoring:",
                        style: t.displayMedium),
                    Text(storedLanguage['Available Unit'] ?? "Available Unit",
                        style: t.displayMedium),
                  ],
                ),
              ),
              VSpace(9.h),
              Row(
                children: [
                  Container(
                    width: 155.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: AppThemes.getSliderInactiveColor()),
                      color: AppThemes.getDarkCardColor(),
                      borderRadius: Dimensions.kBorderRadius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkResponse(
                          onTap: () {
                            if (_.increment > 1) {
                              _.increment -= 1;
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
                          "${_.increment}",
                          style: t.displayMedium,
                        ),
                        Container(
                          height: double.maxFinite,
                          width: 1,
                          color: AppThemes.getSliderInactiveColor(),
                        ),
                        InkResponse(
                          onTap: () {
                            _.increment += 1;
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
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 24.w),
                      child: Text("${d?.availableUnits.toString()}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.titleSmall
                              ?.copyWith(color: AppColors.secondaryColor)),
                    ),
                  )),
                ],
              ),
              Spacer(),
              AppButton(
                onTap: DateTime.now()
                        .isAfter(DateTime.parse(d!.investLastDate.toString()))
                    ? () {
                        Helpers.showSnackBar(
                            msg:
                                "You cannot invest, as the investment period has ended.");
                      }
                    : () {
                        _.getSelectedVal(d!);
                        buildDialog(context, t, d!, _, storedLanguage);
                      },
                text: d == null || d!.investLastDate == null
                    ? storedLanguage['Invest Now'] ?? "Invest Now"
                    : DateTime.now().isAfter(
                            DateTime.parse(d!.investLastDate.toString()))
                        ? storedLanguage['Expired'] ?? "Expired"
                        : storedLanguage['Invest Now'] ?? "Invest Now",
              ),
              VSpace(20.h),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              caroselSection(controller, t, _, d),
              VSpace(20.h),
              Padding(
                padding: Dimensions.kDefaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${d?.details?.title.toString()}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyLarge),
                    VSpace(12.h),
                    Row(
                      children: [
                        Image.asset(
                          "$rootImageDir/location.png",
                          height: 16.h,
                          width: 16.h,
                          fit: BoxFit.cover,
                          color: AppThemes.getParagraphColor(),
                        ),
                        HSpace(5.w),
                        Expanded(
                          child: Text("${d?.location.toString()}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.bodySmall?.copyWith(
                                color: AppThemes.getParagraphColor(),
                              )),
                        ),
                      ],
                    ),
                    VSpace(16.h),
                    ReadMoreText('${d?.details?.description.toString()}',
                        trimLines: 5,
                        colorClickableText: AppColors.secondaryColor,
                        preDataTextStyle: context.t.bodySmall,
                        postDataTextStyle: context.t.bodySmall,
                        trimMode: TrimMode.Length,
                        trimCollapsedText:
                            storedLanguage['Show more'] ?? 'Show more',
                        trimExpandedText:
                            storedLanguage['Show less'] ?? ' Show less',
                        lessStyle: t.displayMedium?.copyWith(
                            height: 1.5, color: AppColors.secondaryColor),
                        moreStyle: t.displayMedium?.copyWith(
                            height: 1.5, color: AppColors.secondaryColor),
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: Styles.appFontFamily,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: Get.isDarkMode
                                ? AppColors.black40
                                : AppColors.paragraphColor)),
                    VSpace(16.h),
                    Container(
                        width: double.maxFinite,
                        height: 390.h,
                        padding: EdgeInsets.all(24.h),
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? AppColors.darkCardColor
                              : AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  storedLanguage['Number of Return'] ??
                                      "Number of Return",
                                  style: context.t.displayMedium?.copyWith(
                                      color: AppThemes.getParagraphColor()),
                                ),
                                Text(
                                  d?.numberOfReturn.toString() == "null"
                                      ? storedLanguage['Lifetime Earning'] ??
                                          "Lifetime Earning"
                                      : "${d?.numberOfReturn.toString()} Times",
                                  style: context.t.displayMedium,
                                ),
                              ],
                            ),
                            Container(
                              width: double.maxFinite,
                              height: 1,
                              color: Get.isDarkMode
                                  ? AppColors.darkCardColorDeep
                                  : AppColors.mainColor.withOpacity(.5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  storedLanguage['Unit Price'] ?? "Unit Price",
                                  style: context.t.displayMedium?.copyWith(
                                      color: AppThemes.getParagraphColor()),
                                ),
                                Text(
                                  d?.fixedInvest == null
                                      ? "${d?.currencySymbol.toString()}${Helpers.numberFormatWithAsFixed2("", d?.minimumInvest.toString())} - ${d?.currencySymbol.toString()}${Helpers.numberFormatWithAsFixed2("", d?.maximumInvest.toString())}"
                                      : "${d?.currencySymbol.toString()}${Helpers.numberFormatWithAsFixed2("", d?.fixedInvest.toString())}",
                                  style: context.t.displayMedium,
                                ),
                              ],
                            ),
                            Container(
                              width: double.maxFinite,
                              height: 1,
                              color: Get.isDarkMode
                                  ? AppColors.darkCardColorDeep
                                  : AppColors.mainColor.withOpacity(.5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "ROI",
                                  style: context.t.displayMedium?.copyWith(
                                      color: AppThemes.getParagraphColor()),
                                ),
                                Text(
                                  d?.returnType.toString() == "Fixed"
                                      ? "${d?.currencySymbol}${Helpers.numberFormatWithAsFixed2("", d?.datumReturnMin.toString())} - ${Helpers.numberFormatWithAsFixed2("", d?.datumReturnMax.toString())}"
                                      : "${Helpers.numberFormatWithAsFixed2("", d?.datumReturnMin.toString())}% - ${Helpers.numberFormatWithAsFixed2("", d?.datumReturnMax.toString())}%",
                                  style: context.t.displayMedium,
                                ),
                              ],
                            ),
                            // Container(
                            //   width: double.maxFinite,
                            //   height: 1,
                            //   color: Get.isDarkMode
                            //       ? AppColors.darkCardColorDeep
                            //       : AppColors.mainColor.withOpacity(.5),
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       "Total Earning",
                            //       style: context.t.displayMedium?.copyWith(
                            //           color: AppThemes.getParagraphColor()),
                            //     ),
                            //     Text(
                            //       d?.returnType.toString() == "Fixed"
                            //           ? "${d?.currencySymbol}${Helpers.numberFormatWithAsFixed2("", (d?.datumReturnMin).toString())} - ${Helpers.numberFormatWithAsFixed2("", d?.datumReturnMax.toString())}"
                            //           : "${Helpers.numberFormatWithAsFixed2("", d?.datumReturnMin.toString())}% - ${Helpers.numberFormatWithAsFixed2("", d?.datumReturnMax.toString())}%",
                            //       style: context.t.displayMedium,
                            //     ),
                            //   ],
                            // ),
                            Container(
                              width: double.maxFinite,
                              height: 1,
                              color: Get.isDarkMode
                                  ? AppColors.darkCardColorDeep
                                  : AppColors.mainColor.withOpacity(.5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  storedLanguage['Return Period'] ??
                                      "Return Period",
                                  style: context.t.displayMedium?.copyWith(
                                      color: AppThemes.getParagraphColor()),
                                ),
                                Text(
                                  "${d?.returnPeriod.toString()} ${d?.returnPeriodType.toString()}",
                                  style: context.t.displayMedium,
                                ),
                              ],
                            ),
                            Container(
                              width: double.maxFinite,
                              height: 1,
                              color: Get.isDarkMode
                                  ? AppColors.darkCardColorDeep
                                  : AppColors.mainColor.withOpacity(.5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  storedLanguage['Total Unit'] ?? "Total Unit",
                                  style: context.t.displayMedium?.copyWith(
                                      color: AppThemes.getParagraphColor()),
                                ),
                                Text(
                                  "${d?.totalUnits.toString()}",
                                  style: context.t.displayMedium,
                                ),
                              ],
                            ),
                            Container(
                              width: double.maxFinite,
                              height: 1,
                              color: Get.isDarkMode
                                  ? AppColors.darkCardColorDeep
                                  : AppColors.mainColor.withOpacity(.5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  storedLanguage['Capital Back'] ??
                                      "Capital Back",
                                  style: context.t.displayMedium?.copyWith(
                                      color: AppThemes.getParagraphColor()),
                                ),
                                Text(
                                  d?.capitalBack.toString() == "1"
                                      ? storedLanguage['Yes'] ?? "Yes"
                                      : storedLanguage['No'] ?? "No",
                                  style: context.t.displayMedium?.copyWith(
                                      color: d?.capitalBack.toString() == "1"
                                          ? AppColors.greenColor
                                          : AppColors.redColor),
                                ),
                              ],
                            ),
                            Container(
                              width: double.maxFinite,
                              height: 1,
                              color: Get.isDarkMode
                                  ? AppColors.darkCardColorDeep
                                  : AppColors.mainColor.withOpacity(.5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  storedLanguage['Maturity'] ?? "Maturity",
                                  style: context.t.displayMedium?.copyWith(
                                      color: AppThemes.getParagraphColor()),
                                ),
                                Text(
                                  "${d?.maturity.toString()}",
                                  style: context.t.displayMedium,
                                ),
                              ],
                            ),
                            Container(
                              width: double.maxFinite,
                              height: 1,
                              color: Get.isDarkMode
                                  ? AppColors.darkCardColorDeep
                                  : AppColors.mainColor.withOpacity(.5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  storedLanguage['Investment Last Date'] ??
                                      "Investment Last Date",
                                  style: context.t.displayMedium?.copyWith(
                                      color: AppThemes.getParagraphColor()),
                                ),
                                Text(
                                  d?.investLastDate == null
                                      ? ""
                                      : DateFormat('d MMM yyyy').format(
                                          DateTime.parse(
                                              d!.investLastDate.toString())),
                                  style: context.t.displayMedium,
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  buildDialog(BuildContext context, TextTheme t, p.Datum data,
      ProjectController _, dynamic storedLanguage) {
    if(data.fixedInvest != null){
      _.amountCtrl.text =NumberFormat('###0').format(double.parse(data.fixedInvest));
    }
    appDialog(
        insetPadding: Dimensions.kDefaultPadding,
        context: context,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkResponse(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.all(7.h),
                decoration: BoxDecoration(
                  color: AppThemes.getFillColor(),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  storedLanguage['Maturity'] ?? "Maturity",
                  style: t.displayMedium
                      ?.copyWith(color: AppThemes.getParagraphColor()),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      data.maturity.toString() == "null"
                          ? ""
                          : "${double.parse(data.maturity.toString().split(" ").first).toInt() > 1 ? data.maturity.toString() : data.maturity.toString().split(" ").first + ' Day'}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.displayMedium,
                    ),
                  ),
                ),
              ],
            ),
            VSpace(8.h),
            Container(
              width: double.maxFinite,
              height: 1,
              color: Get.isDarkMode
                  ? AppColors.black80
                  : AppColors.mainColor.withOpacity(.5),
            ),
            VSpace(24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  storedLanguage['Number of Return'] ?? "Number of Return",
                  style: t.displayMedium
                      ?.copyWith(color: AppThemes.getParagraphColor()),
                ),
                Text(
                  d?.numberOfReturn.toString() == "null"
                      ? storedLanguage['Lifetime Earning'] ?? "Lifetime Earning"
                      : "${d?.numberOfReturn.toString()} Times",
                  style: t.displayMedium,
                ),
              ],
            ),
            VSpace(8.h),
            Container(
              width: double.maxFinite,
              height: 1,
              color: Get.isDarkMode
                  ? AppColors.black80
                  : AppColors.mainColor.withOpacity(.5),
            ),
            VSpace(24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  storedLanguage['Capital Back'] ?? "Capital Back",
                  style: t.displayMedium
                      ?.copyWith(color: AppThemes.getParagraphColor()),
                ),
                Text(
                  data.capitalBack.toString() == "1"
                      ? storedLanguage['Yes'] ?? "Yes"
                      : storedLanguage['No'] ?? "No",
                  style: t.displayMedium?.copyWith(
                      color: data.capitalBack.toString() == "1"
                          ? AppColors.greenColor
                          : AppColors.redColor),
                ),
              ],
            ),
            VSpace(8.h),
            Container(
              width: double.maxFinite,
              height: 1,
              color: Get.isDarkMode
                  ? AppColors.black80
                  : AppColors.mainColor.withOpacity(.5),
            ),
            VSpace(24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  storedLanguage['Unit Price'] ?? "Unit Price",
                  style: t.displayMedium
                      ?.copyWith(color: AppThemes.getParagraphColor()),
                ),
                Text(
                  d?.fixedInvest == null
                      ? "${data.currencySymbol.toString()}${Helpers.numberFormatWithAsFixed2("", data.minimumInvest.toString())} - ${data.currencySymbol.toString()}${Helpers.numberFormatWithAsFixed2("", data.maximumInvest.toString())}"
                      : "${data.currencySymbol.toString()}${Helpers.numberFormatWithAsFixed2("", data.fixedInvest.toString())}",
                  style: context.t.displayMedium,
                ),
              ],
            ),
            VSpace(8.h),
            Container(
              width: double.maxFinite,
              height: 1,
              color: Get.isDarkMode
                  ? AppColors.black80
                  : AppColors.mainColor.withOpacity(.5),
            ),
            VSpace(24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  storedLanguage['Total Price'] ?? "Total Price",
                  style: t.displayMedium
                      ?.copyWith(color: AppThemes.getParagraphColor()),
                ),
                Text(
                  d?.fixedInvest == null
                      ? "${data.currencySymbol.toString()}${Helpers.numberFormatWithAsFixed2("", data.minimumInvest.toString())} - ${data.currencySymbol.toString()}${Helpers.numberFormatWithAsFixed2("", data.maximumInvest.toString())}"
                      :"${data.currencySymbol.toString()}${Helpers.numberFormatWithAsFixed2("", data.fixedInvest.toString())} × ${_.increment} = ${data.currencySymbol.toString()}${Helpers.numberFormatWithAsFixed2("", (double.parse(data.fixedInvest) * _.increment).toString())}",
                  style: context.t.displayMedium,
                ),
              ],
            ),
            VSpace(8.h),
            Container(
              width: double.maxFinite,
              height: 1,
              color: Get.isDarkMode
                  ? AppColors.black80
                  : AppColors.mainColor.withOpacity(.5),
            ),
            VSpace(32.h),
            Text(storedLanguage['Select Wallet'] ?? "Select Wallet", style: t.displayMedium),
            VSpace(12.h),
            GetBuilder<ProjectController>(builder: (_) {
              return Container(
                height: 50.h,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Get.isDarkMode
                          ? AppColors.black80
                          : AppColors.sliderInActiveColor),
                  borderRadius: Dimensions.kBorderRadius,
                ),
                child: AppCustomDropDown(
                  height: 50.h,
                  width: double.infinity,
                  items: ProfileController.to.walletList,
                  selectedValue: _.selectedWallet,
                  onChanged: (value) {
                    _.selectedWallet = value;
                    _.update();
                  },
                  hint: storedLanguage['Select Wallet'] ?? "Select Wallet",
                  selectedStyle: t.displayMedium,
                  bgColor: Get.isDarkMode
                      ? AppColors.darkBgColor
                      : AppColors.fillColorColor,
                ),
              );
            }),
            VSpace(20.h),
            Visibility(visible: data.fixedInvest == null,child: Text(storedLanguage['Price'] ?? 'Price', style: t.displayMedium)),
            VSpace(12.h),
            Visibility(
              visible: data.fixedInvest == null,
              child: GetBuilder<ProjectController>(builder: (_) {
                return CustomTextField(
                  enabled: data.fixedInvest == null,
                  isOnlyBorderColor: true,
                  borderColor: Get.isDarkMode
                      ? AppColors.black80
                      : AppColors.sliderInActiveColor,
                  isSuffixIcon:
                      _.amountVal == null || _.amountVal.toString().isEmpty
                          ? false
                          : true,
                  suffixIcon: _.isValidAmountRange ? "check" : "warning",
                  suffixIconColor: _.isValidAmountRange
                      ? AppColors.greenColor
                      : AppColors.redColor,
                  suffixIconSize: 20.h,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  hintStyle: t.bodySmall?.copyWith(color: AppColors.textFieldHintColor),
                  contentPadding: EdgeInsets.only(left: 20.w),
                  hintext: storedLanguage['Enter per unit price'] ??
                      'Enter per unit price',
                  controller: _.amountCtrl,
                  onChanged: _.onAmountChange,
                );
              }),
            ),
            VSpace(40.h),
            GetBuilder<ProjectController>(builder: (_) {
              return AppButton(
                isLoading: _.isPayment ? true : false,
                onTap: _.isPayment
                    ? null
                    : () async {
                        await _.onMakePaymentBtnClick(
                            context: context,
                            projectId: data.id.toString(),
                            unit: _.increment.toString());
                      },
                text: storedLanguage['Make Payment'] ?? "Make Payment",
              );
            }),
            VSpace(20.h),
            AppButton(
              bgColor: AppColors.redColor,
              onTap: () {
                Get.back();
              },
              text: storedLanguage['Cancel This Payment'] ??
                  "Cancel This Payment",
            ),
          ],
        ));
  }

  Widget caroselSection(c.CarouselSliderController controller, TextTheme t,
      ProjectController _, p.Datum? d) {
    return Container(
      height: Dimensions.screenHeight * .3,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          c.CarouselSlider(
              carouselController: controller,
              items: d == null || d.images == null || d.images!.isEmpty
                  ? [
                      InkWell(
                        onTap: () {
                          if (d != null && d.thumbnailImage != null)
                            Get.to(() => Scaffold(
                                appBar: const CustomAppBar(title: ""),
                                body: PhotoView(
                                  imageProvider: NetworkImage(d.thumbnailImage),
                                )));
                        },
                        child: d == null || d.thumbnailImage == null
                            ? SizedBox()
                            : Container(
                                height: Dimensions.screenHeight * .3,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  color: AppColors.imageBgColor,
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        d.thumbnailImage),
                                    fit: BoxFit.cover,
                                    opacity: .6,
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(20.r)),
                                ),
                              ),
                      )
                    ]
                  : d.images
                      ?.map(
                        (e) => InkWell(
                          onTap: () {
                            Get.to(() => Scaffold(
                                appBar: const CustomAppBar(title: ""),
                                body: PhotoView(
                                  imageProvider: NetworkImage(e),
                                )));
                          },
                          child: Container(
                            height: Dimensions.screenHeight * .3,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: AppColors.imageBgColor,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(e.toString()),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(24.r)),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(16.r)),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black12.withOpacity(.9),
                                          Colors.transparent,
                                          Colors.transparent,
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        stops: [0, 0.4, 0.4, 0],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
              options: c.CarouselOptions(
                height: Dimensions.screenHeight * .3,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                onPageChanged: (index, T) {
                  _.carouselIndex = index;
                  _.update();
                },
                scrollDirection: Axis.horizontal,
              )),
          Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: DotsIndicator(
              dotsCount: d == null || d.images == null || d.images!.isEmpty
                  ? 1
                  : d.images!.length,
              position: _.carouselIndex,
              decorator: DotsDecorator(
                color: AppColors.whiteColor,
                activeColor: AppColors.secondaryColor,
                size: Size.square(10.h),
                activeSize: Size(30.w, 8.h),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Container(
                        padding: EdgeInsets.all(8.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.whiteColor,
                            width: Get.isDarkMode ? .5 : .9,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "$rootImageDir/back.png",
                          height: 14.h,
                          width: 14.h,
                          color: AppColors.whiteColor,
                          fit: BoxFit.fitHeight,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
