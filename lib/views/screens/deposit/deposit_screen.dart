import '../../../controllers/bindings/controller_index.dart';
import '../../../utils/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/dimensions.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class DepositScreen extends StatefulWidget {
  final bool? isFromBottomNav;
  const DepositScreen({super.key, this.isFromBottomNav = true});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  FocusNode node = FocusNode();
  @override
  void initState() {
    node.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    Get.put(DepositController());
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};

    return GetBuilder<DepositController>(builder: (_) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: Get.isDarkMode
            ? BoxDecoration(
                image: DecorationImage(
                image: AssetImage("$rootImageDir/scaffold_bg.png"),
                fit: BoxFit.fitHeight,
              ))
            : BoxDecoration(
                image: DecorationImage(
                image: AssetImage("$rootImageDir/scaffold_bg.png"),
                fit: BoxFit.fitHeight,
                colorFilter: ColorFilter.mode(
                  Colors.grey,
                  BlendMode.saturation,
                ),
              )),
        child: Scaffold(
          backgroundColor: Get.isDarkMode
              ? AppColors.darkBgColor
              : Colors.white.withOpacity(.9),
          appBar: CustomAppBar(
            title:storedLanguage['Deposit'] ?? "Deposit",
            bgColor: Get.isDarkMode
                ? AppColors.darkBgColor
                : AppColors.black5.withOpacity(.2),
            leading: widget.isFromBottomNav == true ? SizedBox() : null,
          ),
          body: _.isLoading
              ? Helpers.appLoader()
              : _.paymentGatewayList.isEmpty
                  ? Helpers.notFound()
                  : Padding(
                      padding: Dimensions.kDefaultPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VSpace(32.h),
                          CustomTextField(
                            isOnlyBorderColor: true,
                            hintext: storedLanguage['Search Gateway'] ??
                                "Search Gateway",
                            controller: _.gatewayEditingController,
                            onChanged: _.queryPaymentGateway,
                            isSuffixIcon: true,
                            isSuffixBgColor: true,
                            suffixIcon: "search",
                            suffixIconColor: Get.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                          ),
                          VSpace(32.h),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                    color: Get.isDarkMode
                                        ? AppColors.darkCardColorDeep
                                        : AppColors.black20,
                                    width: Get.isDarkMode ? .6 : .2)),
                            child: ListView.builder(
                                itemCount: _.isGatewaySearching
                                    ? _.searchedGatewayItem.length
                                    : _.paymentGatewayList.length,
                                itemBuilder: (context, i) {
                                  var data = _.isGatewaySearching
                                      ? _.searchedGatewayItem[i]
                                      : _.paymentGatewayList[i];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 10.h),
                                    child: InkWell(
                                      borderRadius:
                                          Dimensions.kBorderRadius / 2,
                                      onTap: () async {
                                        Helpers.hideKeyboard();
                                        _.selectedGatewayIndex = i;
                                        _.getGatewayData(i);
                                        _.getSelectedGatewayData(i);
                                        _.update();
                                        buildDialog(context, _, storedLanguage);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h, horizontal: 16.w),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Get.isDarkMode
                                                      ? AppColors
                                                          .darkCardColorDeep
                                                      : AppColors.black20,
                                                  width: Get.isDarkMode
                                                      ? .6
                                                      : .2)),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 42.h,
                                              width: 64.w,
                                              decoration: BoxDecoration(
                                                  color: Get.isDarkMode
                                                      ? AppColors.darkBgColor
                                                      : AppColors
                                                          .fillColorColor,
                                                  borderRadius:
                                                      Dimensions.kBorderRadius /
                                                          2,
                                                  image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            data.image),
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                            HSpace(16.w),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(data.name.toString(),
                                                    style: t.bodyMedium),
                                                VSpace(1.h),
                                                Text(
                                                    data.description.toString(),
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: t.bodySmall?.copyWith(
                                                        color: AppThemes
                                                            .getParagraphColor())),
                                              ],
                                            )),
                                            Container(
                                              width: 20.h,
                                              height: 20.h,
                                              decoration: BoxDecoration(
                                                color: _.selectedGatewayIndex ==
                                                        i
                                                    ? AppColors.secondaryColor
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: _.selectedGatewayIndex !=
                                                            i
                                                        ? Get.isDarkMode
                                                            ? AppColors
                                                                .darkCardColorDeep
                                                            : AppColors.black20
                                                        : Colors.transparent),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.done_rounded,
                                                  size: 14.h,
                                                  color:
                                                      _.selectedGatewayIndex ==
                                                              i
                                                          ? AppColors.whiteColor
                                                          : Colors.transparent,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )),
                        ],
                      ),
                    ),
        ),
      );
    });
  }

  Future<dynamic> buildDialog(
      BuildContext context, DepositController addFundCtrl, storedLanguage) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<DepositController>(builder: (_) {
          return Container(
              padding: Dimensions.kDefaultPadding,
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppThemes.getDarkCardColor(),
                borderRadius: Dimensions.kBorderRadius * 2,
              ),
              child: ListView(
                children: [
                  VSpace(32.h),
                  if (_.gatewayName != "")
                    Padding(
                      padding: Dimensions.kDefaultPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                _.selectedCurrency == null
                                    ? const SizedBox()
                                    : Text(
                                        "${storedLanguage['Transaction Limit:'] ?? "Transaction Limit:"} ${_.minAmount}-${_.maxAmount} ${_.selectedCurrency}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.t.bodySmall?.copyWith(
                                            color: AppColors.redColor),
                                      ),
                                Spacer(),
                                Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Ink(
                                      height: 26.h,
                                      width: 26.h,
                                      padding: EdgeInsets.all(3.h),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Get.isDarkMode
                                              ? AppColors.darkBgColor
                                              : AppColors.sliderInActiveColor),
                                      child: Icon(
                                        Icons.close,
                                        size: 15.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          VSpace(20.h),
                          _.selectedCurrency == null
                              ? const SizedBox()
                              : VSpace(12.h),
                          Text(
                            storedLanguage['Select Gateway Currency'] ??
                                "Select Gateway Currency",
                            style: context.t.displayMedium,
                          ),
                          VSpace(12.h),
                          Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppThemes.getSliderInactiveColor()),
                              borderRadius: Dimensions.kBorderRadius,
                            ),
                            child: AppCustomDropDown(
                              height: 50.h,
                              width: double.infinity,
                              items: _.supportedCurrencyList
                                  .map((e) => e)
                                  .toList(),
                              selectedValue: _.selectedCurrency,
                              onChanged: (value) async {
                                _.selectedCurrency = value;
                                if (_.is_crypto == false) {
                                  _.getSelectedCurrencyData(value);
                                }
                                _.update();
                              },
                              hint: storedLanguage['Select currency'] ??
                                  "Select currency",
                              selectedStyle: context.t.displayMedium,
                              bgColor: Get.isDarkMode
                                  ? AppColors.darkBgColor
                                  : AppColors.fillColorColor,
                            ),
                          ),
                          VSpace(20.h),
                          _.selectedCurrency == null
                              ? const SizedBox()
                              : Text(storedLanguage['Amount'] ?? 'Amount',
                                  style: context.t.displayMedium),
                          _.selectedCurrency == null
                              ? const SizedBox()
                              : VSpace(12.h),
                          _.selectedCurrency == null
                              ? const SizedBox()
                              : CustomTextField(
                                  focusNode: node,
                                  isSuffixIcon:
                                      _.amountValue.isEmpty ? false : true,
                                  suffixIcon: _.isFollowedTransactionLimit
                                      ? "check"
                                      : "warning",
                                  suffixIconSize: _.isFollowedTransactionLimit
                                      ? 20.h
                                      : 15.h,
                                  suffixIconColor: _.isFollowedTransactionLimit
                                      ? AppColors.greenColor
                                      : AppColors.redColor,
                                  contentPadding: EdgeInsets.only(left: 20.w),
                                  hintext: storedLanguage['Enter Amount'] ??
                                      'Enter Amount',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(
                                        _.maxAmount.length),
                                  ],
                                  controller: _.amountCtrl,
                                  onChanged: _.onChangedAmount,
                                ),
                          VSpace(16.h),
                          if (_.amountValue.isNotEmpty &&
                              _.selectedCurrency != null)
                            Container(
                              height: 180.h,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: Dimensions.kBorderRadius,
                                border: Border.all(
                                    color: Get.isDarkMode
                                        ? AppColors.black60
                                        : AppColors.black30,
                                    width: Dimensions.appThinBorder),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "Amount In ${_.is_crypto ? "USD" : _.selectedCurrency}",
                                              style: context
                                                  .t.displayMedium
                                                  ?.copyWith(
                                                      color: Get.isDarkMode
                                                          ? AppColors
                                                              .textFieldHintColor
                                                          : AppColors
                                                              .paragraphColor)),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                "${_.amountValue} ${_.is_crypto ? "USD" : _.selectedCurrency}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.displayMedium),
                                          )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: .2,
                                      color: Get.isDarkMode
                                          ? AppColors.black60
                                          : AppColors.black30,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(storedLanguage['Charge'] ??"Charge",
                                              style: context.t.displayMedium
                                                  ?.copyWith(
                                                      color: Get.isDarkMode
                                                          ? AppColors
                                                              .textFieldHintColor
                                                          : AppColors
                                                              .paragraphColor)),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                "${Helpers.numberFormatWithAsFixed2("", _.charge)} ${_.is_crypto ? "USD" : _.selectedCurrency}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.displayMedium
                                                    ?.copyWith(
                                                  color: AppColors.redColor,
                                                )),
                                          )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: .2,
                                      color: Get.isDarkMode
                                          ? AppColors.black60
                                          : AppColors.black30,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(storedLanguage['Payable Amount'] ??"Payable Amount",
                                              style: context.t.displayMedium
                                                  ?.copyWith(
                                                      color: Get.isDarkMode
                                                          ? AppColors
                                                              .textFieldHintColor
                                                          : AppColors
                                                              .paragraphColor)),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                "${Helpers.numberFormatWithAsFixed2("", _.totalChargedAmount)} ${_.is_crypto ? "USD" : _.selectedCurrency}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.displayMedium
                                                    ?.copyWith(
                                                  color: AppColors.greenColor,
                                                )),
                                          )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: .2,
                                      color: Get.isDarkMode
                                          ? AppColors.black60
                                          : AppColors.black30,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              storedLanguage[
                                                      'In Base Currency'] ??
                                                  "In Base Currency",
                                              style: context.t.displayMedium
                                                  ?.copyWith(
                                                      color: Get.isDarkMode
                                                          ? AppColors
                                                              .textFieldHintColor
                                                          : AppColors
                                                              .paragraphColor)),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                "${_.totalPayableAmountInBaseCurrency}  ${HiveHelp.read(Keys.baseCurrency)}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.displayMedium
                                                    ?.copyWith(
                                                  color: AppColors.greenColor,
                                                )),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          VSpace(32.h),
                          Material(
                            color: Colors.transparent,
                            child: AppButton(
                              isLoading: _.isLoadingPaymentSheet ? true : false,
                              onTap: _.isLoadingPaymentSheet
                                  ? null
                                  : () async {
                                      Helpers.hideKeyboard();
                                      if (_.amountCtrl.text.isEmpty) {
                                        Helpers.showSnackBar(
                                            msg: "Amount field is required");
                                      } else {
                                        if (double.parse(_.amountCtrl.text) <
                                            double.parse(_.minAmount)) {
                                          Helpers.showSnackBar(
                                              msg:
                                                  "minimum payment ${_.minAmount} and maximum payment limit ${_.maxAmount}");
                                        } else if (_
                                                .isFollowedTransactionLimit ==
                                            false) {
                                          Helpers.showSnackBar(
                                              msg:
                                                  "minimum payment ${_.minAmount} and maximum payment limit ${_.maxAmount}");
                                        } else {
                                          await _.addFundRequest(
                                            context: context,
                                            fields: {
                                              "amount": _.amountCtrl.text,
                                              "gateway_id":
                                                  _.gatewayId.toString(),
                                              "supported_currency":
                                                  _.selectedCurrency,
                                            },
                                          );
                                        }
                                      }
                                    },
                              text: storedLanguage['Confirm & Next'] ??"Confirm & Next",
                            ),
                          ),
                          VSpace(node.hasFocus ? 150.h : 50.h),
                        ],
                      ),
                    ),
                  VSpace(32.h),
                ],
              ));
        });
      },
    );
  }
}
