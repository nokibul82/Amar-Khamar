class AddRating {
  String? productId;
  String? rating;
  String? massage;
  String? email;
  String? name;
  AddRating({
    this.productId,
    this.rating,
    this.massage,
    this.email,
    this.name,
  });
  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "rating": rating,
        "massage": massage,
        "email": email,
        "name": name,
      };
}
