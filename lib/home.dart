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
  // Will keep it here for undo functionality.
  Expenses removedItem;

  void addNewExpenses(Expenses newItem) async {
    // if (newItem.title && newItem.amount && newItem.category && newItem.date) {
    // widget.listItems.add(newItem);
    await DBProvider.db.newExpenses(newItem);
    widget.reload();
    // }
  }

  void removeExpenses(var id) async {
    // Get the removed item.
    removedItem = widget.listItems.firstWhere((item) => item.id == id);

    setState(() {
      widget.listItems.removeWhere((item) => item.id == id);
    });

    await DBProvider.db.deleteExpenses(id);
    widget.reload();

    // Assure remove any previous snakbars.
    Scaffold.of(context).removeCurrentSnackBar();

    // Show a new one.
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(
        seconds: 5,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      content: Text("Item removed"),
      action: SnackBarAction(
        label: 'Undo',
        textColor: Theme.of(context).primaryColorLight,
        onPressed: () {
          addNewExpenses(removedItem);
        },
      ),
    ));
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
