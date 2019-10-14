import 'package:flutter/material.dart';

import './home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary
          )),
      home: Scaffold(
        appBar: appBar,
        body: Container(
          // height:
          //     (MediaQuery.of(context).size.height - appBar.preferredSize.height) * .5,
          child: Home(appBar.preferredSize.height),
        ),
      ),
    );
  }
}
