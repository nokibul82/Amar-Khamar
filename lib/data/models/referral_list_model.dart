

class ReferralListModel {
    Data? data;

    ReferralListModel({
        this.data,
    });

    factory ReferralListModel.fromJson(Map<String, dynamic> json) => ReferralListModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );


}

class Data {
    List<ReferralUser>? referralUsers;

    Data({
        this.referralUsers,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        referralUsers: json["referral_users"] == null ? [] : List<ReferralUser>.from(json["referral_users"]!.map((x) => ReferralUser.fromJson(x))),
    );

}

class ReferralUser {
    dynamic id;
    dynamic firstname;
    dynamic lastname;
    dynamic username;
    dynamic email;
    dynamic phoneCode;
    dynamic phone;
    dynamic referralId;
    dynamic totalInvest;
    dynamic createdAt;
    dynamic lastSeenActivity;
    dynamic hasReferralUser;

    ReferralUser({
        this.id,
        this.firstname,
        this.lastname,
        this.username,
        this.email,
        this.phoneCode,
        this.phone,
        this.referralId,
        this.totalInvest,
        this.createdAt,
        this.lastSeenActivity,
        this.hasReferralUser,
    });

    factory ReferralUser.fromJson(Map<String, dynamic> json) => ReferralUser(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        email: json["email"],
        phoneCode: json["phone_code"],
        phone: json["phone"],
        referralId: json["referral_id"],
        totalInvest: json["total_invest"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        lastSeenActivity: json["last-seen-activity"],
        hasReferralUser: json["has_referral_user"] ?? false,
    );

}
