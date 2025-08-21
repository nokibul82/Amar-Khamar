import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/app_colors.dart';
import '../data/models/language_model.dart';
import '../data/models/profile_model.dart';
import '../data/repositories/profile_repo.dart';
import '../data/source/errors/check_status.dart';
import '../routes/routes_name.dart';
import '../utils/services/helpers.dart';
import '../utils/services/localstorage/hive.dart';
import '../utils/services/localstorage/keys.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find<ProfileController>();

  bool isLoading = false;

  // -----------------------edit profile--------------------------
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController lastNameEditingController = TextEditingController();
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController addressEditingController = TextEditingController();
  TextEditingController deleteEditingController = TextEditingController();

  Future validateEditProfile(context) async {
    if (firstNameEditingController.text.isEmpty) {
      Helpers.showSnackBar(msg: 'First Name is required');
    } else if (lastNameEditingController.text.isEmpty) {
      Helpers.showSnackBar(msg: 'Last Name is required');
    } else if (userNameEditingController.text.isEmpty) {
      Helpers.showSnackBar(msg: 'User Name is required');
    } else if (phoneNumberEditingController.text.isEmpty) {
      Helpers.showSnackBar(msg: 'Phone Nubmer is required');
    } else {
      await updateProfile(context);
    }
  }

  double percent = 0.72;
  String balance = "0.00";
  String profit_balance = "0.00";
  String base_currency = "";
  String currency_symbol = "";
  List<String> walletList = [];
  List<Profile> profileList = [];
  List<Language> languageList = [];
  String userId = '';
  String userPhoto = '';
  String userName = '';
  String join_date = '';
  String addressVerificationMsg = "";
  String selectedLanguage = "English";
  String selectedLanguageId = "1";
  bool isLanguageSelected = false;
  String userEmail = "";
  String countryCode = 'US';
  String phoneCode = '+1';
  String countryName = 'United States';
  Future getProfile() async {
    if (HiveHelp.read(Keys.token) != null) {
      isLoading = true;
      update();
      http.Response response = await ProfileRepo.getProfile();
      profileList.clear();
      languageList.clear();
      walletList.clear();
      isLoading = false;
      update();
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['status'] == 'success') {
          if (data['data']['profile'] != null &&
              data['data']['languages'] != null &&
              data['data']['languages'] is List) {
            List<Map<String, dynamic>> list =
                List.from(data['data']['languages']);

            for (int i = 0; i < list.length; i += 1) {
              languageList.add(Language(
                id: list[i]['id'].toString(),
                name: list[i]['name'].toString(),
                shortName: list[i]['short_name'].toString(),
              ));
            }
            String languageId = data['data']['profile']['language_id'] == null
                ? "1"
                : data['data']['profile']['language_id'].toString();
            var l = list.firstWhere(
              (e) => e['id'].toString() == languageId,
              orElse: () => {},
            );
            selectedLanguage = l['name'];
            update();
          }
          if (data['data']['profile'] != null)
            profileList.add(ProfileModel.fromJson(data).data!.profile!);
          if (profileList.isNotEmpty) {
            var data = profileList[0];
            _getInfo(data);
          }
        } else {
          ApiStatus.checkStatus(data['status'], data['data']);
        }
      } else {
        Helpers.showSnackBar(msg: '${data['data']}');
      }
    }
  }

  _getInfo(Profile? data) {
    userId = data == null ? '' : data.id.toString();
    userName = data == null ? '' : data.firstname! + " " + data.lastname!;
    userEmail = data == null ? '' : data.email ?? '';
    userPhoto = data == null ? '' : data.image;
    firstNameEditingController.text = data == null ? '' : data.firstname ?? "";
    lastNameEditingController.text = data == null ? '' : data.lastname ?? "";
    userNameEditingController.text = data == null ? '' : data.username ?? "";
    emailEditingController.text = data == null ? '' : data.email ?? "";
    phoneNumberEditingController.text = data == null ? '' : data.phone ?? "";
    addressEditingController.text = data == null ? '' : data.address ?? "";
    selectedLanguageId = data == null
        ? "1"
        : data.languageId == null
            ? "1"
            : data.languageId.toString();
    phoneCode = data == null ? "" : data.phoneCode;
    countryName = data == null ? "" : data.country;
    countryCode = data == null ? "" : data.countryCode;
    join_date = data == null ? '' : data.created_at ?? "";
    // reset value
    percent = 0.72;
    if (!userPhoto.contains("default")) {
      percent += 0.14;
      update();
    }
    if (addressEditingController.text.isNotEmpty) {
      percent += 0.14;
      update();
    }
    balance =
        data == null || data.balance == null ? "0.00" : data.balance.toString();
    profit_balance = data == null || data.profit_balance == null
        ? "0.00"
        : data.profit_balance.toString();
    base_currency = data == null ? "" : data.base_currency.toString();
    currency_symbol = data == null ? "" : data.currency_symbol.toString();
    HiveHelp.write(Keys.baseCurrency, base_currency);
    HiveHelp.write(Keys.currencySymbol, currency_symbol);
    HiveHelp.write(Keys.userEmail, userEmail);
    HiveHelp.write(Keys.userFullName,
        firstNameEditingController.text + " " + lastNameEditingController.text);
    HiveHelp.write(Keys.ecommerceStatus,
        data == null ? false : data.ecommerce_status ?? false);
    HiveHelp.write(Keys.UNIQUE_ID, join_date);
    HiveHelp.write(Keys.userPhone, phoneNumberEditingController.text);
    HiveHelp.write(Keys.userId, data == null ? "1" : data.id.toString());
    walletList = [
      "Wallet Balance - ${Helpers.numberFormatWithAsFixed2(currency_symbol, balance)}",
      "Profit Balance - ${Helpers.numberFormatWithAsFixed2(currency_symbol, profit_balance)}",
      "Checkout",
    ];
  }

  bool isUpdateProfile = false;
  Future updateProfile(context) async {
    isUpdateProfile = true;
    update();
    http.Response response = await ProfileRepo.profileUpdate(data: {
      "firstname": firstNameEditingController.text,
      "lastname": lastNameEditingController.text,
      "username": userNameEditingController.text,
      "email": emailEditingController.text,
      "phone": phoneNumberEditingController.text,
      "language": selectedLanguageId,
      "address": addressEditingController.text,
      "phone_code": phoneCode,
      "country": countryName,
      "country_code": countryCode,
    });
    isUpdateProfile = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['data']);
      if (data['status'] == 'success') {
        getProfile();
        Navigator.of(context).pop();
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  XFile? pickedImage;
  Future<void> pickImage(ImageSource source) async {
    final checkPermission = await Permission.camera.request();
    if (checkPermission.isGranted) {
      final picker = ImagePicker();
      final pickedImageFile = await picker.pickImage(source: source);
      final File imageFile = File(pickedImageFile!.path);
      final int fileSizeInBytes = await imageFile.length();
      final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      pickedImage = pickedImageFile;
      if (pickedImage != null) {
        if (fileSizeInMB >= 4) {
          Helpers.showSnackBar(
              msg: "Image size exceeds 4 MB. Please choose a smaller image.");
        } else {
          await ProfileController.to
              .updateProfilePhoto(filePath: pickedImage!.path);
        }
      }
      update();
    } else {
      Helpers.showSnackBar(
          msg:
              "Please grant camera permission in app settings to use this feature.");
      await Future.delayed(Duration(seconds: 2));
      await openAppSettings();
    }
  }

  bool isUploadingPhoto = false;
  Future updateProfilePhoto({required String filePath}) async {
    isUploadingPhoto = true;
    update();
    http.Response response = await ProfileRepo.profileImageUpload(fields: {
      "firstname": firstNameEditingController.text,
      "lastname": lastNameEditingController.text,
      "username": userNameEditingController.text,
      "email": emailEditingController.text,
      "phone": phoneNumberEditingController.text,
      "language": selectedLanguageId,
      "phone_code": phoneCode,
      "country": countryName,
      "country_code": countryCode,
    }, files: await http.MultipartFile.fromPath('image', filePath));
    isUploadingPhoto = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['data']);
      if (data['status'] == 'success') {
        await getProfile();
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  //--------------------------change password--------------------------
  TextEditingController currentPassEditingController = TextEditingController();
  TextEditingController newPassEditingController = TextEditingController();
  TextEditingController confirmEditingController = TextEditingController();

  RxString currentPassVal = "".obs;
  RxString newPassVal = "".obs;
  RxString confirmPassVal = "".obs;

  bool currentPassShow = true;
  bool isNewPassShow = true;
  bool isConfirmPassShow = true;

  currentPassObscure() {
    currentPassShow = !currentPassShow;
    update();
  }

  newPassObscure() {
    isNewPassShow = !isNewPassShow;
    update();
  }

  confirmPassObscure() {
    isConfirmPassShow = !isConfirmPassShow;
    update();
  }

  void validateUpdatePass(context) async {
    if (newPassVal.value != confirmPassVal.value) {
      Helpers.showSnackBar(
          msg: "New Password and Confirm Password didn't match!");
    } else {
      await updateProfilePass(context);
    }
  }

  clearChangePasswordVal() {
    currentPassEditingController.clear();
    newPassEditingController.clear();
    confirmEditingController.clear();
    currentPassVal.value = '';
    newPassVal.value = '';
    confirmPassVal.value = '';
  }

  Future updateProfilePass(context) async {
    isLoading = true;
    update();
    http.Response response = await ProfileRepo.profilePassUpdate(data: {
      "current_password": currentPassVal.value,
      "password": newPassVal.value,
      "password_confirmation": confirmPassVal.value,
    });
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['data']);
      if (data['status'] == 'success') {
        clearChangePasswordVal();
        Navigator.of(context).pop();

        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  bool isDeleteAccount = false;
  Color deleteFieldColor = AppColors.sliderInActiveColor;
  Future deleteAccount() async {
    isDeleteAccount = true;
    update();
    http.Response response = await ProfileRepo.deleteAccount();
    isDeleteAccount = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        HiveHelp.cleanall();
        deleteFieldColor = AppColors.sliderInActiveColor;
        deleteEditingController.clear();
        Get.offAllNamed(RoutesName.loginScreen);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }
}
