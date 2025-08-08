import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:amarkhamar/views/widgets/appDialog.dart';
import 'package:amarkhamar/views/widgets/custom_textfield.dart';
import 'package:amarkhamar/views/widgets/spacing.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../config/app_colors.dart';
import '../../config/dimensions.dart';
import '../../config/styles.dart';
import '../../themes/themes.dart';
import 'app_button.dart';

searchDialog(
    {required BuildContext context,
    TextEditingController? transaction,
    TextEditingController? remark,
    TextEditingController? date,
    dynamic Function(String)? onRemarkChanged,
    void Function(DateRangePickerSelectionChangedArgs)? onSelectionChanged,
    dynamic Function(String)? onTextFieldChanged,
    dynamic Function(Object?)? onSubmit,
    bool? isRemarkField = true,
    bool? isTransactionField = true,
    bool? isDateTimeField = true,
    String? remarkHint,
    String? transactionHintext,
    void Function()? onSearchPressed}) {
  return appDialog(
      context: context,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Filter Now",
              style: Styles.bodyMedium.copyWith(
                  color: Get.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.blackColor)),
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
                color: AppThemes.getIconBlackColor(),
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isTransactionField == true
              ? CustomTextField(
                  isOnlyBorderColor: false,
                  hintext: transactionHintext ?? "Transaction ID",
                  controller: transaction!,
                  contentPadding: EdgeInsets.only(left: 20.w),
                )
              : const SizedBox(),
          VSpace(isTransactionField == true ? 24.h : 0),
          isRemarkField == true
              ? CustomTextField(
                  isOnlyBorderColor: false,
                  hintext: remarkHint ?? "Remark",
                  controller: remark!,
                  contentPadding: EdgeInsets.only(left: 20.w),
                  onChanged: onRemarkChanged,
                )
              : const SizedBox(),
          VSpace(isRemarkField == true ? 24.h : 0),
          if (isDateTimeField == true)
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Container(
                        width: Dimensions.screenWidth - 20.w,
                        height: 400.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: SfDateRangePicker(
                            headerHeight: 55.h,
                            headerStyle: DateRangePickerHeaderStyle(
                              textStyle: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontFamily: Styles.appFontFamily),
                              backgroundColor: Get.isDarkMode
                                  ? AppColors.darkCardColorDeep
                                  : AppColors.secondaryColor,
                            ),
                            backgroundColor: AppThemes.getDarkCardColor(),
                            rangeSelectionColor: Get.isDarkMode
                                ? AppColors.secondaryColor.withOpacity(.1)
                                : AppColors.secondaryColor.withOpacity(.2),
                            todayHighlightColor: AppColors.secondaryColor,
                            selectionColor: AppColors.whiteColor,
                            startRangeSelectionColor: AppColors.secondaryColor,
                            endRangeSelectionColor: AppColors.secondaryColor,
                            selectionMode: DateRangePickerSelectionMode.range,
                            selectionTextStyle: TextStyle(
                                color: AppColors.whiteColor,
                                fontFamily: Styles.appFontFamily),
                            rangeTextStyle: TextStyle(
                                color: AppColors.secondaryColor,
                                fontFamily: Styles.appFontFamily),
                            monthCellStyle: DateRangePickerMonthCellStyle(
                              todayTextStyle: TextStyle(
                                  fontFamily: Styles.appFontFamily,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondaryColor),
                            ),
                            showActionButtons: true,
                            onCancel: () {
                              Navigator.pop(context);
                            },
                            onSubmit: onSubmit,
                            onSelectionChanged: onSelectionChanged,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: IgnorePointer(
                ignoring: true,
                child: CustomTextField(
                  isOnlyBorderColor: false,
                  hintext: "Select Dates",
                  controller: date ?? TextEditingController(),
                  onChanged: onTextFieldChanged,
                  contentPadding: EdgeInsets.only(left: 20.w),
                ),
              ),
            ),
          VSpace(28.h),
          AppButton(
            text: "Search Now",
            style: Styles.bodyMedium.copyWith(color: AppColors.whiteColor),
            onTap: onSearchPressed,
          ),
        ],
      ));
}
