

class WishListModel {
    Data? data;

    WishListModel({
        this.data,
    });

    factory WishListModel.fromJson(Map<String, dynamic> json) => WishListModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

}

class Data {
    List<Datum>? data;

    Data({
        this.data,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

}

class Datum {
    dynamic id;
    dynamic productId;
    dynamic productImage;
    dynamic productName;
    dynamic price;
    dynamic avgRating;

    Datum({
        this.id,
        this.productId,
        this.productImage,
        this.productName,
        this.price,
        this.avgRating,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        productId: json["product_id"],
        productImage: json["product_image"],
        productName: json["product_name"],
        price: json["price"] ?? "0.00",
        avgRating: json["avg_rating"]?.toDouble(),
    );
}
