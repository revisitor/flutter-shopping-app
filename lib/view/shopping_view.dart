import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../model/shopping_model.dart';
import '../model/shopping_model_repository.dart';
import 'shopping_form.dart';

class ShoppingItemsView extends StatefulWidget {
  const ShoppingItemsView({super.key});

  @override
  State<ShoppingItemsView> createState() => _ShoppingItemsViewState();
}

class _ShoppingItemsViewState extends State<ShoppingItemsView> {
  final _repository = ShoppingModelRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список покупок'),
      ),
      body: ValueListenableBuilder<Box<ShoppingModel>>(
        valueListenable: Hive.box<ShoppingModel>('shopping').listenable(),
        builder: (context, box, _) {
          var items = _repository.getAll();
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return InkWell(
                child: _ShoppingItem(item),
                onTap: () => _showEditView(context, item),
                onLongPress: () => _deleteElement(item),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateView(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditView(BuildContext context, ShoppingModel element) {
    var route = MaterialPageRoute(
      builder: (context) => ShoppingItemForm(_repository, element),
    );

    Navigator.of(context).push(route);
  }

  void _showCreateView(BuildContext context) {
    var route = MaterialPageRoute(
      builder: (context) => ShoppingItemForm(_repository, null),
    );

    Navigator.of(context).push(route);
  }

  void _deleteElement(ShoppingModel item) {
    _repository.delete(item);
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}

class _ShoppingItem extends StatelessWidget {
  static final _dateFormatter = DateFormat('dd-MM-yyyy - HH:mm');

  final ShoppingModel _entity;

  const _ShoppingItem(this._entity);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        '${_entity.cost.toStringAsFixed(2)} ₽',
        style: const TextStyle(
            color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
      ),
      title: Text(_entity.name),
      subtitle: Text(_dateFormatter.format(_entity.dateCreated)),
    );
  }
}
