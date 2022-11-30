import 'package:flutter/material.dart';

import '../model/shopping_model.dart';
import '../model/shopping_model_repository.dart';

class ShoppingItemForm extends StatefulWidget {
  final ShoppingModelRepository _repository;

  late final ShoppingModel? _element;

  ShoppingItemForm(this._repository, ShoppingModel? element, {super.key}) {
    _element = element;
  }

  @override
  State<ShoppingItemForm> createState() => ShoppingItemFormState();
}

class ShoppingItemFormState extends State<ShoppingItemForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _costController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget._element?.name ?? '',
    );
    _costController = TextEditingController(
      text: widget._element?.cost.toString() ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _getAppBarTitle()),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validateName,
                decoration: const InputDecoration(
                  labelText: 'Название товара',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _costController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validateCost,
                decoration: const InputDecoration(
                  labelText: 'Стоимость',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: _getButtonTitle(),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitFormData();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _getAppBarTitle() {
    if (_isEditing()) {
      return const Text('Изменение товара');
    }

    return const Text('Добавление нового товара');
  }

  bool _isEditing() {
    return widget._element != null;
  }

  String? _validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Поле не должно быть пустым';
    }

    return null;
  }

  String? _validateCost(String? costText) {
    if (costText == null || costText.trim().isEmpty) {
      return 'Поле не должно быть пустым';
    }

    double? cost = double.tryParse(costText);
    if (cost == null) {
      return 'Стоимость введена некорректно';
    }

    if (cost < 0) {
      return 'Стоимость должна быть больше нуля';
    }

    return null;
  }

  Text _getButtonTitle() {
    if (_isEditing()) {
      return const Text('Изменить');
    } else {
      return const Text('Добавить');
    }
  }

  void _submitFormData() {
    String name = _nameController.text.trim();
    double cost = double.parse(_costController.text.trim());
    if (_isEditing()) {
      widget._repository.update(widget._element!, name, cost);
    } else {
      widget._repository.create(name, cost);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    super.dispose();
  }
}
