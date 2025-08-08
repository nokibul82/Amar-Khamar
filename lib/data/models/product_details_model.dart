import 'products_model.dart' as p;

class ProductModel {
  p.Product? data;

  ProductModel({
    this.data,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        data: json["data"] == null ? null : p.Product.fromJson(json["data"]),
      );
}
