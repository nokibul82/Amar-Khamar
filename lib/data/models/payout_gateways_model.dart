class WithdrawGatewayModel {
  List<Datum>? data;

  WithdrawGatewayModel({
    this.data,
  });

  factory WithdrawGatewayModel.fromJson(Map<String, dynamic> json) =>
      WithdrawGatewayModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  dynamic id;
  dynamic name;
  dynamic code;
  dynamic description;
  List<dynamic>? supportedCurrency;
  List<PayoutCurrency>? payoutCurrencies;
  dynamic currencyType;
  dynamic logo;

  Datum({
    this.id,
    this.name,
    this.code,
    this.description,
    this.supportedCurrency,
    this.payoutCurrencies,
    this.currencyType,
    this.logo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        description: json["description"],
        supportedCurrency: json["supported_currency"] == null
            ? []
            : List<String>.from(json["supported_currency"]!.map((x) => x)),
        payoutCurrencies: json["payout_currencies"] == null
            ? []
            : List<PayoutCurrency>.from(json["payout_currencies"]!
                .map((x) => PayoutCurrency.fromJson(x))),
        currencyType: json["currency_type"],
        logo: json["logo"],
      );
}

class PayoutCurrency {
  dynamic currencySymbol;
  dynamic name;
  dynamic conversionRate;
  dynamic minLimit;
  dynamic maxLimit;
  dynamic percentageCharge;
  dynamic fixedCharge;

  PayoutCurrency({
    this.currencySymbol,
    this.name,
    this.conversionRate,
    this.minLimit,
    this.maxLimit,
    this.percentageCharge,
    this.fixedCharge,
  });

  factory PayoutCurrency.fromJson(Map<String, dynamic> json) => PayoutCurrency(
        currencySymbol: json["currency_symbol"],
        name: json["name"],
        conversionRate: json["conversion_rate"],
        minLimit: json["min_limit"],
        maxLimit: json["max_limit"],
        percentageCharge: json["percentage_charge"],
        fixedCharge: json["fixed_charge"],
      );
}
