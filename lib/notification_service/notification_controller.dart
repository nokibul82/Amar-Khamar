import 'dart:convert';
import 'dart:math';
import 'notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/repositories/fcm_repo.dart';
import '../routes/routes_name.dart';
import '../utils/services/helpers.dart';
import '../utils/services/localstorage/hive.dart';
import '../utils/services/localstorage/keys.dart';
import 'package:http/http.dart' as http;

class FcmController extends GetxController {
  RxBool isSeen = true.obs;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // save device token to the server
  Future saveFcmToken({required String fcm_token}) async {
    _isLoading = true;
    update();
    http.Response response = await FcmRepo.saveFcmToken(fcm_token: fcm_token);
    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        update();
      } else {
        Helpers.showSnackBar(msg: data['data']);
      }
    } else {
      Helpers.showSnackBar(msg: jsonDecode(response.body)['data']);
    }
  }

  getPushNotificationData(RemoteMessage message) async {
    LocalNotificationService().showNotification(
      id: Random().nextInt(99),
      title: message.notification!.title.toString(),
      body: message.notification!.body
          .toString()
          .replaceAll("\n", "")
          .replaceAll("\r", ""),
      payLoad: message.data.toString(),
    );

    String formattedDate = DateFormat.yMMMMd().add_jm().format(DateTime.now());
    String UNIQUE_ID = await HiveHelp.read(Keys.UNIQUE_ID);
    var storedData = await HiveHelp.read(UNIQUE_ID);
    List<Map<dynamic, dynamic>> notificationList =
        storedData != null ? List<Map<dynamic, dynamic>>.from(storedData) : [];

    notificationList.insert(0, {
      "text": message.notification!.body
          .toString()
          .replaceAll("\n", "")
          .replaceAll("\r", ""),
      "date": formattedDate,
    });
    String UNIQUEID = await HiveHelp.read(Keys.UNIQUE_ID);
    HiveHelp.write(UNIQUEID, notificationList);
    HiveHelp.write(Keys.isNotificationSeen, false);
    isSeen.value = HiveHelp.read(Keys.isNotificationSeen);
  }

  firebaseNotification() {
    // get fcm instance
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    // request for permission
    firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    firebaseMessaging.getInitialMessage().then(
      (message) {
        if (message != null) {
          if (message.notification != null) {
            Get.toNamed(RoutesName.notificationScreen);
            getPushNotificationData(message);
          }
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        if (message.notification != null) {
          getPushNotificationData(message);
          update();
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        if (message.notification != null) {
          Get.toNamed(RoutesName.notificationScreen);
          getPushNotificationData(message);
        }
      },
    );
  }

  // if the user notification seen or not
  isNotiSeen() {
    HiveHelp.write(Keys.isNotificationSeen, true);
    isSeen.value = HiveHelp.read(Keys.isNotificationSeen);
    Get.toNamed(RoutesName.notificationScreen);
    update();
  }
}
