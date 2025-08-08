import 'dart:async';
import 'dart:convert';
import 'profile_controller.dart';
import 'project_controller.dart';
import '../data/repositories/plan_investment_repo.dart';
import '../utils/services/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/plan_investment_model.dart' as p;
import '../data/source/errors/check_status.dart';
import '../routes/routes_name.dart';
import '../views/screens/investment_payment/investment_payment_screen.dart';
import 'deposit_controller.dart';

class PlanController extends GetxController {
  static PlanController get to => Get.find<PlanController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TextEditingController amountCtrl = TextEditingController();

  List<p.Datum> planList = [];
  String selectedWallet = ProfileController.to.walletList.isEmpty
      ? "0.00"
      : "${ProfileController.to.walletList[0]}";

  Future getPlanInvestmentList() async {
    _isLoading = true;

    update();
    http.Response response = await PlanHistoryRepo.getPlanInvestmentList();

    _isLoading = false;
    planList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        planList = [...planList, ...p.PlanInvestmentModel.fromJson(data).data!];

        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      planList = [];
    }
  }

  // get the selected value from invest now button
  getSelectedVal(p.Datum data) {
    minInvestAmount = data.minInvest.toString();
    maxInvestAmount = data.maxInvest.toString();
    planPrice = data.planPrice.toString();
    currency = data.baseCurrency.toString();
    currency_symbol = data.currencySymbol.toString();
    update();
  }

  bool isValidAmountRange = false;
  String minInvestAmount = "0.00";
  String maxInvestAmount = "0.00";
  String planPrice = "0.00";
  String currency = "";
  String currency_symbol = "";
  dynamic amountVal = "";
  onAmountChange(v) {
    try {
      amountVal = v;
      if (minInvestAmount != "0.00" && maxInvestAmount != "0.00") {
        if (amountCtrl.text.isNotEmpty) {
          if (double.parse(amountCtrl.text.toString()) >=
                  double.parse(minInvestAmount) &&
              double.parse(amountCtrl.text.toString()) <=
                  double.parse(maxInvestAmount)) {
            isValidAmountRange = true;
          } else {
            isValidAmountRange = false;
          }
          update();
        }
      } else if (planPrice != "0.00") {
        if (amountCtrl.text.isNotEmpty) {
          if (double.parse(amountCtrl.text.toString()) !=
              double.parse(planPrice)) {
            isValidAmountRange = false;
          } else if (double.parse(amountCtrl.text.toString()) ==
              double.parse(planPrice)) {
            isValidAmountRange = true;
          }
          update();
        }
      }
      update();
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  String balanceType = "";
  String plannId = "";
  Future onMakePaymentBtnClick(
      {required String planId, required BuildContext context}) async {
    try {
      if (minInvestAmount != "0.00" && maxInvestAmount != "0.00") {
        if (amountCtrl.text.isNotEmpty) {
          if (double.parse(amountCtrl.text.toString()) >=
                  double.parse(minInvestAmount) &&
              double.parse(amountCtrl.text.toString()) <=
                  double.parse(maxInvestAmount)) {
            //@to do
            this.plannId = planId.toString();
            this.balanceType =
                await ProfileController.to.walletList.indexOf(selectedWallet) ==
                        0
                    ? "balance"
                    : await ProfileController.to.walletList
                                .indexOf(selectedWallet) ==
                            1
                        ? "profit"
                        : "checkout";
            if (balanceType == "checkout") {
              ProjectController.to.amountVal = amountCtrl.text;
              Get.to(() => InvestmentPaymentScreen(investmentType: "Plan"));
            } else {
              await planInvest(context: context, fields: {
                "balance_type": balanceType,
                "amount": amountCtrl.text,
                "plan_id": planId,
              });
            }
          } else {
            if (double.parse(amountCtrl.text.toString()) <
                double.parse(minInvestAmount)) {
              Helpers.showSnackBar(
                  msg:
                      "Minimum Invest Limit $currency_symbol${Helpers.numberFormat(minInvestAmount)}");
            } else if (double.parse(amountCtrl.text.toString()) >
                double.parse(maxInvestAmount)) {
              Helpers.showSnackBar(
                  msg:
                      "Maximum Invest Limit $currency_symbol${Helpers.numberFormat(maxInvestAmount)}");
            }
          }
          update();
        }
      } else if (planPrice != "0.00") {
        if (amountCtrl.text.isNotEmpty) {
          if (double.parse(amountCtrl.text.toString()) !=
              double.parse(planPrice)) {
            Helpers.showSnackBar(
                msg:
                    "Please Invest $currency_symbol${Helpers.numberFormat(planPrice)}");
          } else if (double.parse(amountCtrl.text.toString()) ==
              double.parse(planPrice)) {
            //@to do
            this.plannId = planId.toString();
            this.balanceType =
                await ProfileController.to.walletList.indexOf(selectedWallet) ==
                        0
                    ? "balance"
                    : await ProfileController.to.walletList
                                .indexOf(selectedWallet) ==
                            1
                        ? "profit"
                        : "checkout";
            // if the balanceType is checkout
            if (balanceType == "checkout") {
              ProjectController.to.amountVal = amountCtrl.text;
              Get.to(() => InvestmentPaymentScreen(investmentType: "Plan"));
            } else {
              await planInvest(context: context, fields: {
                "balance_type": balanceType,
                "amount": amountCtrl.text,
                "plan_id": planId,
              });
            }
          }
          update();
        }
      }
      update();
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  // plan invest
  bool isPayment = false;
  Future planInvest(
      {required Map<String, dynamic> fields,
      required BuildContext context}) async {
    isPayment = true;
    update();
    http.Response response = await PlanHistoryRepo.PlanInvest(fields: fields);
    isPayment = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (balanceType != "checkout") {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
      if (data['status'] == 'success') {
        if (balanceType != "checkout") {
          Get.toNamed(RoutesName.projectPaymentSuccessScreen);
        } else if (balanceType == "checkout") {
          DepositController.to.trxId = data['data']['trx_id'].toString();
          await DepositController.to.onBuyNowTapped(context: context);
        }
      }
    } else {
      Helpers.showSnackBar(msg: "Something went wrong!");
    }
  }

  @override
  void onInit() {
    super.onInit();
    getPlanInvestmentList();
  }

  @override
  void dispose() {
    super.dispose();
    planList.clear();
  }
}
