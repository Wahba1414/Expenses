import 'package:expenses/providers/expenses_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';

// import './models/expenses.dart';
import './providers/catgeory_provider.dart';

class ExpensesList extends StatelessWidget {
  final listItems;

  ExpensesList(this.listItems);

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
            return Consumer<AppExpensesProvider>(
                builder: (context, appExpensesProvider, child) {
              var removeItem = appExpensesProvider.deleteExpenses;
              return Dismissible(
                key: Key(listItems[index].id),
                background: Container(
                  // width: 10,
                  color: Colors.red,
                ),
                onDismissed: (_) async {
                  var removedItem = listItems[index];

                  await removeItem(listItems[index].id);

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
                        appExpensesProvider.newExpenses(removedItem);
                      },
                    ),
                  ));
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
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    '${listItems[index].category}\n${DateFormat.yMMMMd().format(listItems[index].date)}',
                    style: TextStyle(
                      fontSize: 14,
                    ),
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
            });
          },
        ),
      );
    });
  }
}
