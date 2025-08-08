

class DepositHistoryModel {
    List<Datum>? data;

    DepositHistoryModel({
        this.data,
    });

    factory DepositHistoryModel.fromJson(Map<String, dynamic> json) => DepositHistoryModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
}

class Datum {
    dynamic id;
    dynamic method;
    dynamic trxId;
    dynamic amount;
    dynamic status;
    dynamic createdAt;
    dynamic updatedAt;
    dynamic baseCurrency;
    dynamic currencySymbol;

    Datum({
        this.id,
        this.method,
        this.trxId,
        this.amount,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.baseCurrency,
        this.currencySymbol,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        method: json["method"],
        trxId: json["trx_id"],
        amount: json["amount"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        baseCurrency: json["base_currency"],
        currencySymbol: json["currency_symbol"],
    );

}
