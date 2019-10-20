import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './new_category.dart';

import './providers/catgeory_provider.dart';
import './models/category.dart';
// import './models/category.dart';

class CategoryList extends StatefulWidget {
  static final routeUrl = '/categoryList';

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final defaultColor = Colors.pink[200];

  startAddNewCategory(ctx) {
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return AlertDialog(
            content: NewCategory(
              defaultColor: defaultColor,
              parentContext: ctx,
            ),
          );
        });
  }

  Color _getBackGroundColor(BuildContext context, String colorName) {
    return Provider.of<AppCategoryProvider>(context).getColorCode(colorName);
  }

  _removeCategory(BuildContext context, AppCategoryModel removedCategory) {
    Provider.of<AppCategoryProvider>(context).removeCategory(removedCategory);
  }

  startremoveCategoryDialog(ctx, removedCategory) {
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return AlertDialog(
            // title: Text('Remove Category' ),
            content: Text(
              'Are you sure about that ?',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  _removeCategory(ctx, removedCategory);
                  Navigator.of(context).pop();
                },
                textColor: Colors.red,
              )
            ],
          );
        });
  }

  // @override
  // void initState() {
  //   Future.delayed(Duration(seconds: 0), () {
  //     Provider.of<AppCategoryProvider>(context).init();
  //   });
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    // Provider.of<AppCategoryProvider>(context).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(builder: (_) => AppCategoryProvider()),
        ],
        child: Consumer<AppCategoryProvider>(
            builder: (context, appCategoryProvider, child) {
          var allCategories = appCategoryProvider.appCategories;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Categories',
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColorLight,
                    size: 30,
                  ),
                  onPressed: () {
                    startAddNewCategory(context);
                  },
                  // color: Colors.red,
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.only(
                top: 12,
              ),
              // width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: allCategories.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          // backgroundColor: Theme.of(context).primaryColor,
                          backgroundColor: _getBackGroundColor(
                              context, allCategories[index].color),
                          // foregroundColor: Theme.of(context).accentColor,
                          radius: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            allCategories[index].title,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            startremoveCategoryDialog(
                              context,
                              allCategories[index],
                            );
                          },
                          iconSize: 25,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }));
  }
}
