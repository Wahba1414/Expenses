import 'package:flutter/material.dart';

import './home.dart';
import './new_expenses.dart';

// db.
import './utilis/db.dart';
import './models/expenses.dart';

void main() => runApp(Top());

class Top extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[300],
        accentColor: Colors.black87,
        textTheme: TextTheme(
          title: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          body1: TextStyle(
            color: Colors.blue[400],
            fontSize: 18,
          ),
        ),
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.normal,

          buttonColor: Colors.blueAccent[100],
          // colorScheme: ColorScheme.dark(),
        ),
        backgroundColor: Colors.indigo[200],
      ),
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  final _categories = [
    'Personal',
    'Shopping',
    'Outings',
    'Love',
    'Home',
    'Family',
    'Food',
    'Gym',
    'Others'
  ];

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // holds the tab index.
  int tabIndex = 0;

  void reload() {
    setState(() {});
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

  void addNewExpenses(Expenses newItem) async {
    // if (newItem.title && newItem.amount && newItem.category && newItem.date) {
    // widget.listItems.add(newItem);
    await DBProvider.db.newExpenses(newItem);
    reload();
    // }
  }

  void _selectTap(int index) {
    print('index: $index');
    setState(() {
      tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      title: Text('Expenses'),
      actions: <Widget>[
        FlatButton(
          child: Icon(
            Icons.add,
            color: Theme.of(context).accentColor,
            size: 30,
          ),
          onPressed: _startAddNewExpenses,
          // color: Colors.red,
        )
      ],
    );

    return Scaffold(
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
                appBar.preferredSize.height + kBottomNavigationBarHeight,
                snapshot.data ?? [],
                reload,
                widget._categories,
                tabIndex,
              ),
            );
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            title: Text('List'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Statistics'),
          )
        ],
        onTap: _selectTap,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: tabIndex,
      ),
    );
  }
}
