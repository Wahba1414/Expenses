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

  // Get Expenses.
  AppExpensesProvider() {
    DBProvider.db.getExpenses(null).then((updatedList) {
      _expenses = updatedList;
      // Notify listerners.
      notifyListeners();
    });
  }

  filterExpenses(AppFilters filters) {
    DBProvider.db.getExpenses(filters).then((updatedList) {
      _expenses = updatedList;
      // Notify listerners.
      notifyListeners();
    });
  }

  // Update Expenses.
  updateExpenses(String oldCategoryName, String newCategoryName,
      AppFilters filters) async {
    await DBProvider.db.updateExpenses(oldCategoryName, newCategoryName);

    DBProvider.db.getExpenses(filters).then((updatedList) {
      _expenses = updatedList;
      // Notify listerners.
      notifyListeners();
    });
  }

  // Remove Expenses.
  deleteExpenses(String id, AppFilters filters) async {
    await DBProvider.db.deleteExpenses(id);

    DBProvider.db.getExpenses(filters).then((updatedList) {
      _expenses = updatedList;
      // Notify listerners.
      notifyListeners();
    });
  }
}
