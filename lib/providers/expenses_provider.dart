import 'package:expenses/models/fliters.dart';
import './../models/expenses.dart';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

// db helper.
import '../utilis/db.dart';

class AppExpensesProvider with ChangeNotifier {
  // Default.
  List<Expenses> _expenses = [];
  int selectedExpensesCount = 0;
  bool isAllSelected = false;

  List<Expenses> get expenses {
    return [..._expenses];
  }

  // A little hack for futureBuilder widget.
  Future<List<Expenses>> get futureExpenses async {
    _expenses = await DBProvider.db.getExpenses(filters);

    return [..._expenses];
  }

  // To save last filters.
  AppFilters filters = AppFilters();

  // Get Expenses.
  AppExpensesProvider() {
    DBProvider.db.getExpenses(AppFilters()).then((updatedList) {
      _expenses = updatedList;
      // Notify listerners.
      notifyListeners();
    });
  }

  filterExpenses(AppFilters _filters) {
    // Save the new filters.
    filters = _filters;

    DBProvider.db.getExpenses(filters).then((updatedList) {
      _expenses = updatedList;
      // Notify listerners.
      notifyListeners();
    });
  }

  // Add a new expenses.
  newExpenses(Expenses newItem) async {
    await DBProvider.db.newExpenses(newItem);

    _expenses = await DBProvider.db.getExpenses(filters);
    notifyListeners();
  }

  // Update Expenses.
  updateExpenses(String oldCategoryName, String newCategoryName) async {
    await DBProvider.db.updateExpenses(oldCategoryName, newCategoryName);

    DBProvider.db.getExpenses(filters).then((updatedList) {
      _expenses = updatedList;
      // Notify listerners.
      notifyListeners();
    });
  }

  // Remove Expenses.
  deleteExpenses(String id) async {
    await DBProvider.db.deleteExpenses(id);

    DBProvider.db.getExpenses(filters).then((updatedList) {
      _expenses = updatedList;
      // Notify listerners.
      notifyListeners();
    });
  }

  refresh() async {
    // print('here in refresh');
    _expenses = await DBProvider.db.getExpenses(filters);

    notifyListeners();
  }

  // Functions to deal with multiple selections.
  updateSelectedFlag(String id, bool flag) {
    // Update expenses list.
    _expenses.firstWhere((item) {
      return item.id == id;
    }).selected = flag;

    // Update total count.
    selectedExpensesCount = _expenses
        .where((item) {
          return (item.selected == true);
        })
        .toList()
        .length;

    isAllSelected = (_expenses.length == selectedExpensesCount) ? true : false;

    notifyListeners();
  }

  // Unselect all OR reset.
  selectAndUnselectAll(bool flag) {
    _expenses.forEach((item) {
      item.selected = flag;
    });

    if (flag) {
      // all selected.
      selectedExpensesCount = _expenses.length;
      isAllSelected = true;
    } else {
      // All unselected.
      selectedExpensesCount = 0;
      isAllSelected = false;
    }

    // Notify listerners.
    notifyListeners();
  }

  deleteSelectedItems() async {
    // List<String> ids = _expenses
    //     .where((item) {
    //       return item.selected;
    //     })
    //     .toList()
    //     .map((item) {
    //       return item.id;
    //     })
    //     .toList();
    List<String> ids = [];

    _expenses.forEach((item) {
      if (item.selected) {
        ids.add(item.id);
      }
    });

    await DBProvider.db.deleteMultipleExpenses(ids);

    // Reset.
    selectedExpensesCount = 0;
    isAllSelected = false;

    DBProvider.db.getExpenses(filters).then((updatedList) {
      _expenses = updatedList;
      // Notify listerners.
      notifyListeners();
    });
  }
}
