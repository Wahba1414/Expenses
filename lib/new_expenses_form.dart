import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import './models/expenses.dart';

class NewExpensesForm extends StatefulWidget {
  final selectDate;
  final _categories;
  final addNewExpenses;

  NewExpensesForm(this.selectDate, this._categories, this.addNewExpenses);

  // NewExpensesForm();

  @override
  _NewExpensesFormState createState() => _NewExpensesFormState();
}

class _NewExpensesFormState extends State<NewExpensesForm> {
  // Form Key.
  final _formKey = GlobalKey<FormState>();

  // Object holds all data of the new transaction.
  Expenses editedExpenses = Expenses(date: DateTime.now());

  // Focus Nodes.
  FocusNode _titleFoucs = FocusNode();
  FocusNode _amountFoucs = FocusNode();
  FocusNode _categoryFocus = FocusNode();

  _handleAsyncDatePicker() {
    widget.selectDate().then((pickedDate) {
      // print('pickedDate');
      // print(pickedDate);
      setState(() {
        if (pickedDate != null) {
          editedExpenses.date = pickedDate;
        }
      });
    });
  }

  _submit() {
    final isValid = _formKey.currentState.validate();
    // print('isValid: $isValid');
    if (isValid) {
      // print('here');
      _formKey.currentState.save();
      // editedExpenses.log();
      editedExpenses.id = new Uuid().v1();
      widget.addNewExpenses(editedExpenses).then((isSucceeded) {
        if (isSucceeded) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  void dispose() {
    // Clear resources.
    _titleFoucs.dispose();
    _amountFoucs.dispose();

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
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Title.
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Title is empty!';
                  }
                  return null;
                },
                onSaved: (value) {
                  editedExpenses.title = value;
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                focusNode: _titleFoucs,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_amountFoucs);
                },
              ),
              // Amount
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Amount is empty!';
                  }
                  return null;
                },
                onSaved: (value) {
                  editedExpenses.amount = value;
                },
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                focusNode: _amountFoucs,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_categoryFocus);
                },
              ),
              // Category
              DropdownButtonFormField(
                validator: (value) {
                  if (value == null) {
                    return 'Category is empty!';
                  }
                  return null;
                },
                onSaved: (value) {
                  editedExpenses.category = value;
                },
                onChanged: (_newValue) {
                  print('_newvalue');
                  print(_newValue);
                  setState(() {
                    editedExpenses.category = _newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: (editedExpenses.category == null)
                      ? 'Category'
                      : editedExpenses.category,
                ),
                items: (widget._categories as List<String>).map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              // Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text((editedExpenses.date == null)
                      ? 'No date is chosen'
                      : (DateFormat.yMMMMd().format(editedExpenses.date))),
                  FlatButton(
                    child: Text('Pick up a date'),
                    onPressed: _handleAsyncDatePicker,
                  )
                ],
              ),

              // Submit
              RaisedButton(
                child: Text('Add'),
                onPressed: _submit,
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
