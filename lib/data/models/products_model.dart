class ProductsModel {
  Data? data;

  ProductsModel({
    this.data,
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  List<Category>? categories;
  List<Product>? products;

  Data({
    this.categories,
    this.products,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x))),
      );
}

class Category {
  dynamic id;
  dynamic name;
  dynamic slug;
  dynamic categoryImage;

  Category({
    this.id,
    this.name,
    this.slug,
    this.categoryImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        categoryImage: json["image"],
      );
}

class Product {
  dynamic id;
  dynamic categoryId;
  dynamic subcategoryId;
  dynamic price;
  dynamic thumbnailImage;
  dynamic quantity;
  dynamic quantityUnit;
  dynamic avgRating;
  dynamic createdAt;
  dynamic updatedAt;
  Details? details;
  bool? wishlist;
  List<Review>? reviews;

  Product({
    this.id,
    this.categoryId,
    this.subcategoryId,
    this.price,
    this.thumbnailImage,
    this.quantity,
    this.quantityUnit,
    this.avgRating,
    this.createdAt,
    this.updatedAt,
    this.details,
    this.wishlist,
    this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        price: json["price"],
        thumbnailImage: json["thumbnail_image"],
        quantity: json["quantity"],
        quantityUnit: json["quantity_unit"],
        avgRating: json["avg_rating"]?.toDouble(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        details:
            json["details"] == null ? null : Details.fromJson(json["details"]),
        wishlist: json["wishlist"],
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(
                json["reviews"]!.map((x) => Review.fromJson(x))),
      );
}

class Details {
  dynamic id;
  dynamic productId;
  dynamic title;
  dynamic shortDescription;
  dynamic description;

  Details({
    this.id,
    this.productId,
    this.title,
    this.shortDescription,
    this.description,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        id: json["id"],
        productId: json["product_id"],
        title: json["title"],
        shortDescription: json["short_description"],
        description: json["description"],
      );
}

class Review {
  dynamic id;
  dynamic productId;
  dynamic rating;
  dynamic comment;
  User? user;
  dynamic createdAt;

  Review({
    this.id,
    this.productId,
    this.rating,
    this.comment,
    this.user,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        productId: json["product_id"],
        rating: json["rating"],
        comment: json["comment"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );
}

class User {
  dynamic name;
  dynamic image;
  dynamic username;

  User({
    this.name,
    this.image,
    this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        image: json["image"],
        username: json["username"],
      );
}
