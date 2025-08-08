

class ReferralBonusModel {
    Data? data;

    ReferralBonusModel({
        this.data,
    });

    factory ReferralBonusModel.fromJson(Map<String, dynamic> json) => ReferralBonusModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

}

class Data {
    Referrals? referrals;

    Data({
        this.referrals,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        referrals: json["referrals"] == null ? null : Referrals.fromJson(json["referrals"]),
    );


}

class Referrals {
    List<Datum>? data;

    Referrals({
        this.data,
    });

    factory Referrals.fromJson(Map<String, dynamic> json) => Referrals(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

}

class Datum {
    dynamic id;
    dynamic fromUserId;
    dynamic toUserId;
    dynamic level;
    dynamic amount;
    dynamic commissionType;
    dynamic trxId;
    dynamic remarks;
    dynamic createdAt;
    dynamic updatedAt;
    User? user;

    Datum({
        this.id,
        this.fromUserId,
        this.toUserId,
        this.level,
        this.amount,
        this.commissionType,
        this.trxId,
        this.remarks,
        this.createdAt,
        this.updatedAt,
        this.user,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        fromUserId: json["from_user_id"],
        toUserId: json["to_user_id"],
        level: json["level"],
        amount: json["amount"].toString(),
        commissionType: json["commission_type"],
        trxId: json["trx_id"],
        remarks: json["remarks"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );


}

class User {
    dynamic id;
    dynamic username;
    dynamic firstname;
    dynamic lastname;
    dynamic image;
    dynamic imageDriver;
    dynamic lastSeenActivity;

    User({
        this.id,
        this.username,
        this.firstname,
        this.lastname,
        this.image,
        this.imageDriver,
        this.lastSeenActivity,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        image: json["image"],
        imageDriver: json["image_driver"],
        lastSeenActivity: json["last-seen-activity"],
    );

}
