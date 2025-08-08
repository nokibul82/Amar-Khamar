import '../../../../controllers/bindings/controller_index.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../widgets/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/dimensions.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/spacing.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<ProductListController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(title: "Filter"),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(20.h),
              VSpace(32.h),
              Padding(
                padding: Dimensions.kDefaultPadding,
                child: Text(
                  "Product Category",
                  style: t.bodyMedium,
                ),
              ),
              VSpace(15.h),
              Padding(
                padding: Dimensions.kDefaultPadding,
                child: Wrap(
                  children: [
                    ...List.generate(
                      _.categoryList.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(32.r),
                          onTap: () {
                            _.addCatgory(_.categoryList[index].id.toString());
                          },
                          child: Ink(
                            padding: EdgeInsets.symmetric(
                                vertical: 9.h, horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: _.selectedCategoryList.toString().contains(
                                      _.categoryList[index].id.toString())
                                  ? AppColors.secondaryColor
                                  : AppThemes.getFillColor(),
                              borderRadius: BorderRadius.circular(32.r),
                            ),
                            child: Text(_.categoryList[index].name.toString(),
                                style: t.displayMedium?.copyWith(
                                  color: _.selectedCategoryList.contains(
                                          _.categoryList[index].id.toString())
                                      ? AppColors.whiteColor
                                      : Get.isDarkMode
                                          ? AppColors.whiteColor
                                          : AppColors.blackColor,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              VSpace(36.h),
              Padding(
                padding: Dimensions.kDefaultPadding,
                child: Text(
                  "Availability",
                  style: t.bodyMedium,
                ),
              ),
              VSpace(15.h),
              Padding(
                padding: Dimensions.kDefaultPadding,
                child: Wrap(
                  runSpacing: 20.h,
                  children: [
                    ...List.generate(
                      _.availabilityList.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(32.r),
                          onTap: () {
                            _.addAvalilable(_.availabilityList[index].slug);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 9.h, horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: _.selectedAvailableList
                                      .contains(_.availabilityList[index].slug)
                                  ? AppColors.secondaryColor
                                  : AppThemes.getFillColor(),
                              borderRadius: BorderRadius.circular(32.r),
                            ),
                            child: Text(_.availabilityList[index].name,
                                style: t.displayMedium?.copyWith(
                                  color: _.selectedAvailableList.contains(
                                          _.availabilityList[index].slug)
                                      ? AppColors.whiteColor
                                      : Get.isDarkMode
                                          ? AppColors.whiteColor
                                          : AppColors.blackColor,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              VSpace(36.h),
              Padding(
                padding: Dimensions.kDefaultPadding,
                child: Text(
                  "Price",
                  style: t.bodyMedium,
                ),
              ),
              Center(
                  child: Text(
                '${HiveHelp.read(Keys.currencySymbol)}${_.priceRange.start.toStringAsFixed(0)} — ${HiveHelp.read(Keys.currencySymbol)}${_.priceRange.end.toStringAsFixed(0)}',
                style: context.t.displayMedium
                    ?.copyWith(color: AppColors.secondaryColor),
              )),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2.h,
                  thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 8.h, disabledThumbRadius: 8.h),
                  activeTrackColor: AppColors.secondaryColor,
                  inactiveTrackColor: AppThemes.getSliderInactiveColor(),
                ),
                child: SfRangeSlider(
                  min: 0.0,
                  max: 5000.0,
                  values: _.priceRange,
                  interval: 100,
                  showTicks: false,
                  showLabels: false,
                  activeColor: AppColors.secondaryColor,
                  inactiveColor: AppThemes.getSliderInactiveColor(),
                  onChanged: (SfRangeValues newRange) {
                    _.priceRange = newRange;
                    _.update();
                  },
                ),
              ),
              VSpace(36.h),
              Padding(
                padding: Dimensions.kDefaultPadding,
                child: AppButton(
                  text: "Filter Now",
                  onTap: () async {
                    _.resetDataAfterSearching();
                    _.getProductList(
                        page: 1,
                        status: _.selectedAvailableList,
                        category: _.selectedCategoryList,
                        min: _.priceRange.start.toString(),
                        max: _.priceRange.end.toString(),
                        sorting: "");
                    Get.back();
                  },
                ),
              ),
              VSpace(36.h),
            ],
          ),
        ),
      );
    });
  }
}
