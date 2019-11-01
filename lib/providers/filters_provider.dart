import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import '../models/fliters.dart';

class AppFiltersProvider with ChangeNotifier {
  AppFilters _filters = new AppFilters();

  AppFilters get appFilters {
    return new AppFilters.copy(_filters);
  }

  updateFilters(AppFilters newData) async {
    _filters.category = newData.category;

    // Month.
    // _filters.month = newData.month;
    // if (_filters.month != null) {
    //   int currentYear = new DateTime.now().year;

    //   _filters.monthStart =
    //       new DateTime(currentYear, _filters.month, 1, 0, 0, 0, 0);
    //   _filters.monthEnd = (_filters.month < 12)
    //       ? new DateTime(currentYear, _filters.month + 1, 0, 0, 0, 0, 0)
    //       : new DateTime(
    //           currentYear + 1, 1, 0, 0, 0, 0, 0); //Need to think about more.

    // }

    // // Year.
    // _filters.year = newData.year;

    // New date filters.
    _filters.fromDate = newData.fromDate;
    _filters.toDate = newData.toDate;

    // Notify listerners.
    notifyListeners();

    return _filters;
  }
}
