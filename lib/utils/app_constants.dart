class AppConstants {
  static const String appName = 'Amar Khamar';

  //BASE_URL
  static const String baseUrl = 'https://amarkhamar.asia';
  // static const String baseUrl = 'http://192.168.0.104/agriwealth';

  //END_POINTS_URL
  static const String _ = "/api"; // prefi
  static const String registerUrl = '$_/register';
  static const String loginUrl = '$_/login';
  static const String forgotPassUrl = '$_/recovery-pass/get-email';
  static const String forgotPassGetCodeUrl = '$_/recovery-pass/get-code';
  static const String updatePassUrl = '$_/update-pass';
  static const String languageUrl = '$_/languages';
  static const String profileUrl = '$_/profile';
  static const String profileUpdateUrl = '$_/update-profile';
  static const String profilePassUpdateUrl = '$_/change-password';
  static const String verificationUrl = '$_/kyc';
  static const String identityVerificationUrl = '$_/submit-kyc';
  static const String twoFaSecurityUrl = '$_/two-step-security';
  static const String twoFaSecurityEnableUrl = '$_/twoStep-enable';
  static const String twoFaSecurityDisableUrl = '$_/twoStep-disable';
  static const String twoFaVerifyUrl = '$_/twoFA-Verify';
  static const String mailUrl = '$_/mail-verify';
  static const String smsVerifyUrl = '$_/sms-verify';
  static const String resendCodeUrl = '$_/resend_code';

  static const String transactionUrl = '$_/transactions';

  //----support ticket
  static const String supportTicketListUrl = '$_/support-tickets';
  static const String supportTicketCreateUrl = '$_/support-ticket/store';
  static const String supportTicketReplyUrl = '$_/ticket-reply';
  static const String supportTicketViewUrl = '$_/ticket/view';
  static const String supportTicketCloseUrl = '$_/close-ticket';

  //-----withdraw (payout)
  static const String withdrawHistory = "$_/payout/history";
  static const String withdrawDetails = "$_/payout-details";
  static const String payoutUrl = "$_/payout-method";
  static const String payoutInitUrl = "$_/payout";
  static const String payoutRequestUrl = "$_/payout-request";
  static const String payoutSubmitUrl = "$_/confirm-payout";
  static const String getBankFromBankUrl = "$_/get-bank-form";
  static const String getBankFromCurrencyUrl = "$_/get-bank-list";
  static const String flutterwaveSubmitUrl = "$_/flutterwave-payout";
  static const String paystackSubmitUrl = "$_/paystack-payout";
  static const String payoutConfirmUrl = "$_/payout-confirm";

  //-----deposit (add fund)
  static const String depositHistoryUrl = "$_/deposit/history";
  static const String gatewaysUrl = "$_/gateways";
  static const String manualPaymentUrl = "$_/manual/payment/submit";
  static const String paymentRequest = "$_/deposit";
  static const String onPaymentDone = "$_/payment-done";
  static const String webviewPayment = "$_/payment-webview";
  static const String cardPayment = "$_/card/payment";

  static const String notificationSettingsUrl = "$_/notifications/template";
  static const String notificationPermissionUrl =
      "$_/update/notification-permission";
  static const String bonusList = "$_/referral-bonus/history";
  static const String referralList = "$_/referral-users";
  static const String getDirectReferUsers = "$_/get-direct/referral-users";

  //------plan
  static const String planHistory = "$_/plan/invest/history";
  static const String planInvestment = "$_/investment-plans";
  static const String planInvest = "$_/invest/plan";

  //------project
  static const String projectHistory = "$_/project/invest/history";
  static const String projectList = "$_/projects";
  static const String projectInvest = "$_/project/invest";

  // SAVE FCM
  static const String saveFcmToken = "$_/firebase-token/save";

  static const String deleteAccountUrl = "$_/delete-account";

  //-----------ECOMMERCE
  static const String productList = "$_/products";
  static const String productDetails = "$_/product/details";
  static const String addWishlist = "$_/add/to/wishlist";
  static const String wishlist = "$_/wishlist";
  static const String addRating = "$_/rating";
  static const String couponApply = "$_/coupon-apply";
  static const String orders = "$_/orders";
  static const String orderDetails = "$_/order/details";
  static const String areaList = "$_/area";
  static const String createOrder = "$_/order";
  static const String makeOrderPayment = "$_/order/make/payment";
}

//----------IMAGE DIRECTORY---------//
String rootImageDir = "assets/images";
String rootEcommerceDir = "assets/ecommerce";
String rootIconDir = "assets/icons";
String rootJsonDir = "assets/json";
