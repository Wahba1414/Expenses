import 'package:flutter/material.dart';

import './home.dart';
import './new_expenses_form.dart';
import './drawer.dart';
import './category_list.dart';

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
        // fontFamily: 'Monotserrat',
        // fontFamily: 'RobotoMono',
        // fontFamily: 'OpenSans',
        fontFamily: 'Hind',
        primaryColor: Colors.blue[300],
        accentColor: Colors.black87,
        primaryColorLight: Colors.white,
        primaryColorDark: Colors.black,
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
        // backgroundColor: Colors.cyan[400],
        backgroundColor: Colors.purple[300],
        // backgroundColor: Colors.pink[300],
        // dialogBackgroundColor: Colors.blue[400]
      ),
      home: MyApp(),
      // routes.
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        // '/': (context) => MyApp(),
        // Category list.
        CategoryList.routeUrl: (context) => CategoryList(),
      },
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
          // return NewExpenses(_selectDate, widget._categories, addNewExpenses);
          return NewExpensesForm(
              _selectDate, widget._categories, addNewExpenses);
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

  Future<bool> addNewExpenses(Expenses newItem) async {
    // if (newItem.title && newItem.amount && newItem.category && newItem.date) {
    // widget.listItems.add(newItem);
    await DBProvider.db.newExpenses(newItem);
    reload();
    return true;
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
      title: Text(
        'Expenses',
        style: TextStyle(
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Icon(
            Icons.add,
            color: Theme.of(context).primaryColorLight,
            size: 30,
          ),
          onPressed: _startAddNewExpenses,
          // color: Colors.red,
        )
      ],
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: appBar,
      body: FutureBuilder<List<Expenses>>(
          future: DBProvider.db.getAllExpenses(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Expenses>> snapshot,
          ) {
            // print("snapshot.data");
            // print(snapshot.data);
            return Container(
              // height:
              //     (MediaQuery.of(context).size.height - appBar.preferredSize.height) * .5,
              child: Home(
                appBar.preferredSize.height + kBottomNavigationBarHeight + 6,
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
            icon: Icon(Icons.home),
            title: Text('List'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Statistics'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            title: Text('Categories'),
          )
        ],
        onTap: _selectTap,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: tabIndex,
      ),
      drawer: Drawer(
        child: CustomDrawer(),
      ),
    );
  }
}
