class PayoutHistoryModel {
  Message? message;

  PayoutHistoryModel({this.message});

  PayoutHistoryModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  List<Payouts>? payouts;

  Message({this.payouts});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['Payout History'] != null) {
      payouts = <Payouts>[];
      json['Payout History'].forEach((v) {
        payouts!.add(new Payouts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.payouts != null) {
      data['Payout History'] = this.payouts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payouts {
  dynamic id;
  dynamic transactionId;
  dynamic amount;
  dynamic payoutCurrencyCode;
  dynamic status;
  dynamic createdAt;

  Payouts(
      {this.id,
      this.transactionId,
      this.amount,
      this.payoutCurrencyCode,
      this.status,
      this.createdAt});

  Payouts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transactionId'];
    amount = json['amount'];
    payoutCurrencyCode = json['payout_currency_code'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transactionId'] = this.transactionId;
    data['amount'] = this.amount;
    data['payout_currency_code'] = this.payoutCurrencyCode;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}
