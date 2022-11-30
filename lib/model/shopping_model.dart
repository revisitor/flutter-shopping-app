import 'package:hive/hive.dart';

part 'shopping_model.g.dart';

@HiveType(typeId: 0)
class ShoppingModel extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late final DateTime dateCreated;

  @HiveField(2)
  late double cost;

  ShoppingModel({
    required this.name,
    required this.dateCreated,
    required this.cost,
  });
}
