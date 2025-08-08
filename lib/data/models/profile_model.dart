class ProfileModel {
  Data? data;

  ProfileModel({
    this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Profile? profile;

  Data({
    this.profile,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
      );
}

class Profile {
  dynamic id;
  dynamic firstname;
  dynamic lastname;
  dynamic username;
  dynamic email;
  dynamic languageId;
  dynamic address;
  dynamic phone;
  dynamic phoneCode;
  dynamic country;
  dynamic countryCode;
  dynamic image;
  dynamic balance;
  dynamic profit_balance;
  dynamic base_currency;
  dynamic currency_symbol;
  dynamic created_at;
  dynamic ecommerce_status;

  Profile({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.languageId,
    this.address,
    this.phone,
    this.phoneCode,
    this.country,
    this.countryCode,
    this.image,
    this.balance,
    this.profit_balance,
    this.base_currency,
    this.currency_symbol,
    this.created_at,
    this.ecommerce_status,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        email: json["email"],
        languageId: json["language_id"],
        address: json["address"],
        phone: json["phone"],
        phoneCode: json["phone_code"],
        country: json["country"],
        countryCode: json["country_code"],
        image: json["image"],
        balance: json["balance"],
        profit_balance: json["profit_balance"],
        base_currency: json["base_currency"],
        currency_symbol: json["currency_symbol"],
        created_at: json["created_at"].toString(),
        ecommerce_status: json["ecommerce_status"],
      );
}
