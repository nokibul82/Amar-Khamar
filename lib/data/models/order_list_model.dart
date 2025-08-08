
class OrderListModel {
    List<Datum>? data;

    OrderListModel({
        this.data,
    });

    factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

}

class Datum {
    dynamic id;
    dynamic orderNumber;
    dynamic total;
    dynamic orderStatus;
    dynamic date;

    Datum({
        this.id,
        this.orderNumber,
        this.total,
        this.orderStatus,
        this.date,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        orderNumber: json["order_number"],
        total: json["total"],
        orderStatus: json["order_status"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
    );


}
