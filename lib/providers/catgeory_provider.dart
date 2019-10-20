import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import 'package:uuid/uuid.dart';

import '../models/category.dart';

// db helper.
import '../utilis/db.dart';

class AppCategoryProvider with ChangeNotifier {
  final List<Map<String, dynamic>> colors = [
    {'name': 'indigo100', 'value': Colors.indigo[100]},
    {'name': 'indigo200', 'value': Colors.indigo[200]},
    {'name': 'indigo300', 'value': Colors.indigo[300]},
    {'name': 'indigo400', 'value': Colors.indigo[400]},
    {'name': 'blue100', 'value': Colors.blue[100]},
    {'name': 'blue200', 'value': Colors.blue[200]},
    {'name': 'blue300', 'value': Colors.blue[300]},
    {'name': 'blue400', 'value': Colors.blue[400]},
    {'name': 'blue100', 'value': Colors.lightBlue[100]},
    {'name': 'lightBlue200', 'value': Colors.lightBlue[200]},
    {'name': 'lightBlue300', 'value': Colors.lightBlue[300]},
    {'name': 'lightBlue400', 'value': Colors.lightBlue[400]},
  ];

  Color getColorCode(String colorName) {
    print('colorname:$colorName');

    return (colors.firstWhere((item) {
      return item['name'] == colorName;
    })['value']);
  }

  // Default.
  List<AppCategoryModel> _categories = [
    AppCategoryModel(id: '1', title: 'Others', color: 'blue100')
  ];

  AppCategoryProvider() {
    DBProvider.db.getAllCategories().then((updatedList) {
      _categories = updatedList;
      // Notify listerners.
      notifyListeners();
    });
  }

  List<AppCategoryModel> get appCategories {
    return [..._categories];
  }

  addNewCategory(AppCategoryModel newItem) {
    print('newItem');
    print(newItem);

    if (newItem.title == null) {
      return;
    }

    // Add an ID.
    newItem.id = new Uuid().v1();

    // Pick up a random color.
    int seed = Random().nextInt(10000000);
    newItem.color = colors[Random(seed).nextInt(12)]['name'];

    //  Optimistic update.
    _categories.add(newItem);

    DBProvider.db.newCategory(newItem).catchError((error) {
      // Roll back.
      _categories.removeWhere((item) {
        return item.id == newItem.id;
      });

      // Notify listeners.
      notifyListeners();
    });

    // Notify listeners.
    notifyListeners();
  }

  removeCategory(AppCategoryModel removedCategory){
    _categories.removeWhere((item){
      return item.id == removedCategory.id;
    });

    DBProvider.db.deleteCategory(removedCategory).catchError((error) {
      // Roll back.
      addNewCategory(removedCategory);

      // Notify listeners.
      notifyListeners();
    });

    // Notify listeners.
    notifyListeners();
  }

}
