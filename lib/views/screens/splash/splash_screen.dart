import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amarkhamar/config/styles.dart';
import 'package:amarkhamar/controllers/app_controller.dart';
import 'package:amarkhamar/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:amarkhamar/views/widgets/mediaquery_extension.dart';
import 'package:amarkhamar/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AppController appController = Get.find<AppController>();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
         HiveHelp.read(Keys.token) != null
          ? Get.offAllNamed(RoutesName.mainDrawerScreen)
          : HiveHelp.read(Keys.isNewUser) != null
              ? Get.offAllNamed(RoutesName.loginScreen)
              : Get.offAllNamed(RoutesName.onbordingScreen);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.mQuery.width,
      height: context.mQuery.height,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("$rootImageDir/splash_bg.png"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: AppColors.mainColor.withOpacity(.95),
        body: SizedBox(
          width: context.mQuery.width,
          height: context.mQuery.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        width: 200.h,
                        height: 200.h,
                        padding: EdgeInsets.all(30.h),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.whiteColor,
                          border: Border.all(
                              color: AppColors.secondaryColor, width: 5.h),
                        ),
                        child: Image.asset(
                          "$rootImageDir/amar_khamar_logo.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 70.h,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Amar Khamar',
                        speed: Duration(milliseconds: 500),
                        textStyle: context.t.titleLarge!.copyWith(
                            fontSize: 28.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: Styles.secondaryFontFamily),
                        colors: [
                          AppColors.secondaryColor,
                          AppColors.blackColor,
                        ],
                      ),
                    ],
                    isRepeatingAnimation: false,
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
