
class PlanHistoryModel {
    List<Datum>? data;

    PlanHistoryModel({
        this.data,
    });

    factory PlanHistoryModel.fromJson(Map<String, dynamic> json) => PlanHistoryModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );


}

class Datum {
    dynamic id;
    dynamic planName;
    dynamic profit;
    dynamic returnPeriod;
    dynamic totalReturn;
    dynamic nextReturn;
    dynamic formatNextReturnDate;
    dynamic baseCurrency;
    dynamic currencySymbol;

    Datum({
        this.id,
        this.planName,
        this.profit,
        this.returnPeriod,
        this.totalReturn,
        this.nextReturn,
        this.formatNextReturnDate,
        this.baseCurrency,
        this.currencySymbol,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        planName: json["plan_name"],
        profit: json["profit"],
        returnPeriod: json["return_period"],
        totalReturn: json["total_return"],
        nextReturn: json["next_return"] == null ? null : DateTime.parse(json["next_return"]),
        formatNextReturnDate: json["format_next_return_date"],
        baseCurrency: json["base_currency"],
        currencySymbol: json["currency_symbol"],
    );

}
