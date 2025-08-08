import 'package:flutter/material.dart';
import '../../../controllers/deposit_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../routes/page_index.dart';
import '../../../controllers/product_manage_controller.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/init_hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_payment_fail.dart';
import '../../widgets/app_payment_success.dart';
import '../../widgets/custom_appbar.dart';

class CheckoutWebView extends StatefulWidget {
  final String? url;

  const CheckoutWebView({super.key, this.url = ""});

  @override
  _CheckoutWebViewState createState() => _CheckoutWebViewState();
}

class _CheckoutWebViewState extends State<CheckoutWebView> {
  bool isLoading = true;
  late var controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            if (url.toString().contains('success')) {
              // if user payment from ecommerce section
              if (ProductManageController.to.selectedPaymentMethod ==
                      "checkout" &&
                  ProductManageController.to.orderId != "-1") {
                storedLocalCartItem.clear();
              }
              Get.dialog(AppPaymentSuccess());
            }
            if (url.toString().contains('failed')) {
              Get.toNamed(RoutesName.mainDrawerScreen);
              Get.dialog(AppPaymentFail());
            }
            // WebView loading is complete, set isLoading to false
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print("WebView error: $error");
            Helpers.showSnackBar(msg: error.toString());
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('${widget.url}'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<DepositController>(builder: (shopCategoryCtrl) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          onBackPressed: () {
            Navigator.pop(context);
          },
          title: storedLanguage['Payment Preview'] ?? "Payment Preview",
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (isLoading)
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator()),
              )
          ],
        ),
      );
    });
  }
}
