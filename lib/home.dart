import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './providers/expenses_provider.dart';

import './category_list.dart';

import './expenses_list.dart';
import './empty_list.dart';

// models.
import './utilis/db.dart';
import './models/expenses.dart';
import './statistics.dart';
import './loading.dart';

class Home extends StatefulWidget {
  final _categories;
  final int tabIndex;

  final appBarHeight;
  final statusBarHeight = 24;

  Home(this.appBarHeight, this._categories, this.tabIndex);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Will keep it here for undo functionality.
  Expenses removedItem;

  void addNewExpenses(Expenses newItem) async {
    await DBProvider.db.newExpenses(newItem);
    // widget.reload();
  }

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
                              : (const EmptyList('Expenses list is empty !'));
                        } else {
                          return FutureBuilder(
                              future: appExpensesProvider.futureExpenses,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Loading();
                                } else {
                                  return (snapshot.data.length > 0)
                                      ? ExpensesList(snapshot.data)
                                      : (const EmptyList(
                                          'Expenses list is empty !'));
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
