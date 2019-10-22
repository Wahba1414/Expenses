import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import './models/expenses.dart';
import './models/expenses_arguments.dart';

class NewExpensesForm extends StatefulWidget {
  static const routeUrl = '/newExpenses';

  // final selectDate;
  // final _categories;
  // final addNewExpenses;

  NewExpensesForm();

  // NewExpensesForm();

  @override
  _NewExpensesFormState createState() => _NewExpensesFormState();
}

class _NewExpensesFormState extends State<NewExpensesForm> {
  // route args.
  ExpensesArguments args;

  // Form Key.
  final _formKey = GlobalKey<FormState>();

  // Object holds all data of the new transaction.
  Expenses editedExpenses = Expenses(date: DateTime.now());

  // Focus Nodes.
  FocusNode _titleFoucs = FocusNode();
  FocusNode _amountFoucs = FocusNode();
  FocusNode _categoryFocus = FocusNode();

  _handleAsyncDatePicker() {
    args.selectDate().then((pickedDate) {
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
      args.addNewExpenses(editedExpenses).then((isSucceeded) {
        if (isSucceeded) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () {});
    super.initState();
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
    args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('New Expenses',
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
            )),
      ),
      body: Container(
        // margin:
        //     EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
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
                      // validator: (value) {
                      //   if (value == null) {
                      //     return 'Category is empty!';
                      //   }
                      //   return null;
                      // },
                      onSaved: (value) {
                        editedExpenses.category = value ?? 'Uncategorized';
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
                      items:
                          (args.categories as List<String>).map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    // Mode.

                    DropdownButtonFormField(
                      onSaved: (value) {
                        editedExpenses.mood = value ?? 'Okay';
                      },
                      onChanged: (_newValue) {
                        setState(() {
                          editedExpenses.mood = _newValue;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: (editedExpenses.mood == null)
                            ? 'Mood'
                            : editedExpenses.mood,
                      ),
                      items: (['Okay', 'Sad']).map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),

                    // Date
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Date: '),
                        Text((editedExpenses.date == null)
                            ? 'No date is chosen'
                            : (DateFormat.yMMMMd()
                                .format(editedExpenses.date))),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: _handleAsyncDatePicker,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              // Submit
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 50,
                      child: RaisedButton(
                        child: Text(
                          'Add',
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColorLight),
                        ),
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
