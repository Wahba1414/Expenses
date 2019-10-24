import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './providers/expenses_provider.dart';

// import './switch.dart';
import './category_list.dart';

import './expenses_list.dart';
import './empty_list.dart';

// models.
import './utilis/db.dart';
import './models/expenses.dart';
import './statistics.dart';
import './loading.dart';

class Home extends StatefulWidget {
  final Function reload;
  final _categories;
  final int tabIndex;

  final appBarHeight;
  final statusBarHeight = 24;

  Home(this.appBarHeight, this.reload, this._categories, this.tabIndex);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Will keep it here for undo functionality.
  Expenses removedItem;

  void addNewExpenses(Expenses newItem) async {
    // if (newItem.title && newItem.amount && newItem.category && newItem.date) {
    // widget.listItems.add(newItem);
    await DBProvider.db.newExpenses(newItem);
    widget.reload();
    // }
  }

  // void removeExpenses(var id) async {
  //   // Get the removed item.
  //   removedItem = widget.listItems.firstWhere((item) => item.id == id);

  //   setState(() {
  //     widget.listItems.removeWhere((item) => item.id == id);
  //   });

  //   await DBProvider.db.deleteExpenses(id);
  //   widget.reload();

  //   // Assure remove any previous snakbars.
  //   Scaffold.of(context).removeCurrentSnackBar();

  //   // Show a new one.
  //   Scaffold.of(context).showSnackBar(SnackBar(
  //     duration: Duration(
  //       seconds: 5,
  //     ),
  //     backgroundColor: Theme.of(context).backgroundColor,
  //     content: Text("Item removed"),
  //     action: SnackBarAction(
  //       label: 'Undo',
  //       textColor: Theme.of(context).primaryColorLight,
  //       onPressed: () {
  //         addNewExpenses(removedItem);
  //       },
  //     ),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    double properHeight = (MediaQuery.of(context).size.height -
        widget.appBarHeight -
        widget.statusBarHeight);

    return Container(
      height: properHeight,
      child: Column(
        children: <Widget>[
          ((widget.tabIndex == 1)
              ? Container(
                  height: properHeight,
                  child: Consumer<AppExpensesProvider>(
                      builder: (context, appExpensesProvider, child) {
                    var expensesList = appExpensesProvider.expenses;
                    return Statistics(
                        expensesList, [...widget._categories, 'Uncategorized']);
                  }),
                )
              : ((widget.tabIndex == 0)
                  ? Container(
                      height: properHeight,
                      child: (Consumer<AppExpensesProvider>(
                          builder: (context, appExpensesProvider, child) {
                        var expensesList = appExpensesProvider.expenses;
                        if (expensesList.length > 0) {
                          return (expensesList.length > 0)
                              ? ExpensesList(expensesList)
                              : EmptyList('No transactions added yet!');
                        } else {
                          return FutureBuilder(
                              future: appExpensesProvider.futureExpenses,
                              builder: (context, snapshot) {
                                // print('snapshot.connectionState:${snapshot.connectionState}');
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Loading();
                                } else {
                                  return (snapshot.data.length > 0)
                                      ? ExpensesList(snapshot.data)
                                      : EmptyList('No transactions added yet!');
                                }
                              });
                        }
                      })),
                    )
                  : Container(height: properHeight, child: CategoryList())))
        ],
      ),
    );
  }
}
