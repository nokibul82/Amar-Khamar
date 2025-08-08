import 'dart:async';
import 'dart:convert';
import 'deposit_controller.dart';
import 'profile_controller.dart';
import '../data/repositories/project_investment_repo.dart';
import '../utils/services/helpers.dart';
import '../../views/screens/investment_payment/investment_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/project_model.dart' as p;
import '../data/source/errors/check_status.dart';
import '../routes/routes_name.dart';

class ProjectController extends GetxController {
  static ProjectController get to => Get.find<ProjectController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TextEditingController amountCtrl = TextEditingController();

  List<p.Datum> projectList = [];
  String selectedWallet = ProfileController.to.walletList.isEmpty
      ? "Checkout"
      : "${ProfileController.to.walletList[0]}";
  int carouselIndex = 0;
  int increment = 1;

  Future getProjectInvestmentList() async {
    _isLoading = true;

    update();
    http.Response response = await ProjectRepo.getProjectList();

    _isLoading = false;
    projectList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        projectList = [...projectList, ...p.ProjectModel.fromJson(data).data!];

        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      projectList = [];
    }
  }

  // get the selected value from invest now button
  getSelectedVal(p.Datum data) {
    minInvestAmount = data.minimumInvest ?? "0.00";
    maxInvestAmount = data.maximumInvest ?? "0.00";
    fixedInvest = data.fixedInvest ?? "0.00";
    currency = data.baseCurrency.toString();
    currency_symbol = data.currencySymbol.toString();
    update();
  }

  bool isValidAmountRange = false;
  String minInvestAmount = "0.00";
  String maxInvestAmount = "0.00";
  String fixedInvest = "0.00";
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
      } else if (fixedInvest != "0.00") {
        if (amountCtrl.text.isNotEmpty) {
          if (double.parse(amountCtrl.text.toString()) !=
              double.parse(fixedInvest)) {
            isValidAmountRange = false;
          } else if (double.parse(amountCtrl.text.toString()) ==
              double.parse(fixedInvest)) {
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
  String unit = "";
  String projectId = "";
  Future onMakePaymentBtnClick(
      {required String projectId,
      required String unit,
      required BuildContext context}) async {
    try {
      if (minInvestAmount != "0.00" && maxInvestAmount != "0.00") {
        if (amountCtrl.text.isNotEmpty) {
          if (double.parse(amountCtrl.text.toString()) >=
                  double.parse(minInvestAmount) &&
              double.parse(amountCtrl.text.toString()) <=
                  double.parse(maxInvestAmount)) {
            //@to do
            await makePaymentProcess(
                projectId: projectId, unit: unit, context: context);
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
      } else if (fixedInvest != "0.00") {
        if (amountCtrl.text.isNotEmpty) {
          if (double.parse(amountCtrl.text.toString()) !=
              double.parse(fixedInvest)) {
            Helpers.showSnackBar(
                msg:
                    "Please Invest $currency_symbol${Helpers.numberFormat(fixedInvest)}");
          } else if (double.parse(amountCtrl.text.toString()) ==
              double.parse(fixedInvest)) {
            //@to do
            await makePaymentProcess(
                projectId: projectId, unit: unit, context: context);
          }
          update();
        }
      }
      update();
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  Future makePaymentProcess(
      {required String projectId,
      required String unit,
      required BuildContext context}) async {
    this.projectId = projectId.toString();
    this.unit = unit.toString();
    this.balanceType =
        await ProfileController.to.walletList.indexOf(selectedWallet) == 0
            ? "balance"
            : await ProfileController.to.walletList.indexOf(selectedWallet) == 1
                ? "profit"
                : "checkout";
    // if the balanceType is checkout
    if (balanceType == "checkout") {
      Get.to(() => InvestmentPaymentScreen(investmentType: "Project"));
    }
    // if the balanceType is other [balance, profit]
    else {
      await projectInvest(context: context, fields: {
        "balance_type": balanceType,
        "amount": amountCtrl.text,
        "project_id": projectId,
        "unit": unit,
      });
    }
  }

  //-------plan invest
  bool isPayment = false;
  Future projectInvest(
      {required Map<String, dynamic> fields,
      required BuildContext context}) async {
    isPayment = true;
    update();
    http.Response response = await ProjectRepo.projectInvest(fields: fields);
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

  //------if the balance type == "checkout"
  String amountInSelectedCurr = "0.00";
  String charge = "0.00";
  String payableAmount = "0.00";
  String exchRate = "0.00";
  String payableInBaseCurr = "0.00";
  calculateCheckoutAmount() {
    try {
      if (amountVal != null && amountVal != "") {
        amountInSelectedCurr =
            (double.parse(DepositController.to.conversion_rate) *
                    double.parse(amountVal))
                .toStringAsFixed(2);
        charge = DepositController.to.charge;
        payableAmount = (double.parse(DepositController.to.charge) +
                double.parse(amountInSelectedCurr))
            .toStringAsFixed(2);
        exchRate = DepositController.to.conversion_rate;
        payableInBaseCurr = ((double.parse(DepositController.to.charge) /
                    double.parse(DepositController.to.conversion_rate)) +
                double.parse(amountVal))
            .toStringAsFixed(2);
        DepositController.to.totalPayableAmountInBaseCurrency =
            payableInBaseCurr;
        DepositController.to.totalChargedAmount = payableAmount;
        DepositController.to.sendAmount = payableAmount;
        update();
      }
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
    getProjectInvestmentList();
  }

  @override
  void dispose() {
    super.dispose();
    projectList.clear();
  }
}
