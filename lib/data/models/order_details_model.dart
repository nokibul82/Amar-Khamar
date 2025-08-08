

class OrderDetialsModel {
    Data? data;

    OrderDetialsModel({
        this.data,
    });

    factory OrderDetialsModel.fromJson(Map<String, dynamic> json) => OrderDetialsModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
}

class Data {
    List<OrderItem>? orderItems;

    Data({
        this.orderItems,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        orderItems: json["order_items"] == null ? [] : List<OrderItem>.from(json["order_items"]!.map((x) => OrderItem.fromJson(x))),
    );

}

class OrderItem {
    dynamic productImage;
    dynamic title;
    dynamic price;
    dynamic  quantity;
    dynamic  subtotal;

    OrderItem({
        this.productImage,
        this.title,
        this.price,
        this.quantity,
        this.subtotal,
    });

    factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productImage: json["product_image"],
        title: json["title"],
        price: json["price"],
        quantity: json["quantity"],
        subtotal: json["subtotal"],
    );
}
