class TransactionModel {
  Data? data;

  TransactionModel({
    this.data,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  List<Datum>? data;

  Data({
    this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  dynamic id;
  dynamic amount;
  dynamic charge;
  dynamic trxType;
  dynamic trxId;
  dynamic remarks;
  dynamic createdAt;
  dynamic base_currency;
  dynamic currency_symbol;

  Datum({
    this.id,
    this.amount,
    this.charge,
    this.trxType,
    this.trxId,
    this.remarks,
    this.createdAt,
    this.base_currency,
    this.currency_symbol,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        amount: json["amount"].toString(),
        charge: json["charge"].toString(),
        trxType: json["trx_type"],
        trxId: json["trx_id"],
        remarks: json["remarks"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        base_currency: json["base_currency"],
        currency_symbol: json["currency_symbol"],
      );
}
