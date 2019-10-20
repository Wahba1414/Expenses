import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// import 'package:intl/intl.dart';
// import 'package:uuid/uuid.dart';
import './providers/catgeory_provider.dart';

import './models/category.dart';

class NewCategory extends StatefulWidget {
  final title;
  final color;
  final defaultColor;
  final parentContext;

  NewCategory({this.title, this.color, this.defaultColor, this.parentContext});

  // NewCategory();

  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  // Form Key.
  final _formKey = GlobalKey<FormState>();

  FocusNode _titleFocus = FocusNode();

  // Object holds all data of the new transaction.
  AppCategoryModel editedCategory = AppCategoryModel();

  _submit() async {
    final isValid = _formKey.currentState.validate();
    // print('isValid: $isValid');
    if (isValid) {
      // print('here');
      _formKey.currentState.save();

      // Add to Provider data.
      Provider.of<AppCategoryProvider>(widget.parentContext, listen: false)
          .addNewCategory(editedCategory);

      // close this modal.
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    // Clean up.
    _titleFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 5,
      ),
      child: Container(
        height: 200,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Title.
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Name is empty!';
                  }
                  return null;
                },
                onSaved: (value) {
                  editedCategory.title = value;
                },
                decoration: InputDecoration(
                  labelText: 'New Category Name',
                ),
                focusNode: _titleFocus,
                textInputAction: TextInputAction.done,
              ),
              // Submit
              RaisedButton(
                child: Text('Add'),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
