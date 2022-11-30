import 'package:hive_flutter/hive_flutter.dart';

import 'shopping_model.dart';

class ShoppingModelRepository {
  final _box = Hive.box<ShoppingModel>('shopping');

  ShoppingModel? get(String key) {
    return _box.get(key);
  }

  List<ShoppingModel> getAll() {
    return _box.values.toList();
  }

  void create(String name, double cost) {
    _box.add(ShoppingModel(
      name: name,
      cost: cost,
      dateCreated: DateTime.now(),
    ));
  }

  void update(ShoppingModel element, String name, double cost) {
    element.name = name;
    element.cost = cost;
    element.save();
  }

  void delete(ShoppingModel element) {
    element.delete();
  }
}
