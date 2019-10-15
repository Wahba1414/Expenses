import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import './models/expenses.dart';

class ExpensesList extends StatelessWidget {
  final listItems;
  final removeItem;

  ExpensesList(this.listItems, this.removeItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          return (ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
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
              width: MediaQuery.of(context).size.width * .05,
              child: FlatButton(
                padding: EdgeInsets.only(right: 0),
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  removeItem(listItems[index].id);
                },
              ),
            ),
          ));
        },
      ),
    );
  }
}
