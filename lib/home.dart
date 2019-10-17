import 'package:flutter/material.dart';

// import './switch.dart';
import './expenses_list.dart';
import './empty_list.dart';

// models.
import './utilis/db.dart';
import './models/expenses.dart';
import './statistics.dart';

class Home extends StatefulWidget {
  final List<Expenses> listItems;
  final Function reload;
  final _categories;
  final int tabIndex;

  final appBarHeight;
  final statusBarHeight = 24;

  Home(this.appBarHeight, this.listItems, this.reload, this._categories,
      this.tabIndex);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool showStatistics = false;

  void addNewExpenses(Expenses newItem) async {
    // if (newItem.title && newItem.amount && newItem.category && newItem.date) {
    // widget.listItems.add(newItem);
    await DBProvider.db.newExpenses(newItem);
    widget.reload();
    // }
  }

  void removeExpenses(var id) async {
    setState(() {
      widget.listItems.removeWhere((item) => item.id == id);
    });

    await DBProvider.db.deleteExpenses(id);
    widget.reload();

    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Item removed")));
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
                  child: Statistics(widget.listItems, widget._categories),
                )
              : Container(
                  height: properHeight,
                  child: (widget.listItems.length > 0)
                      ? ExpensesList(widget.listItems, removeExpenses)
                      : EmptyList(),
                ))
        ],
      ),
    );
  }
}
