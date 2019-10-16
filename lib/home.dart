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

  Home(this.appBarHeight, this.listItems, this.reload, this._categories, this.tabIndex);

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
    // setState(() {
    //   widget.listItems.removeWhere((item) => item.id == id);
    // });

    await DBProvider.db.deleteExpenses(id);
    widget.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          children: <Widget>[
            // Container(
            //   height: (MediaQuery.of(context).size.height -
            //           widget.appBarHeight -
            //           widget.statusBarHeight) *
            //       .1,
            //   child: CustomSwitch(
            //     'Statistics',
            //     showStatistics,
            //     (_value) {
            //       setState(() {
            //         // print('_value');
            //         // print(_value);
            //         showStatistics = _value;
            //       });
            //     },
            //   ),
            // ),
            ((widget.tabIndex == 1)
                ? Container(
                    // height: 30,
                    height: (MediaQuery.of(context).size.height -
                            widget.appBarHeight -
                            widget.statusBarHeight) *
                        1,
                    child: Statistics(widget.listItems, widget._categories),
                  )
                : Container(
                    height: (MediaQuery.of(context).size.height -
                            widget.appBarHeight -
                            widget.statusBarHeight) *
                        1,
                    child: Container(
                      child: (widget.listItems.length > 0)
                          ? ExpensesList(widget.listItems, removeExpenses)
                          : EmptyList(),
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
