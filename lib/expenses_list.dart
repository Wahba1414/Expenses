import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';

// import './models/expenses.dart';
import './providers/catgeory_provider.dart';

class ExpensesList extends StatelessWidget {
  // List of possible colors for Avatar.
  final List<Color> colors = [
    Colors.indigo[100],
    Colors.indigo[200],
    Colors.indigo[300],
    Colors.indigo[400],
    Colors.blue[100],
    Colors.blue[200],
    Colors.blue[300],
    Colors.blue[400],
    Colors.lightBlue[100],
    Colors.lightBlue[200],
    Colors.lightBlue[300],
    Colors.lightBlue[400],
  ];
  final listItems;
  final removeItem;

  ExpensesList(this.listItems, this.removeItem);

  // Format money texts.
  formatMoney(value) {
    return FlutterMoneyFormatter(amount: value).output.withoutFractionDigits;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppCategoryProvider>(
        builder: (context, appCategoryProvider, child) {
      Function getColor = appCategoryProvider.getColorCodeFromCategory;

      return Container(
        padding: EdgeInsets.only(
          top: 12,
        ),
        // width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: listItems.length,
          itemBuilder: (context, index) {
            // print('listItems[index].mood:${listItems[index].mood}');
            final colorScheme = getColor(listItems[index].category);
            return Dismissible(
              key: Key(listItems[index].id),
              background: Container(
                // width: 10,
                color: Colors.red,
              ),
              onDismissed: (_) {
                removeItem(listItems[index].id);
              },
              child: (ListTile(
                // key: ValueKey(listItems[index].id),
                leading: CircleAvatar(
                  // backgroundColor: Theme.of(context).primaryColor,
                  backgroundColor: colorScheme,
                  foregroundColor: Theme.of(context).accentColor,
                  radius: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Text(
                        formatMoney(double.parse(listItems[index].amount)),
                      ),
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
                    (listItems[index].mood == 'Okay')
                        ? Icons.mood
                        : Icons.mood_bad,
                    size: 40,
                    color: colorScheme,
                  ),
                ),
              )),
            );
          },
        ),
      );
    });
  }
}
