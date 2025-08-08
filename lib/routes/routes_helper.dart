import 'page_index.dart';
import 'routes_name.dart';

class RouteHelper {
  static List<GetPage> routes() => [
        GetPage(
            name: RoutesName.INITIAL,
            page: () => SplashScreen(),
            transition: Transition.zoom),
        GetPage(
            name: RoutesName.onbordingScreen,
            page: () => OnbordingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.bottomNavBar,
            page: () => BottomNavBar(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.loginScreen,
            page: () => LoginScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.signUpScreen,
            page: () => SignUpScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.forgotPassScreen,
            page: () => ForgotPassScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.otpScreen,
            page: () => OtpScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.createNewPassScreen,
            page: () => CreateNewPassScreen(),
            transition: Transition.fade),

        GetPage(
            name: RoutesName.profileSettingScreen,
            page: () => ProfileSettingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.editProfileScreen,
            page: () => EditProfileScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.changePasswordScreen,
            page: () => ChangePasswordScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.supportTicketListScreen,
            page: () => SupportTicketListScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.supportTicketViewScreen,
            page: () => SupportTicketViewScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.createSupportTicketScreen,
            page: () => CreateSupportTicketScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.twoFaVerificationScreen,
            page: () => TwoFaVerificationScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.identityVerificationScreen,
            page: () => IdentityVerificationScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.verificationListScreen,
            page: () => VerificationListScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.notificationScreen,
            page: () => NotificationScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.homeScreen,
            page: () => HomeScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.transactionScreen,
            page: () => TransactionScreen(),
            transition: Transition.fade),
        //
        GetPage(
            name: RoutesName.mainDrawerScreen,
            page: () => MainDrawerScreen(),
            transition: Transition.fade),
        //
        GetPage(
            name: RoutesName.depositScreen,
            page: () => DepositScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.depositHistoryScreen,
            page: () => DepositHistoryScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.withdrawScreen,
            page: () => WithdrawScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.withdrawPreviewScreen,
            page: () => WithdrawPreviewScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.flutterWaveWithdrawScreen,
            page: () => FlutterWaveWithdrawScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.withdrawHistoryScreen,
            page: () => WithdrawHistoryScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.paymentSuccessScreen,
            page: () => PaymentSuccessScreen(),
            transition: Transition.fade),

        GetPage(
            name: RoutesName.notificationPermissionScreen,
            page: () => NotificationPermissionScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.referralScreen,
            page: () => ReferralScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.referralBonusScreen,
            page: () => ReferListScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.projectInvestScreen,
            page: () => ProjectInvestScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.investmentPaymentScreen,
            page: () => InvestmentPaymentScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.projectDetailsScreen,
            page: () => ProjectDetailsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.projectPaymentSuccessScreen,
            page: () => ProjectPaymentSuccessScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.projectInvestmentHistoryScreen,
            page: () => ProjectInvestmentHistoryScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.planInvestScreen,
            page: () => PlanInvestScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.planinvestmentHistoryScreen,
            page: () => PlanInvestmentHistoryScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.deleteAccountScreen,
            page: () => DeleteAccountScreen(),
            transition: Transition.fade),

        //----------------ECOMMERCE-----------------
        GetPage(
            name: RoutesName.productScreen,
            page: () => ProductScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.productDetailsScreen,
            page: () => ProductDetailsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.myCartScreen,
            page: () => MyCartScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.wishlistScreen,
            page: () => WishlistScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.myOrdersScreen,
            page: () => MyOrdersScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.orderDetailsScreen,
            page: () => OrderDetailsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.checkoutScreen,
            page: () => CheckoutScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.productPaymentScreen,
            page: () => ProductPaymentScreen(),
            transition: Transition.fade),
      ];
}
