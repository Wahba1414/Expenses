import 'package:flutter/material.dart';

import './models/expenses.dart';

class Statistics extends StatefulWidget {
  final List<Expenses> transactions;
  final List<String> categories;

  Statistics(this.transactions, this.categories);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  Map<String, int> statistics = {};
  int totalExpenses = 0;

  prepareStatistics() {
    totalExpenses = 0;
    // Initialize the statistics list with available categries.
    widget.categories.forEach((category) {
      statistics[category] = 0;
    });

    // Iterating on all transactions and sum for different categories.
    widget.transactions.forEach((transaction) {
      setState(() {
        totalExpenses += int.parse(transaction.amount);
        statistics[transaction.category] += int.parse(transaction.amount);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Prepare the statistics.
    prepareStatistics();

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).backgroundColor,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              height: constraints.maxHeight * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  Text(totalExpenses.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ))
                ],
              ),
            ),
            Container(
              height: constraints.maxHeight * .9,
              child: ListView.builder(
                  itemCount: widget.categories.length,
                  itemBuilder: (context, index) {
                    return (ListTile(
                      leading: Icon(
                        Icons.star,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(widget.categories[index]),
                      trailing: FittedBox(
                        child: Text(
                          '${statistics[widget.categories[index]]}',
                        ),
                      ),
                    ));
                  }),
            ),
          ],
        ),
      );
    });
  }
}
