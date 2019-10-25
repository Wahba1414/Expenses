import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';

import './models/expenses.dart';
import './providers/catgeory_provider.dart';

class Statistics extends StatefulWidget {
  final List<Expenses> transactions;
  final List<String> categories;

  Statistics(this.transactions, this.categories);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  Map<String, double> statistics = {};
  double totalExpenses = 0;

  List<String> updatedCategories;

  prepareStatistics() {
    totalExpenses = 0;

    // Init updatedCategories.
    updatedCategories = [...widget.categories];

    // Initialize the statistics list with available categries.
    updatedCategories.forEach((category) {
      statistics[category] = 0;
    });

    // Set the 'No Category' field.
    // statistics['Uncategorized'] = 0;

    // Iterating on all transactions and sum for different categories.
    widget.transactions.forEach((transaction) {
      setState(() {
        totalExpenses += int.parse(transaction.amount);
        statistics[transaction.category] =
            (statistics[transaction.category] == null)
                ? double.parse(transaction.amount)
                : (statistics[transaction.category] +
                    double.parse(transaction.amount));
      });
    });
  }

  // Format money texts.
  formatMoney(value) {
    return FlutterMoneyFormatter(amount: value).output.withoutFractionDigits;
  }

  @override
  Widget build(BuildContext context) {
    // Prepare the statistics.
    prepareStatistics();

    return Consumer<AppCategoryProvider>(
        builder: (context, appCategoryProvider, child) {
      Function getColor = appCategoryProvider.getColorCodeFromCategory;

      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          child: Column(
            children: <Widget>[
              Container(
                height: constraints.maxHeight * .1,
                child: Card(
                  color: Theme.of(context).backgroundColor,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.attach_money,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Total',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 16),
                        ),
                        Spacer(
                          flex: 2,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            right: 10,
                          ),
                          child: FittedBox(
                            child: Text(
                              formatMoney(totalExpenses),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
                                  fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              // List of details for different categories.
              (Container(
                height: constraints.maxHeight * .9,
                child: ListView.builder(
                    itemCount: updatedCategories.length,
                    itemBuilder: (context, index) {
                      // Get Category Color.
                      var catgeoryColor = getColor(updatedCategories[index]);

                      return Container(
                        height: constraints.maxHeight * .1,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  color:
                                      catgeoryColor, //Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  updatedCategories[index],
                                  style: TextStyle(
                                    color: catgeoryColor,
                                    fontSize: 16,
                                  ),
                                ),
                                Spacer(
                                  flex: 2,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    right: 10,
                                  ),
                                  child: FittedBox(
                                      child: Text(
                                    formatMoney(
                                        statistics[updatedCategories[index]]),
                                    style: TextStyle(
                                      color: catgeoryColor,
                                      fontSize: 16,
                                    ),
                                  )),
                                )
                              ],
                            ),
                          ),
                          color: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      );
                    }),
              )),
            ],
          ),
        );
      });
    });
  }
}
