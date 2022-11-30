import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/shopping_model.dart';
import 'view/shopping_view.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ShoppingModelAdapter());

  await Hive.openBox<ShoppingModel>('shopping');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShoppingItemsView(),
    );
  }
}
