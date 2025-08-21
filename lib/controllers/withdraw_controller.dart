import 'dart:convert';
import '../utils/services/localstorage/hive.dart';
import '../utils/services/localstorage/keys.dart';
import 'profile_controller.dart';
import 'withdraw_history_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/models/bank_from_bank_model.dart';
import '../data/models/bank_from_currency_model.dart' as currency;
import '../data/models/bank_from_bank_model.dart' as bank;
import '../data/models/payout_gateways_model.dart' as payout;
import '../data/models/withdraw_details_model.dart';
import '../data/repositories/withdraw_repo.dart';
import '../data/source/errors/check_status.dart';
import '../routes/page_index.dart';
import '../utils/services/helpers.dart';

class WithdrawController extends GetxController {
  static WithdrawController get to => Get.find<WithdrawController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  TextEditingController amountCtrl = TextEditingController();

  List<DynamicFieldModel> dynamicList = [];
  List<DynamicFieldModel> selectedDynamicList = [];
  List<payout.Datum> paymentGatewayList = [];
  List<String> flutterwaveTransferList = [];
  List<String> balanceList = [];
  String type = "";
  String selectedBalanceType = "";
  Future getPayouts() async {
    if(HiveHelp.read(Keys.token) != null){
      _isLoading = true;
      update();
      http.Response response = await WithdrawRepo.getPayouts();
      _isLoading = false;
      paymentGatewayList = [];
      dynamicList = [];
      balanceList = [];
      flutterwaveTransferList = [];
      update();

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          paymentGatewayList
              .addAll(payout.WithdrawGatewayModel.fromJson(data).data!);
          // balance tye
          balanceList = List.from(ProfileController.to.walletList)..removeAt(2);
          if (balanceList.isNotEmpty) type = balanceList[0];
          selectedBalanceType = "balance";
          // filter the dynamic field data
          List list = data['data'];
          for (var i in list) {
            if (i['inputForm'] != null && i['inputForm'] is Map) {
              // dynamic field
              Map<String, dynamic> dForm = i['inputForm'];
              dForm.forEach((key, value) {
                if (value['field_name'] != null &&
                    value['field_label'] != null) {
                  dynamicList.add(DynamicFieldModel(
                    name: i['name'],
                    fieldName: value['field_name'],
                    fieldLevel: value['field_label'],
                    type: value['type'],
                    validation: value['validation'],
                  ));
                }
              });
            }
            // if the payment gateway is flutterwave
            if (i['name'] == "Flutterwave") {
              if (i['bank_name'] != null && i['bank_name'] is Map) {
                Map<String, dynamic> dBankMap = i['bank_name'];
                dBankMap.entries.forEach((e) {
                  Map<String, dynamic> dNestedBankMap = e.value;
                  dNestedBankMap.entries.forEach((x) {
                    flutterwaveTransferList.add(x.value);
                  });
                });
              }
            }
          }

          update();
        } else {
          ApiStatus.checkStatus(data['status'], data['data']);
          update();
        }
      } else {
        Helpers.showSnackBar(msg: jsonDecode(response.body)['data']);

        update();
      }
    }
  }

  int selectedGatewayIndex = -1;
  List<payout.Datum> searchedGatewayItem = [];
  bool isGatewaySearching = false;
  TextEditingController gatewaySearchCtrl = TextEditingController();
  queryPaymentGateway(String v) {
    searchedGatewayItem = paymentGatewayList
        .where((payout.Datum e) =>
            e.name.toString().toLowerCase().contains(v.toLowerCase()))
        .toList();
    selectedGatewayIndex = -1;
    if (v.isEmpty) {
      isGatewaySearching = false;
      searchedGatewayItem.clear();
      update();
    } else if (v.isNotEmpty) {
      isGatewaySearching = true;
      update();
    }
    update();
  }

  int gatewayId = 0;
  String gatewayName = "";
  dynamic selectedCurrency = null;
  List<payout.PayoutCurrency> payoutCurrencyList = [];
  List<dynamic> supportedCurrencyList = [];
  getSelectedGatewayData(index) {
    var data = isGatewaySearching
        ? searchedGatewayItem[index]
        : paymentGatewayList[index];
    gatewayId = data.id;
    gatewayName = data.name;
    // get the selected payment gateway's currency for getting the min, max, charge
    payoutCurrencyList = [];
    if (data.payoutCurrencies != null) {
      payoutCurrencyList = data.payoutCurrencies!;
    }
    // get the supported currencies for displaying in the payout page
    supportedCurrencyList = [];
    selectedCurrency = null;
    if (data.supportedCurrency != null) {
      supportedCurrencyList = data.supportedCurrency!;
      selectedCurrency = supportedCurrencyList[0];
      if (gatewayName == "Paystack") {
        getBankFromCurrency(currencyCode: selectedCurrency);
      }
    }
    update();
  }

  // get the selected currency data
  String minAmount = "0.00";
  String maxAmount = "0.00";
  String charge = "0.00";
  String conversion_rate = "0.00";
  String percentage = "0";
  getSelectedCurrencyData(value) async {
    try {
      amountCtrl.clear();
      amountValue = "";
      var selectedCurr = await payoutCurrencyList.firstWhere((e) {
        return e.name == value || e.currencySymbol == value;
      });
      minAmount =
          double.parse(selectedCurr.minLimit.toString()).toStringAsFixed(2);
      maxAmount = selectedCurr.maxLimit.toString();
      charge = selectedCurr.fixedCharge.toString();
      conversion_rate = selectedCurr.conversionRate.toString();
      percentage = selectedCurr.percentageCharge.toString();
      calculateAmount();
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
    update();
  }

  // calculate amount
  String totalChargedAmount = "0.00";
  String totalPayoutAmountInBaseCurrency = "0.00";
  calculateAmount() {
    try {
      if (amountValue.isNotEmpty && selectedCurrency != null) {
        totalChargedAmount =
            (double.parse(amountValue.toString()) + double.parse(charge))
                .toStringAsFixed(2);
        totalPayoutAmountInBaseCurrency =
            ((double.parse(amountValue.toString())) /
                    double.parse(conversion_rate))
                .toStringAsFixed(2);
        update();
      }
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  String amountValue = "";
  bool isFollowedTransactionLimit = true;
  onChangedAmount(v) {
    try {
      amountValue = v.toString();
      if (v.toString().isNotEmpty) {
        if ((double.parse(v.toString()) >= double.parse(minAmount)) &&
            (double.parse(v.toString()) <= double.parse(maxAmount))) {
          isFollowedTransactionLimit = true;
        } else {
          isFollowedTransactionLimit = false;
        }
      }
      calculateAmount();
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getPayouts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //----------PAYOUT INIT---------//
  String trx_id = "";
  Future payoutInitUrl({required Map<String, String> fields}) async {
    isPayoutSubmitting = true;
    update();
    http.Response response = await WithdrawRepo.payoutInitUrl(fields: fields);
    isPayoutSubmitting = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        if (data['data'] != null && data['data']['trx_id'] != null)
          trx_id = data['data']['trx_id'].toString();
        if (gatewayName == "Flutterwave") {
          Get.to(() => FlutterWaveWithdrawScreen());
        } else {
          Get.to(() => WithdrawPreviewScreen());
        }

        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
        update();
      }
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  //----------PAYOUT DETAILS---------//
  int selectedPayoutConfirmIndex = -1;
  List<WithdrawDetailsModel> withdrawDetailsList = [];
  bool isConfimPayout = false;
  Future getWithdrawDetails({required String trxId, required int index}) async {
    isConfimPayout = true;
    selectedPayoutConfirmIndex = index;
    update();
    http.Response response =
        await WithdrawRepo.getWithdrawDetails(trxId: trxId);
    withdrawDetailsList = [];
    dynamicList = [];
    selectedDynamicList = [];
    flutterwaveTransferList = [];
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        if (data['data'] != null)
          withdrawDetailsList.add(WithdrawDetailsModel.fromJson(data));
        if (withdrawDetailsList.isNotEmpty) {
          var datas = withdrawDetailsList[0].data!.payout;
          // get data
          gatewayName =
              withdrawDetailsList[0].data!.method!.bankName.toString();
          selectedCurrency = datas!.payoutCurrencyCode.toString();
          amountValue = datas.amount.toString();
          charge = datas.charge.toString();
          totalChargedAmount = (double.parse(datas.amount.toString()) +
                  double.parse(datas.charge.toString()))
              .toStringAsFixed(2);
          totalPayoutAmountInBaseCurrency =
              datas.amountInBaseCurrency.toString();

          // get dynamic form data
          if (data['data']['method'] != null &&
              data['data']['method']['inputForm'] != null &&
              data['data']['method']['inputForm'] is Map) {
            Map<String, dynamic> dForm = data['data']['method']['inputForm'];
            dForm.forEach((key, value) {
              if (value['field_name'] != null && value['field_label'] != null) {
                dynamicList.add(DynamicFieldModel(
                  name: gatewayName,
                  fieldName: value['field_name'],
                  fieldLevel: value['field_label'],
                  type: value['type'],
                  validation: value['validation'],
                ));
              }
            });
          }
          selectedDynamicList =
              await dynamicList.where((e) => e.name == gatewayName).toList();
          await filterData();

          // if the payment gateway is flutterwave
          if (gatewayName == "Flutterwave") {
            if (data['data'] != null &&
                data['data']['method'] != null &&
                data['data']['method']['banks'] != null &&
                data['data']['method']['banks'] is List) {
              flutterwaveTransferList =
                  List.from(data['data']['method']['banks']);
            }
          }

          // if the payment gateway is paystack
          if (selectedCurrency != null) {
            if (gatewayName == "Paystack") {
              await getBankFromCurrency(currencyCode: selectedCurrency);
            }
          }
          isConfimPayout = false;
          update();

          if (gatewayName == "Flutterwave") {
            Get.to(() => FlutterWaveWithdrawScreen());
          } else {
            Get.to(() => WithdrawPreviewScreen());
          }
        }

        update();
      } else {
        isConfimPayout = false;
        ApiStatus.checkStatus(data['status'], data['data']);
        update();
      }
    } else {
      isConfimPayout = false;
      Helpers.showSnackBar(msg: '${data['data']}');
      update();
    }
  }

  //----------PAYOUT SUBMIT----------//
  bool isPayoutSubmitting = false;
  var selectedPaypalValue = null;
  Future submitPayout(
      {required Map<String, String> fields,
      required BuildContext context,
      required Iterable<http.MultipartFile>? fileList}) async {
    isPayoutSubmitting = true;
    update();
    try {
      http.Response response = await WithdrawRepo.payoutSubmit(
          trx_id: this.trx_id, fields: fields, fileList: fileList);
      isPayoutSubmitting = false;
      update();
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ApiStatus.checkStatus(data['status'], data['data']);
        if (data['status'] == 'success') {
          refreshDynamicData();
          WithdrawHistoryController.to
              .resetDataAfterSearching(isFromOnRefreshIndicator: true);
          WithdrawHistoryController.to.getWithdrawHistoryList(
              page: 1, transaction_id: '', start_date: '', end_date: '');
          Get.offAll(() => WithdrawHistoryScreen(isFromPayoutPage: true));
          update();
        } else {
          imagePickerResults.clear();
          fileMap.clear();
          update();
        }
      } else {
        Helpers.showSnackBar(msg: '${data['data']}');
      }
    } catch (e) {
      isPayoutSubmitting = false;
      Helpers.showSnackBar(msg: "$e");
      update();
    }
  }

  //------------FLUTTER WAVE---------//
  var flutterWaveSelectedTransfer = null;
  var flutterWaveSelectedBank = null;
  String flutterwaveSelectedBankNumber = "0";
  List<bank.Data> bankFromBankList = [];
  List<String> bankFromBankDynamicList = [];
  Map<String, TextEditingController> bankFromBanktextEditingControllerMap = {};
  Future getBankFromBank({required String bankName}) async {
    isBankLoading = true;
    update();
    http.Response response =
        await WithdrawRepo.getBankFromBank(bankName: bankName);
    bankFromBankList = [];
    bankFromBankDynamicList = [];
    bankFromBanktextEditingControllerMap = {};
    isBankLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        if (data['data']['bank'] != null &&
            data['data']['bank']['data'] != null) {
          bankFromBankList
              .addAll(BankFromBankModel.fromJson(data).message!.bank!.data!);
        }
        if (data['data']['input_form'] != null &&
            data['data']['input_form'] is Map) {
          Map<String, dynamic> map = data['data']['input_form'];
          map.forEach((key, value) {
            bankFromBankDynamicList.add(key);
            bankFromBanktextEditingControllerMap[key] = TextEditingController();
          });
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  Future submitFlutterwavePayout(
      {required Map<String, String> fields,
      required BuildContext context}) async {
    isPayoutSubmitting = true;
    update();
    http.Response response = await WithdrawRepo.flutterwaveSubmit(
        trx_id: this.trx_id, fields: fields);
    isPayoutSubmitting = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['data']);

      if (data['status'] == 'success') {
        refreshDynamicData();
        WithdrawHistoryController.to
            .resetDataAfterSearching(isFromOnRefreshIndicator: true);
        WithdrawHistoryController.to.getWithdrawHistoryList(
            page: 1, transaction_id: '', start_date: '', end_date: '');
        Get.offAll(() => WithdrawHistoryScreen(isFromPayoutPage: true));

        update();
      } else {
        imagePickerResults.clear();
        fileMap.clear();
        update();
      }
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  //------------PAYSTACK---------//
  var paystackSelectedBank = null;
  String paystackSelectedBankNumber = "0";
  String paystackSelectedType = "";
  List<currency.Data> bankFromCurrencyList = [];
  bool isBankLoading = false;
  Future getBankFromCurrency({required String currencyCode}) async {
    isBankLoading = true;
    update();
    http.Response response =
        await WithdrawRepo.getBankFromCurrency(currencyCode: currencyCode);
    bankFromCurrencyList = [];
    isBankLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        if (data['data']['data'] != null && data['data']['data'] is List) {
          bankFromCurrencyList.addAll(
              currency.BankFromCurrencyModel.fromJson(data).message!.data!);
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  Future submitPaystackPayout(
      {required Map<String, String> fields,
      required BuildContext context}) async {
    isPayoutSubmitting = true;
    update();
    http.Response response =
        await WithdrawRepo.paystackSubmit(trx_id: this.trx_id, fields: fields);
    isPayoutSubmitting = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['data']);
      if (data['status'] == 'success') {
        refreshDynamicData();
        WithdrawHistoryController.to
            .resetDataAfterSearching(isFromOnRefreshIndicator: true);
        WithdrawHistoryController.to.getWithdrawHistoryList(
            page: 1, transaction_id: '', start_date: '', end_date: '');
        Get.offAll(() => WithdrawHistoryScreen(isFromPayoutPage: true));
        update();
      } else {
        imagePickerResults.clear();
        fileMap.clear();
        update();
      }
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  //------------------let's manupulate the dynamic form data-----//
  Map<String, TextEditingController> textEditingControllerMap = {};
  List<DynamicFieldModel> fileType = [];
  List<DynamicFieldModel> requiredFile = [];
  List<String> requiredTypeFileList = [];

  Future filterData() async {
    // check if the field type is text or textArea
    var textType =
        await selectedDynamicList.where((e) => e.type != 'file').toList();

    for (var field in textType) {
      textEditingControllerMap[field.fieldName] = TextEditingController();
    }

    // check if the field type is file
    fileType =
        await selectedDynamicList.where((e) => e.type == 'file').toList();
    // listing the all required file
    requiredFile =
        await fileType.where((e) => e.validation == 'required').toList();
    // add the required file name in a seperate list for validation
    for (var file in requiredFile) {
      requiredTypeFileList.add(file.fieldName);
    }
  }

  Map<String, dynamic> dynamicData = {};
  List<String> imgPathList = [];

  Future renderDynamicFieldData() async {
    imgPathList.clear();
    textEditingControllerMap.forEach((key, controller) {
      dynamicData[key] = controller.text;
    });
    await Future.forEach(imagePickerResults.keys, (String key) async {
      String filePath = imagePickerResults[key]!.path;
      imgPathList.add(imagePickerResults[key]!.path);
      dynamicData[key] = await http.MultipartFile.fromPath("", filePath);
    });
  }

  final formKey = GlobalKey<FormState>();
  XFile? pickedFile;
  Map<String, http.MultipartFile> fileMap = {};
  Map<String, XFile?> imagePickerResults = {};
  Future<void> pickFile(String fieldName) async {
    final storageStatus = await Permission.camera.request();

    if (storageStatus.isGranted) {
      try {
        final picker = ImagePicker();
        final pickedImageFile =
            await picker.pickImage(source: ImageSource.camera);

        if (pickedImageFile != null) {
          imagePickerResults[fieldName] = pickedImageFile;
          final file = await http.MultipartFile.fromPath(
              fieldName, pickedImageFile.path);
          fileMap[fieldName] = file;

          if (requiredTypeFileList.contains(fieldName)) {
            requiredTypeFileList.remove(fieldName);
          }
          update();
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error while picking files: $e");
        }
      }
    } else {
      Helpers.showSnackBar(
          msg:
              "Please grant camera permission in app settings to use this feature.");
      await Future.delayed(Duration(seconds: 2));
      await openAppSettings();
    }
  }

  refreshDynamicData() {
    imagePickerResults.clear();
    dynamicData.clear();
    textEditingControllerMap.clear();
    fileType.clear();
    requiredFile.clear();
    requiredTypeFileList.clear();
    pickedFile = null;
    fileMap.clear();
  }
  //--------------------------------------------------//
}

class DynamicFieldModel {
  String name;
  dynamic fieldName;
  dynamic fieldLevel;
  dynamic type;
  dynamic validation;
  DynamicFieldModel(
      {required this.name,
      this.fieldName,
      this.fieldLevel,
      this.type,
      this.validation});
}

class OtherGatewayCurrencyModel {
  String gatewayName;
  String currency;
  OtherGatewayCurrencyModel(
      {required this.gatewayName, required this.currency});
}
