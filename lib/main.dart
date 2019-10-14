import 'package:flutter/material.dart';

import './home.dart';

// db.
import './utilis/db.dart';
import './models/expenses.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void reload() {
    setState(() {});
  }

  final AppBar appBar = AppBar(
    title: Text('Expenses'),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.blue[300],
          accentColor: Colors.blueAccent,
          textTheme: TextTheme(
            body1: TextStyle(
              color: Colors.blue[400],
              fontSize: 18,
            ),
          ),
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary)),
      home: Scaffold(
        appBar: appBar,
        body: FutureBuilder<List<Expenses>>(
            future: DBProvider.db.getAllExpenses(),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<Expenses>> snapshot,
            ) {
              print("snapshot.data");
              print(snapshot.data);
              return Container(
                // height:
                //     (MediaQuery.of(context).size.height - appBar.preferredSize.height) * .5,
                child: Home(
                    appBar.preferredSize.height, snapshot.data ?? [], reload),
              );
            }),
      ),
    );
  }
}
