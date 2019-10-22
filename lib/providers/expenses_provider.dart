import 'package:expenses/models/fliters.dart';
import './../models/expenses.dart';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

// db helper.
import '../utilis/db.dart';

class AppExpensesProvider with ChangeNotifier {
  // Default.
  List<Expenses> _expenses = [];

  List<Expenses> get expenses {
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

  filterExpenses(AppFilters filters) {
    // Save the new filters.
    filters = filters;

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
}
