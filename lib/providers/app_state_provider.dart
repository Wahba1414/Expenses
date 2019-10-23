import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import './../models/app_state.dart';

class AppStateProvider with ChangeNotifier {
  // Default.
  AppState _appState = AppState(mutliSelect: false);

  // get.
  AppState get appState {
    return _appState;
  }

  // update.
  updateAppState(AppState newItem) async {
    // print('inside updateAppState');
    _appState = newItem;

    // _appState.log();

    notifyListeners();
  }
}
