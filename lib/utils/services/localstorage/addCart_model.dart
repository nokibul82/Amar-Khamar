import 'package:hive/hive.dart';
part 'addCart_model.g.dart';

@HiveType(typeId: 1)
class AddCartModel extends HiveObject {
  @HiveField(0)
  final  int id;
  @HiveField(1)
  final String img;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String avgRating;
  @HiveField(4)
  final String price;
  @HiveField(5)
  final String quantityUnit;
  @HiveField(6)
  late final int quantity;
  AddCartModel({
    required this.id,
    required this.img,
    required this.title,
    required this.avgRating,
    required this.price,
    required this.quantityUnit,
    required this.quantity,
  });
  AddCartModel copyWith({
    int? id,
    String? img,
    String? title,
    String? avgRating,
    String? price,
    String? quantityUnit,
    int? quantity,
  }) {
    return AddCartModel(
      id: id ?? this.id,
      img: img ?? this.img,
      title: title ?? this.title,
      avgRating: avgRating ?? this.avgRating,
      price: price ?? this.price,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      quantity: quantity ?? this.quantity,
    );
  }
  
}
