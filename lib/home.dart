import 'dart:async';


import 'package:flutter/material.dart';


import './switch.dart';
import './expenses_list.dart';
import './new_expenses.dart';
import './empty_list.dart';

// models.
import './models/expenses.dart';

class Home extends StatefulWidget {
  final _categories = ['Personal', 'Shopping', 'Outings', 'Love'];

  final appBarHeight;
  final statusBarHeight = 24;

  Home(this.appBarHeight);

  @override
  _HomeState createState() => _HomeState();
  }

class _HomeState extends State<Home> {
  final List<Expenses> listItems = [];

  void addNewExpenses(Expenses newItem) {
    setState(() {
      // if (newItem.title && newItem.amount && newItem.category && newItem.date) {
      listItems.add(newItem);
      // }
    });
  }

  void removeExpenses(var id) {
    setState(() {
      listItems.removeWhere((item) => item.id == id);
    });
  }

  // Function opens a bottom modal.
  void _startAddNewExpenses() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return NewExpenses(_selectDate, widget._categories, addNewExpenses);
        });
  }

  // Open date picker.
  Future<DateTime> _selectDate() {
    return showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: DateTime(DateTime.now().year, 1),
        lastDate: new DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: (MediaQuery.of(context).size.height -
                      widget.appBarHeight -
                      widget.statusBarHeight) *
                  .1,
              child: CustomSwitch(
                'Show Chart',
                false,
                (_) {},
              ),
            ),
            // Container(
            //   child: Text('Chart'),
            // ),

            Container(
              height: (MediaQuery.of(context).size.height -
                      widget.appBarHeight -
                      widget.statusBarHeight) *
                  .9,
              child: Stack(children: <Widget>[
                Container(
                  child: (listItems.length > 0)
                      ? ExpensesList(listItems, removeExpenses)
                      : EmptyList(),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: _startAddNewExpenses,
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
