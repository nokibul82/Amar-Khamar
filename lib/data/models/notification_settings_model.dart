

class NotificationSettingsModel {
    Message? message;

    NotificationSettingsModel({
        this.message,
    });

    factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) => NotificationSettingsModel(
        message: json["data"] == null ? null : Message.fromJson(json["data"]),
    );
}

class Message {
    List<Notification>? notification;
    UserHasPermission? userHasPermission;

    Message({
        this.notification,
        this.userHasPermission,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        notification: json["templates"] == null ? [] : List<Notification>.from(json["templates"]!.map((x) => Notification.fromJson(x))),
        userHasPermission: json["user_permission"] == null ? null : UserHasPermission.fromJson(json["user_permission"]),
    );

  
}

class Notification {
    dynamic id;
    dynamic name;
    dynamic key;
    Status? status;

    Notification({
        this.id,
        this.name,
        this.key,
        this.status,
    });

    factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json["id"],
        name: json["name"],
        key: json["template_key"],
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
    );

 
}

class Status {
    dynamic mail;
    dynamic sms;
    dynamic inApp;
    dynamic push;

    Status({
        this.mail,
        this.sms,
        this.inApp,
        this.push,
    });

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        mail: json["mail"],
        sms: json["sms"],
        inApp: json["in_app"],
        push: json["push"],
    );

}

class UserHasPermission {
    List<dynamic>? templateEmailKey;
    List<dynamic>? templateSmsKey;
    List<dynamic>? templateInAppKey;
    List<dynamic>? templatePushKey;

    UserHasPermission({
        this.templateEmailKey,
        this.templateSmsKey,
        this.templateInAppKey,
        this.templatePushKey,
    });

    factory UserHasPermission.fromJson(Map<String, dynamic> json) => UserHasPermission(
        templateEmailKey: json["template_email_key"] == null ? [] : List<String>.from(json["template_email_key"]!.map((x) => x)),
        templateSmsKey: json["template_sms_key"] == null ? [] : List<String>.from(json["template_sms_key"]!.map((x) => x)),
        templateInAppKey: json["template_in_app_key"] == null ? [] : List<String>.from(json["template_in_app_key"]!.map((x) => x)),
        templatePushKey: json["template_push_key"] == null ? [] : List<String>.from(json["template_push_key"]!.map((x) => x)),
    );

 
}
