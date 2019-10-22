import 'package:expenses/models/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/catgeory_provider.dart';
import './providers/filters_provider.dart';
import './providers/expenses_provider.dart';

import './models/fliters.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<CustomDrawer> {
  bool isFirstTime = true;
  // Inputs controller.
  // Form Key.
  final _formKey = GlobalKey<FormState>();
  final months = List<int>.generate(12, (int index) {
    return index + 1;
  });

  AppFilters filters;

  initstate() {
    Future.delayed(Duration(milliseconds: 0), () {
      // Get the persistent values.
      filters = Provider.of<AppFiltersProvider>(context).appFilters;
    });
    super.initState();
  }

  applyFilters(BuildContext context) async {
    final isValid = _formKey.currentState.validate();
    // print('isValid: $isValid');
    if (isValid) {
      // print('here');
      _formKey.currentState.save();
      // editedExpenses.log();

      // Update providers.
      await Provider.of<AppFiltersProvider>(context).updateFilters(filters);
      await Provider.of<AppExpensesProvider>(context).filterExpenses(filters);

      // Close drawer.
      Navigator.of(context).pop();
    }
  }

  resetFilters(BuildContext context) async {
    filters = AppFilters();
    // editedExpenses.log();

    // Update providers.
    await Provider.of<AppFiltersProvider>(context).updateFilters(filters);
    await Provider.of<AppExpensesProvider>(context).filterExpenses(filters);

    // Close drawer.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Just for the first time.
    // Work around.
    if (isFirstTime) {
      filters = Provider.of<AppFiltersProvider>(context).appFilters;
      isFirstTime = false;
    }
    return Consumer<AppCategoryProvider>(
        builder: (context, appCategoryProvider, child) {
      var allCategories = appCategoryProvider.appCategories;
      return Container(
        child: Form(
          key: _formKey,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 100,
                child: DrawerHeader(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 22,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
              ),
              Card(
                elevation: 10,
                margin: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 10,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Filter By Category'),
                      DropdownButtonFormField(
                        onSaved: (value) {},
                        onChanged: (_newValue) {
                          setState(() {
                            filters.category = _newValue;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: (filters.category == null)
                              ? 'Category'
                              : filters.category,
                        ),
                        items: (allCategories).map((AppCategoryModel item) {
                          return DropdownMenuItem<String>(
                            value: item.title,
                            child: Text(item.title),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 10,
                ),
                elevation: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Filter By Month Number'),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value == '') {
                            return null;
                          }
                          var parsedValue = int.parse(value);
                          if (parsedValue < 1 || parsedValue > 12) {
                            return 'Month Number is not valid!';
                          }

                          return null;
                        },
                        onSaved: (value) {},
                        onChanged: (_newValue) {
                          // print('_newValue:$_newValue');
                          setState(() {
                            filters.month =
                                (_newValue == '') ? null : int.parse(_newValue);
                            // print('filters.month:${filters.month}');
                          });
                        },
                        decoration: InputDecoration(
                          hintText: (filters.month == null)
                              ? 'Month'
                              : filters.month.toString(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        resetFilters(context);
                      },
                    ),
                    RaisedButton(
                      color: Theme.of(context).backgroundColor,
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        applyFilters(context);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
