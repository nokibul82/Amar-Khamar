import 'addCart_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'keys.dart';

var storedLocalCartItem;
Future initHive() async {
  await Hive.initFlutter();
  final dir = await getApplicationDocumentsDirectory();
  Hive
    ..init(dir.path)
    ..registerAdapter(AddCartModelAdapter());
  storedLocalCartItem = await Hive.openBox<AddCartModel>(Keys.myCartData);
  await Hive.openBox(Keys.hiveinit);
}
