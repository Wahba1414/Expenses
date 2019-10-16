import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import './models/expenses.dart';

class ExpensesList extends StatelessWidget {
  // List of possible colors for Avatar.
  final List<Color> colors = [
    Colors.indigo[100],
    Colors.indigo[200],
    Colors.indigo[300],
    Colors.indigo[400],
  ];
  final listItems;
  final removeItem;

  ExpensesList(this.listItems, this.removeItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 12,
      ),
      // width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            background: Container(
              // child: Align(
              //   child: Icon(
              //     Icons.delete,
              //     color: Colors.white,
              //   ),
              // ),
              color: Colors.red,
            ),
            key: Key(listItems[index].id),
            onDismissed: (_) {
              removeItem(listItems[index].id);
            },
            child: (ListTile(
              // key: ValueKey(listItems[index].id),
              leading: CircleAvatar(
                // backgroundColor: Theme.of(context).primaryColor,
                backgroundColor: colors[Random().nextInt(4)],
                foregroundColor: Theme.of(context).accentColor,
                radius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: Text(listItems[index].amount),
                  ),
                ),
              ),
              title: Text(
                listItems[index].title,
              ),
              subtitle: Text(
                '${listItems[index].category}\n${DateFormat.yMMMMd().format(listItems[index].date)}',
              ),
              trailing: Container(
                child: Icon(
                  Icons.mood,
                  size: 40,
                  color: colors[Random().nextInt(4)],
                ),
              ),
            )),
          );
        },
      ),
    );
  }
}
