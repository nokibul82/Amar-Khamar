class PlanInvestmentModel {
  List<Datum>? data;

  PlanInvestmentModel({
    this.data,
  });

  factory PlanInvestmentModel.fromJson(Map<String, dynamic> json) =>
      PlanInvestmentModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  dynamic id;
  dynamic planName;
  dynamic planPrice;
  dynamic planPeriod;
  dynamic planPeriodType;
  dynamic minInvest;
  dynamic maxInvest;
  dynamic returnTypHasLifetime;
  dynamic amountHasFixed;
  dynamic returnPeriod;
  dynamic returnPeriodType;
  dynamic unlimitedPeriod;
  dynamic numberOfProfitReturn;
  dynamic profit;
  dynamic profitType;
  dynamic capitalBack;
  dynamic maturity;
  dynamic status;
  dynamic image;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic baseCurrency;
  dynamic currencySymbol;

  Datum({
    this.id,
    this.planName,
    this.planPrice,
    this.planPeriod,
    this.planPeriodType,
    this.minInvest,
    this.maxInvest,
    this.returnTypHasLifetime,
    this.amountHasFixed,
    this.returnPeriod,
    this.returnPeriodType,
    this.unlimitedPeriod,
    this.numberOfProfitReturn,
    this.profit,
    this.profitType,
    this.capitalBack,
    this.maturity,
    this.status,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.baseCurrency,
    this.currencySymbol,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        planName: json["plan_name"] ?? "",
        planPrice: json["plan_price"] ?? "0.00",
        planPeriod: json["plan_period"],
        planPeriodType: json["plan_period_type"],
        minInvest: json["min_invest"] ?? "0.00",
        maxInvest: json["max_invest"] ?? "0.00",
        returnTypHasLifetime: json["return_typ_has_lifetime"],
        amountHasFixed: json["amount_has_fixed"],
        returnPeriod: json["return_period"],
        returnPeriodType: json["return_period_type"],
        unlimitedPeriod: json["unlimited_period"],
        numberOfProfitReturn: json["number_of_profit_return"] ?? "",
        profit: json["profit"] ?? "0.00",
        profitType: json["profit_type"],
        capitalBack: json["capital_back"] ?? "",
        maturity: json["maturity"] ?? "",
        status: json["status"],
        image: json["image"] ?? "",
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        baseCurrency: json["base_currency"] ??   "",
        currencySymbol: json["currency_symbol"] ??   "",
      );
}
