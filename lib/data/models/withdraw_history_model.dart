class WithdrawHistoryModel {
  String? status;
  List<Datum>? data;

  WithdrawHistoryModel({
    this.status,
    this.data,
  });

  factory WithdrawHistoryModel.fromJson(Map<String, dynamic> json) =>
      WithdrawHistoryModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  dynamic id;
  dynamic amount;
  dynamic trxId;
  dynamic status;
  dynamic createdAt;
  dynamic baseCurrency;
  dynamic currencySymbol;

  Datum({
    this.id,
    this.amount,
    this.trxId,
    this.status,
    this.createdAt,
    this.baseCurrency,
    this.currencySymbol,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        amount: json["amount"].toString(),
        trxId: json["trx_id"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        baseCurrency: json["base_currency"],
        currencySymbol: json["currency_symbol"],
      );
}
