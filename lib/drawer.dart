import 'package:expenses/models/category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:month_picker_dialog/month_picker_dialog.dart';

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

  chooseMonth(BuildContext context) {
    showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 10, 1),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      setState(() {
        if (pickedDate != null) {
          filters.month = pickedDate.month;
          filters.year = pickedDate.year;
        }
      });
    });
  }

  applyFilters(BuildContext context) async {
    final isValid = _formKey.currentState.validate();
    // print('isValid: $isValid');
    if (isValid) {
      // print('here');
      _formKey.currentState.save();
      // editedExpenses.log();

      // Update providers.
      var updatedFilters =
          await Provider.of<AppFiltersProvider>(context).updateFilters(filters);
      await Provider.of<AppExpensesProvider>(context)
          .filterExpenses(updatedFilters);

      // Close drawer.
      Navigator.of(context).pop();
    }
  }

  resetFilters(BuildContext context) async {
    filters = AppFilters();
    // editedExpenses.log();

    // Update providers.
    var updatedFilters =
        await Provider.of<AppFiltersProvider>(context).updateFilters(filters);

    await Provider.of<AppExpensesProvider>(context)
        .filterExpenses(updatedFilters);

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

      // Add 'Uncategorized' catgeory here.
      allCategories.add(AppCategoryModel(title: 'Uncategorized'));

      return Container(
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return ListView(
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
                        Text(
                          'Filter By Category',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth * .85,
                          child: DropdownButtonFormField(
                            onSaved: (value) {},
                            onChanged: (_newValue) {
                              setState(() {
                                filters.category = _newValue;
                              });
                            },
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                              ),
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
                        Text(
                          'Filter By Month',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        // Use month library.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              (filters.month == null)
                                  ? 'No Month Selected'
                                  : '${DateFormat.yMMM().format(DateTime(filters.year, filters.month))}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 15,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.date_range),
                              onPressed: () {
                                chooseMonth(context);
                              },
                            ),
                          ],
                        )
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
                            fontSize: 16,
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
                            fontSize: 16,
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
            );
          }),
        ),
      );
    });
  }
}
