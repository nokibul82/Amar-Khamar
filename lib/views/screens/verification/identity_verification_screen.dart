import 'dart:math';
import 'package:amarkhamar/controllers/bindings/controller_index.dart';
import 'package:amarkhamar/views/widgets/text_theme_extension.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class IdentityVerificationScreen extends StatefulWidget {
  final String? verificationType;
  final String? id;
  final String? verifyStatus;
  const IdentityVerificationScreen(
      {super.key,
      this.id = "",
      this.verificationType = "",
      this.verifyStatus = ""});

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends State<IdentityVerificationScreen> {
  late ConfettiController _centerController;

  @override
  void initState() {
    super.initState();
    _centerController =
        ConfettiController(duration: const Duration(seconds: 15));
    _centerController.play();
  }

  @override
  void dispose() {
    _centerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<VerificationController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(
          title: "${widget.verificationType}",
        ),
        body: RefreshIndicator(
          color: AppColors.secondaryColor,
          onRefresh: () async {},
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: _.isLoading
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                if (widget.verifyStatus == "Approved")
                  Align(
                    alignment: Alignment.center,
                    child: ConfettiWidget(
                      confettiController: _centerController,
                      blastDirection: pi / 2,
                      maxBlastForce: 5,
                      minBlastForce: 1,
                      emissionFrequency: 0.03,
                      numberOfParticles: 10,
                      gravity: 0,
                    ),
                  ),
                if (widget.verifyStatus == "Approved" ||
                    widget.verifyStatus == "Pending")
                  Container(
                    margin: EdgeInsets.only(top: 100.h),
                    height: 160.h,
                    width: 160.h,
                    padding: EdgeInsets.all(25.h),
                    decoration: BoxDecoration(
                      color: widget.verifyStatus == "Approved"
                          ? AppColors.greenColor.withOpacity(.2)
                          : AppColors.pendingColor.withOpacity(.2),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      widget.verifyStatus == "Approved"
                          ? '$rootImageDir/success.gif'
                          : '$rootImageDir/pending.gif',
                      fit: BoxFit.fill,
                    ),
                  ),
                if (widget.verifyStatus == "Approved" ||
                    widget.verifyStatus == "Pending")
                  VSpace(20.h),
                if (widget.verifyStatus == "Approved" ||
                    widget.verifyStatus == "Pending")
                  Center(
                    child: Text(
                        widget.verifyStatus == "Approved"
                            ? "Your ${widget.verificationType} has been approved."
                            : "Your ${widget.verificationType} has been pending.",
                        textAlign: TextAlign.center,
                        style: context.t.displayMedium?.copyWith(
                            color: widget.verifyStatus == "Approved"
                                ? AppColors.greenColor
                                : AppColors.pendingColor)),
                  ),
                if (widget.verifyStatus != "Approved" &&
                    widget.verifyStatus != "Pending")
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                    child: Form(
                      key: _.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (_.filteredList.isNotEmpty) ...[
                            VSpace(30.h),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _.filteredList.length,
                              itemBuilder: (context, index) {
                                final dynamicField = _.filteredList[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (dynamicField.type == "file")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Container(
                                            height: 45.5,
                                            width: double.maxFinite,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 10.h),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  Dimensions.kBorderRadius,
                                              border: Border.all(
                                                  color: _.fileColorOfDField ==
                                                          AppColors.redColor
                                                      ? _.fileColorOfDField
                                                      : AppThemes
                                                          .getSliderInactiveColor(),
                                                  width: 1),
                                            ),
                                            child: Row(
                                              children: [
                                                HSpace(12.w),
                                                Text(
                                                  _.imagePickerResults[
                                                              dynamicField
                                                                  .fieldName] !=
                                                          null
                                                      ? storedLanguage[
                                                              '1 File selected'] ??
                                                          "1 File selected"
                                                      : storedLanguage[
                                                              'No File selected'] ??
                                                          "No File selected",
                                                  style: context.t.bodySmall?.copyWith(
                                                      color: _.imagePickerResults[
                                                                  dynamicField
                                                                      .fieldName] !=
                                                              null
                                                          ? AppColors.greenColor
                                                          : AppColors.black60),
                                                ),
                                                const Spacer(),
                                                Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      Helpers.hideKeyboard();

                                                      await _.pickFile(
                                                          dynamicField
                                                              .fieldName!);
                                                    },
                                                    borderRadius: Dimensions
                                                        .kBorderRadius,
                                                    child: Ink(
                                                      width: 113.w,
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .secondaryColor,
                                                        borderRadius: Dimensions
                                                                .kBorderRadius /
                                                            1.7,
                                                        border: Border.all(
                                                            color: AppColors
                                                                .mainColor,
                                                            width: .2),
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                              storedLanguage[
                                                                      'Choose File'] ??
                                                                  'Choose File',
                                                              style: context
                                                                  .t.bodySmall
                                                                  ?.copyWith(
                                                                      color: AppColors
                                                                          .whiteColor))),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                        ],
                                      ),
                                    if (dynamicField.type == "text")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              // Perform validation based on the 'validation' property
                                              if (dynamicField.validation ==
                                                      "required" &&
                                                  value!.isEmpty) {
                                                return storedLanguage[
                                                        'Field is required'] ??
                                                    "Field is required";
                                              }
                                              return null;
                                            },
                                            onChanged: (v) {
                                              _
                                                  .textEditingControllerMap[
                                                      dynamicField.fieldName]!
                                                  .text = v;
                                            },
                                            controller:
                                                _.textEditingControllerMap[
                                                    dynamicField.fieldName],
                                            keyboardType: dynamicField
                                                    .fieldLevel
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains("number")
                                                ? TextInputType.number
                                                : TextInputType.text,
                                            inputFormatters: dynamicField
                                                    .fieldLevel
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains("number")
                                                ? <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ]
                                                : [],
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 16),
                                              filled:
                                                  true, // Fill the background with color
                                              hintStyle: TextStyle(
                                                color: AppColors
                                                    .textFieldHintColor,
                                              ),
                                              fillColor: Colors
                                                  .transparent, // Background color
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppThemes
                                                      .getSliderInactiveColor(),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                borderSide: BorderSide(
                                                    color: AppColors
                                                        .secondaryColor),
                                              ),
                                            ),
                                            style: context.t.displayMedium,
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                        ],
                                      ),
                                    if (dynamicField.type == "email")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              // Perform validation based on the 'validation' property
                                              if (dynamicField.validation ==
                                                      "required" &&
                                                  value!.isEmpty) {
                                                return storedLanguage[
                                                        'Field is required'] ??
                                                    "Field is required";
                                              }
                                              return null;
                                            },
                                            onChanged: (v) {
                                              _
                                                  .textEditingControllerMap[
                                                      dynamicField.fieldName]!
                                                  .text = v;
                                            },
                                            controller:
                                                _.textEditingControllerMap[
                                                    dynamicField.fieldName],
                                            keyboardType: dynamicField
                                                    .fieldLevel
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains("number")
                                                ? TextInputType.number
                                                : TextInputType.text,
                                            inputFormatters: dynamicField
                                                    .fieldLevel
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains("number")
                                                ? <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ]
                                                : [],
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 16),
                                              filled:
                                                  true, // Fill the background with color
                                              hintStyle: TextStyle(
                                                color: AppColors
                                                    .textFieldHintColor,
                                              ),
                                              fillColor: Colors
                                                  .transparent, // Background color
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppThemes
                                                      .getSliderInactiveColor(),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                borderSide: BorderSide(
                                                    color: AppColors
                                                        .secondaryColor),
                                              ),
                                            ),
                                            style: context.t.displayMedium,
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                        ],
                                      ),
                                    if (dynamicField.type == "url")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              // Perform validation based on the 'validation' property
                                              if (dynamicField.validation ==
                                                      "required" &&
                                                  value!.isEmpty) {
                                                return storedLanguage[
                                                        'Field is required'] ??
                                                    "Field is required";
                                              }
                                              return null;
                                            },
                                            onChanged: (v) {
                                              _
                                                  .textEditingControllerMap[
                                                      dynamicField.fieldName]!
                                                  .text = v;
                                            },
                                            controller:
                                                _.textEditingControllerMap[
                                                    dynamicField.fieldName],
                                            keyboardType: dynamicField
                                                    .fieldLevel
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains("number")
                                                ? TextInputType.number
                                                : TextInputType.text,
                                            inputFormatters: dynamicField
                                                    .fieldLevel
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains("number")
                                                ? <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ]
                                                : [],
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 16),
                                              filled:
                                                  true, // Fill the background with color
                                              hintStyle: TextStyle(
                                                color: AppColors
                                                    .textFieldHintColor,
                                              ),
                                              fillColor: Colors
                                                  .transparent, // Background color
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppThemes
                                                      .getSliderInactiveColor(),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                borderSide: BorderSide(
                                                    color: AppColors
                                                        .secondaryColor),
                                              ),
                                            ),
                                            style: context.t.displayMedium,
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                        ],
                                      ),
                                    if (dynamicField.type == "number")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              // Perform validation based on the 'validation' property
                                              if (dynamicField.validation ==
                                                      "required" &&
                                                  value!.isEmpty) {
                                                return storedLanguage[
                                                        'Field is required'] ??
                                                    "Field is required";
                                              }
                                              return null;
                                            },
                                            onChanged: (v) {
                                              _
                                                  .textEditingControllerMap[
                                                      dynamicField.fieldName]!
                                                  .text = v;
                                            },
                                            controller:
                                                _.textEditingControllerMap[
                                                    dynamicField.fieldName],
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 16),
                                              filled:
                                                  true, // Fill the background with color
                                              hintStyle: TextStyle(
                                                color: AppColors
                                                    .textFieldHintColor,
                                              ),
                                              fillColor: Colors
                                                  .transparent, // Background color
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppThemes
                                                      .getSliderInactiveColor(),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                borderSide: BorderSide(
                                                    color: AppColors
                                                        .secondaryColor),
                                              ),
                                            ),
                                            style: context.t.displayMedium,
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                        ],
                                      ),
                                    if (dynamicField.type == "date")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              /// SHOW DATE PICKER
                                              await showDatePicker(
                                                      context: context,
                                                      builder:
                                                          (context, child) {
                                                        return Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              colorScheme:
                                                                  ColorScheme
                                                                      .dark(
                                                                surface: Get
                                                                        .isDarkMode
                                                                    ? AppColors
                                                                        .darkCardColor
                                                                    : AppColors
                                                                        .paragraphColor,
                                                                onPrimary: AppColors
                                                                    .whiteColor,
                                                              ),
                                                              textButtonTheme:
                                                                  TextButtonThemeData(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      AppColors
                                                                          .mainColor, // button text color
                                                                ),
                                                              ),
                                                            ),
                                                            child: child!);
                                                      },
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(2025))
                                                  .then((value) {
                                                if (value != null) {
                                                  _
                                                      .textEditingControllerMap[
                                                          dynamicField
                                                              .fieldName]!
                                                      .text = DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(value);
                                                }
                                              });
                                            },
                                            child: IgnorePointer(
                                              ignoring: true,
                                              child: TextFormField(
                                                validator: (value) {
                                                  // Perform validation based on the 'validation' property
                                                  if (dynamicField.validation ==
                                                          "required" &&
                                                      value!.isEmpty) {
                                                    return storedLanguage[
                                                            'Field is required'] ??
                                                        "Field is required";
                                                  }
                                                  return null;
                                                },
                                                controller:
                                                    _.textEditingControllerMap[
                                                        dynamicField.fieldName],
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0,
                                                          horizontal: 16),
                                                  filled:
                                                      true, // Fill the background with color
                                                  hintStyle: TextStyle(
                                                    color: AppColors
                                                        .textFieldHintColor,
                                                  ),
                                                  fillColor: Colors
                                                      .transparent, // Background color
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppThemes
                                                          .getSliderInactiveColor(),
                                                      width: 1,
                                                    ),
                                                    borderRadius: Dimensions
                                                        .kBorderRadius,
                                                  ),

                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius: Dimensions
                                                        .kBorderRadius,
                                                    borderSide: BorderSide(
                                                        color: AppColors
                                                            .secondaryColor),
                                                  ),
                                                ),
                                                style: context.t.displayMedium,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                        ],
                                      ),
                                    if (dynamicField.type == 'textarea')
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              if (dynamicField.validation ==
                                                      "required" &&
                                                  value!.isEmpty) {
                                                return storedLanguage[
                                                        'Field is required'] ??
                                                    "Field is required";
                                              }
                                              return null;
                                            },
                                            controller:
                                                _.textEditingControllerMap[
                                                    dynamicField.fieldName],
                                            maxLines: 7,
                                            minLines: 5,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                              filled: true,
                                              hintStyle: TextStyle(
                                                color: AppColors
                                                    .textFieldHintColor,
                                              ),
                                              fillColor: Colors
                                                  .transparent, // Background color
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppThemes
                                                      .getSliderInactiveColor(),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                borderSide: BorderSide(
                                                    color: AppColors
                                                        .secondaryColor),
                                              ),
                                            ),
                                            style: context.t.displayMedium,
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                        ],
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                          SizedBox(
                            height: 30.h,
                          ),
                          AppButton(
                              isLoading: _.isIdentitySubmitting ? true : false,
                              text: storedLanguage['Submit'] ?? 'Submit',
                              onTap: _.isIdentitySubmitting
                                  ? null
                                  : () async {
                                      Helpers.hideKeyboard();
                                      if (_.formKey.currentState!.validate() &&
                                          _.requiredFile.isEmpty) {
                                        _.fileColorOfDField =
                                            AppColors.mainColor;
                                        _.update();
                                        await _.renderDynamicFieldData();

                                        Map<String, String> stringMap = {};
                                        _.dynamicData.forEach((key, value) {
                                          if (value is String) {
                                            stringMap[key] = value;
                                          }
                                        });

                                        await Future.delayed(
                                            Duration(milliseconds: 300));

                                        Map<String, String> body = {
                                          "kyc_id": widget.id ?? "",
                                        };
                                        body.addAll(stringMap);

                                        await _
                                            .submitVerification(
                                                fields: body,
                                                fileList: _.fileMap.entries
                                                    .map((e) => e.value)
                                                    .toList(),
                                                context: context)
                                            .then((value) {});
                                      } else {
                                        _.fileColorOfDField =
                                            AppColors.redColor;
                                        _.update();
                                        print(
                                            "required type file list===========================: ${_}");
                                        Helpers.showSnackBar(
                                            msg:
                                                "Please fill in all required fields.");
                                      }
                                    }),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
