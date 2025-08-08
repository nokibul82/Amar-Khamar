

class WithdrawDetailsModel {
    Data? data;

    WithdrawDetailsModel({
        this.data,
    });

    factory WithdrawDetailsModel.fromJson(Map<String, dynamic> json) => WithdrawDetailsModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

}

class Data {
    Payout? payout;
    Method? method;

    Data({
        this.payout,
        this.method,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        payout: json["payout"] == null ? null : Payout.fromJson(json["payout"]),
        method: json["method"] == null ? null : Method.fromJson(json["method"]),
    );

}

class Method {
    dynamic bankName;
    dynamic code;

    Method({
        this.bankName,
        this.code,
    });

    factory Method.fromJson(Map<String, dynamic> json) => Method(
        bankName: json["bank_name"],
        code: json["code"],
    );


}

class Payout {
    dynamic id;
    dynamic amount;
    dynamic charge;
    dynamic amountInBaseCurrency;
    dynamic chargeInBaseCurrency;
    dynamic netAmountInBaseCurrency;
    dynamic trxId;
    dynamic status;
    dynamic createdAt;
    dynamic payoutCurrencyCode;
    dynamic baseCurrency;
    dynamic currencySymbol;

    Payout({
        this.id,
        this.amount,
        this.charge,
        this.amountInBaseCurrency,
        this.chargeInBaseCurrency,
        this.netAmountInBaseCurrency,
        this.trxId,
        this.status,
        this.createdAt,
        this.payoutCurrencyCode,
        this.baseCurrency,
        this.currencySymbol,
    });

    factory Payout.fromJson(Map<String, dynamic> json) => Payout(
        id: json["id"],
        amount: json["amount"],
        charge: json["charge"]?.toDouble(),
        amountInBaseCurrency: json["amount_in_base_currency"]?.toDouble(),
        chargeInBaseCurrency: json["charge_in_base_currency"]?.toDouble(),
        netAmountInBaseCurrency: json["net_amount_in_base_currency"]?.toDouble(),
        trxId: json["trx_id"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        payoutCurrencyCode: json["payout_currency_code"],
        baseCurrency: json["base_currency"],
        currencySymbol: json["currency_symbol"],
    );
}
