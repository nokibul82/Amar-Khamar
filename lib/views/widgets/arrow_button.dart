import 'package:amarkhamar/controllers/bindings/controller_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/app_colors.dart';
import '../../config/dimensions.dart';
import '../../themes/themes.dart';
import '../../utils/app_constants.dart';
import 'spacing.dart';

class ArrowButton extends StatelessWidget {
  const ArrowButton({
    super.key,
    required this.t,
    this.height,
    this.width,
    this.onTap,
    required this.text,
    this.borderRadius,
    this.style,
    this.bgColor,
    this.arrowSize,
    this.textColor,
    this.arrowColor,
  });

  final TextTheme t;
  final double? width;
  final double? height;
  final double? arrowSize;
  final void Function()? onTap;
  final String text;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? style;
  final Color? bgColor;
  final Color? textColor;
  final Color? arrowColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: Dimensions.kBorderRadius / 2,
        onTap: onTap,
        child: Ink(
          width: width ?? 117.w,
          height: height ?? 30.h,
          decoration: BoxDecoration(
            color: bgColor != null
                ? this.bgColor
                : Get.isDarkMode
                    ? AppColors.darkCardColor
                    : AppColors.whiteColor,
            borderRadius: borderRadius ?? Dimensions.kBorderRadius / 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: style ??
                    t.bodySmall?.copyWith(color:textColor ?? AppThemes.getIconBlackColor()),
              ),
              HSpace(8.w),
              Image.asset(
                "$rootImageDir/big_arrow.png",
                width: arrowSize ?? 20.h,
                height: arrowSize ?? 20.h,
                fit: BoxFit.fitWidth,
                color:arrowColor ?? AppThemes.getIconBlackColor(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
