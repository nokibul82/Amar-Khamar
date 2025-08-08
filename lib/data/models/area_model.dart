class AreaModel {
  List<Datum>? data;

  AreaModel({
    this.data,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  dynamic id;
  dynamic areaName;
  dynamic postCode;
  dynamic createdAt;
  dynamic updatedAt;
  List<ShippingCharge>? shippingCharge;

  Datum({
    this.id,
    this.areaName,
    this.postCode,
    this.createdAt,
    this.updatedAt,
    this.shippingCharge,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        areaName: json["area_name"],
        postCode: json["post_code"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        shippingCharge: json["shipping_charge"] == null
            ? []
            : List<ShippingCharge>.from(json["shipping_charge"]!
                .map((x) => ShippingCharge.fromJson(x))),
      );
}

class ShippingCharge {
  dynamic id;
  dynamic areaId;
  dynamic orderFrom;
  dynamic orderTo;
  dynamic deliveryCharge;
  dynamic createdAt;
  dynamic updatedAt;

  ShippingCharge({
    this.id,
    this.areaId,
    this.orderFrom,
    this.orderTo,
    this.deliveryCharge,
    this.createdAt,
    this.updatedAt,
  });

  factory ShippingCharge.fromJson(Map<String, dynamic> json) => ShippingCharge(
        id: json["id"],
        areaId: json["area_id"],
        orderFrom: json["order_from"],
        orderTo: json["order_to"],
        deliveryCharge: json["delivery_charge"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
