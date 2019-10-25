import 'package:expenses/providers/expenses_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';

import './providers/catgeory_provider.dart';
import './providers/app_state_provider.dart';

import './models/app_state.dart';

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

                  // Reset
                  Provider.of<AppExpensesProvider>(context)
                      .selectAndUnselectAll(false);

                  // Assure remove any previous snakbars.
                  Scaffold.of(context).removeCurrentSnackBar();

                  // Show a new one.
                  Scaffold.of(context).showSnackBar(SnackBar(
                    duration: Duration(
                      seconds: 5,
                    ),
                    backgroundColor: Theme.of(context).backgroundColor,
                    content: const Text("Item removed"),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Theme.of(context).primaryColorLight,
                      onPressed: () {
                        appExpensesProvider.newExpenses(removedItem);
                      },
                    ),
                  ));
                },
                child: (Consumer<AppStateProvider>(
                    builder: (context, appStateProvider, child) {
                  AppState appState = appStateProvider.appState;
                  return ListTile(
                    onLongPress: () {
                      Provider.of<AppStateProvider>(context)
                          .updateAppState(new AppState(mutliSelect: true));

                      listItems[index].selected = true;
                      Provider.of<AppExpensesProvider>(context)
                          .updateSelectedFlag(listItems[index].id, true);
                    },
                    onTap: () {
                      if (appState.mutliSelect) {
                        listItems[index].selected =
                            (listItems[index].selected == null)
                                ? true
                                : !listItems[index].selected;
                        Provider.of<AppExpensesProvider>(context)
                            .updateSelectedFlag(
                                listItems[index].id, listItems[index].selected);
                      }
                    },
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
                    trailing: Consumer<AppStateProvider>(
                        builder: (context, appStateProvider, child) {
                      AppState appState = appStateProvider.appState;
                      return Container(
                        child: (appState.mutliSelect)
                            ? Checkbox(
                                activeColor: Theme.of(context).backgroundColor,
                                value: listItems[index].selected ?? false,
                                onChanged: (_value) {
                                  listItems[index].selected = _value;
                                  Provider.of<AppExpensesProvider>(context)
                                      .updateSelectedFlag(
                                          listItems[index].id, _value);
                                },
                              )
                            : Icon(
                                (listItems[index].mood == 'Okay')
                                    ? Icons.mood
                                    : Icons.mood_bad,
                                size: 40,
                                color: colorScheme,
                              ),
                      );
                    }),
                  );
                })),
              );
            });
          },
        ),
      );
    });
  }
}
