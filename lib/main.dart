import 'package:flutter/material.dart';

import './home.dart';
import './drawer.dart';
import './category_list.dart';
import './new_expenses_form.dart';

import 'package:provider/provider.dart';

import './providers/catgeory_provider.dart';
import './providers/filters_provider.dart';
import './providers/expenses_provider.dart';
import './providers/app_state_provider.dart';

// db.
import './utilis/db.dart';
import './models/expenses.dart';

import './models/expenses_arguments.dart';
import './models/app_state.dart';

void main() => runApp(Top());

class Top extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => AppCategoryProvider()),
        ChangeNotifierProvider(builder: (_) => AppFiltersProvider()),
        ChangeNotifierProvider(builder: (_) => AppExpensesProvider()),
        ChangeNotifierProvider(builder: (_) => AppStateProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // fontFamily: 'Monotserrat',
          // fontFamily: 'RobotoMono',
          // fontFamily: 'OpenSans',
          // fontFamily: 'Hind',
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
        home: Consumer<AppCategoryProvider>(
            builder: (context, appCategoryProvider, child) {
          var allCategories = appCategoryProvider.appCategories;
          List<String> categoriesNames =
              allCategories.map((item) => item.title).toList();
          return MyApp(categoriesNames);
        }),
        // routes.
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          // '/': (context) => MyApp(),
          // Category list.
          CategoryList.routeUrl: (context) => CategoryList(),
          NewExpensesForm.routeUrl: (context) => NewExpensesForm(),
        },
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  final _categories;

  MyApp(this._categories);

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
  void _startAddNewExpenses(context) {
    // showModalBottomSheet(
    //     context: context,
    //     builder: (builder) {
    //       // return NewExpenses(_selectDate, widget._categories, addNewExpenses);
    //       return NewExpensesForm(
    //           _selectDate, widget._categories, addNewExpenses);
    //     });
    Navigator.of(context).pushNamed(NewExpensesForm.routeUrl,
        arguments: ExpensesArguments(_selectDate, widget._categories));
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

  void removeCabAndReset() async {
    await Provider.of<AppStateProvider>(context)
        .updateAppState(new AppState(mutliSelect: false));
    // Reset
    Provider.of<AppExpensesProvider>(context).selectAndUnselectAll(false);
  }

  void _selectTap(int index) {
    // print('index: $index');
    setState(() {
      tabIndex = index;
    });

    if (tabIndex != 0) {
      // Reset
      removeCabAndReset();
    }
  }

  void confirmDeleteMultipleExpenses(BuildContext ctx, Function deleteHandler) {
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blueGrey[100],
            // title: Text('Remove Category' ),
            content: Text(
              'Are you sure ?',
              style: TextStyle(color: Colors.red[300], fontSize: 20),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  deleteHandler();
                  Navigator.of(context).pop();
                },
                textColor: Colors.red[300],
              )
            ],
          );
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
        Container(
          padding: EdgeInsets.only(right: 10),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).primaryColorLight,
                  size: 28,
                ),
                onPressed: () {
                  _startAddNewExpenses(context);
                },
                // color: Colors.red,
              ),
              // IconButton(
              //   icon: Icon(
              //     Icons.more_vert,
              //     color: Theme.of(context).primaryColorLight,
              //     size: 24,
              //   ),
              //   onPressed: () {
              //     Provider.of<AppStateProvider>(context)
              //         .updateAppState(new AppState(mutliSelect: true));
              //   },
              //   // color: Colors.red,
              // ),
            ],
          ),
        )
      ],
    );

// New AppBar for multi-select. (CAB).
    final AppBar cab = AppBar(
      title: Row(
        children: <Widget>[
          Container(
            width: 60,
            padding: EdgeInsets.only(bottom: 5),
            child: FlatButton(
              child: Text(
                'x',
                style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontSize: 30,
                    fontWeight: FontWeight.w200),
              ),
              onPressed: removeCabAndReset,
            ),
          ),
          Consumer<AppExpensesProvider>(
              builder: (context, appExpensesProvider, child) {
            var selectedCount = appExpensesProvider.selectedExpensesCount;
            return Container(
              padding: EdgeInsets.only(bottom: 2),
              // alignment: Alignment.center,
              child: Text(
                'Selected ($selectedCount)',
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontWeight: FontWeight.w300,
                ),
              ),
            );
          }),
        ],
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 10),
          child: Consumer<AppExpensesProvider>(
              builder: (context, appExpensesProvider, child) {
            var isAllSelected = appExpensesProvider.isAllSelected;
            var deleteSelected = appExpensesProvider.deleteSelectedItems;
            return Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        color: Theme.of(context).primaryColorLight,
                        size: 30,
                      ),
                      onPressed: () {
                        confirmDeleteMultipleExpenses(context, deleteSelected);
                      }

                      // color: Colors.red,
                      ),
                ),
                Transform.scale(
                  alignment: Alignment.centerRight,
                  scale: 1.2,
                  child: Checkbox(
                    activeColor: Theme.of(context).backgroundColor,
                    value: isAllSelected,
                    onChanged: (_value) {
                      Provider.of<AppExpensesProvider>(context)
                          .selectAndUnselectAll(_value);
                    },
                  ),
                )
              ],
            );
          }),
        )
      ],
    );

    return Consumer<AppStateProvider>(
        builder: (context, appStateProvider, child) {
      AppState appState = appStateProvider.appState;
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: (appState.mutliSelect) ? cab : appBar,
        body: Consumer<AppFiltersProvider>(
            builder: (context, appFiltersProvider, child) {
          return Container(
            // height:
            //     (MediaQuery.of(context).size.height - appBar.preferredSize.height) * .5,
            child: Home(
              appBar.preferredSize.height + kBottomNavigationBarHeight + 6,
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
        drawer: (appState.mutliSelect)
            ? null
            : Drawer(
                child: CustomDrawer(),
              ),
      );
    });
  }
}
