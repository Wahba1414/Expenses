import 'package:expenses/models/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/catgeory_provider.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<CustomDrawer> {
  // Inputs controller.
  // Form Key.
  final _formKey = GlobalKey<FormState>();
  final months = List<int>.generate(12, (int index) {
    return index + 1;
  });

  String selectedCategory;
  String selectedMonth;

  @override
  Widget build(BuildContext context) {
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
                            selectedCategory = _newValue;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: (selectedCategory == null)
                              ? 'Category'
                              : selectedCategory,
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
                          var parsedValue = int.parse(value);
                          if (parsedValue < 1 || parsedValue > 12) {
                            return 'Month Number is not valid!';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                        onChanged: (_newValue) {
                          setState(() {
                            selectedMonth = _newValue;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: (selectedMonth == null)
                              ? 'Month'
                              : selectedMonth.toString(),
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
                child: RaisedButton(
                  color: Theme.of(context).backgroundColor,
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
