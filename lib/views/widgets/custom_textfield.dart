import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amarkhamar/views/widgets/spacing.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../themes/themes.dart';
import '../../utils/app_constants.dart';
import 'app_textfield.dart';

class CustomTextField extends StatelessWidget {
  final bool? isPrefixIcon;
  final bool? isSuffixIcon;
  final bool? enabled;
  final String hintext;
  final String? prefixIcon;
  final String? suffixIcon;
  final dynamic Function(String)? onChanged;
  final TextEditingController controller;
  final Color? bgColor;
  final Color? suffixIconColor;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double? height;
  final int? minLines;
  final int? maxLines;
  final double? suffixIconSize;
  final double? preffixIconSize;
  final BoxFit? suffixFit;
  final EdgeInsetsGeometry? contentPadding;
  final AlignmentGeometry? alignment;
  final void Function()? onPreffixPressed;
  final void Function()? onSuffixPressed;
  final void Function(String)? onFieldSubmitted;
  final bool? obsCureText;
  final bool? isSuffixBgColor;
  final bool? isReverseColor;
  final bool? isBorderColor;
  final bool? isOnlyBorderColor;
  final Color? hintColor;
  final Color? borderColor;
  final double? borderWidth;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;
  final BorderRadiusGeometry? borderRadius;
  const CustomTextField(
      {super.key,
      this.isPrefixIcon = false,
      this.isSuffixIcon = false,
      this.enabled = true,
      this.hintColor,
      this.borderColor,
      this.borderWidth,
      this.onFieldSubmitted,
      required this.hintext,
      required this.controller,
      this.onChanged,
      this.bgColor,
      this.suffixIconColor,
      this.keyboardType = TextInputType.text,
      this.inputFormatters,
      this.height,
      this.minLines,
      this.maxLines,
      this.contentPadding,
      this.obsCureText = false,
      this.isSuffixBgColor = false,
      this.alignment,
      this.prefixIcon,
      this.suffixIcon,
      this.onPreffixPressed,
      this.onSuffixPressed,
      this.isReverseColor = false,
      this.isBorderColor = true,
      this.isOnlyBorderColor = true,
      this.suffixIconSize,
      this.validator,
      this.preffixIconSize,
      this.focusNode,
      this.suffixFit,
      this.borderRadius,
      this.hintStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50.h,
      alignment: alignment ?? Alignment.center,
      decoration: BoxDecoration(
        color: isOnlyBorderColor == false
            ? bgColor == null
                ? isReverseColor == true
                    ? Get.isDarkMode
                        ? AppColors.darkBgColor
                        : AppColors.fillColorColor
                    : AppThemes.getFillColor()
                : this.bgColor
            : Colors.transparent,
        borderRadius: borderRadius ?? Dimensions.kBorderRadius,
        border: Border.all(
            color: isOnlyBorderColor == true
                ? borderColor ?? AppThemes.getSliderInactiveColor()
                : isBorderColor == false
                    ? Colors.transparent
                    : borderColor ?? AppThemes.borderColor(),
            width: isOnlyBorderColor == true
                ? 1
                : borderWidth ?? Dimensions.appThinBorder),
      ),
      child: Row(
        children: [
          HSpace(isPrefixIcon == true ? 20.w : 0),
          isPrefixIcon == true
              ? InkResponse(
                  onTap: onPreffixPressed,
                  child: Image.asset(
                    "$rootImageDir/$prefixIcon.png",
                    height: preffixIconSize ?? 16.h,
                    width: preffixIconSize ?? 16.h,
                    color: Get.isDarkMode
                        ? AppColors.whiteColor
                        : AppColors.textFieldHintColor,
                    fit: BoxFit.cover,
                  ),
                )
              : const SizedBox(),
          Expanded(
            child: AppTextField(
              enabled: enabled,
              controller: controller,
              obscureText: obsCureText ?? false,
              hintStyle: hintStyle,
              minLines: minLines ?? 1,
              maxLines: maxLines ?? 1,
              hinText: hintext,
              onChanged: onChanged,
              hintColor: hintColor,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              contentPadding: contentPadding ?? EdgeInsets.only(left: 15.w),
              onFieldSubmitted: onFieldSubmitted,
              validator: validator,
              focusNode: focusNode,
            ),
          ),
          HSpace(isSuffixIcon == true ? 10.w : 0),
          isSuffixIcon == true
              ? Padding(
                  padding: isSuffixBgColor == true
                      ? EdgeInsets.all(8.h)
                      : EdgeInsets.only(right: 5.w),
                  child: Container(
                    width: 34.w,
                    decoration: BoxDecoration(
                        color: isSuffixBgColor == true
                            ? Get.isDarkMode
                                ? AppColors.darkCardColor
                                : AppColors.mainColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r)),
                    child: IconButton(
                        onPressed: onSuffixPressed,
                        icon: Image.asset(
                          "$rootImageDir/$suffixIcon.png",
                          height: suffixIconSize ?? 22.h,
                          width: suffixIconSize ?? 22.h,
                          color: suffixIconColor == null
                              ? Get.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.textFieldHintColor
                              : this.suffixIconColor,
                          fit: suffixFit ?? BoxFit.cover,
                        )),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
