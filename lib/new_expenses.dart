import 'package:expenses/models/expenses.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class NewExpenses extends StatefulWidget {
  final selectDate;
  final _categories;
  final addNewExpenses;

  NewExpenses(this.selectDate, this._categories, this.addNewExpenses);

  @override
  _NewExpensesState createState() => _NewExpensesState();
}

class _NewExpensesState extends State<NewExpenses> {
  // Controllers.
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  // Other inputs.
  var selectedCategory;
  DateTime selectedDate;

  _handleAsyncDatePicker() {
    widget.selectDate().then((pickedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(hintText: 'Title'),
              controller: titleController,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Amount'),
              keyboardType: TextInputType.number,
              controller: amountController,
            ),
            Container(
              // width: MediaQuery.of(context).size.width,
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text(
                    (selectedCategory == null) ? 'Category' : selectedCategory),
                items: (widget._categories as List<String>).map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_newValue) {
                  setState(() {
                    selectedCategory = _newValue;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text((selectedDate == null)
                    ? 'No date is chosen'
                    : (DateFormat.yMMMMd().format(selectedDate))),
                FlatButton(
                  child: const Text('Pick up a date'),
                  onPressed: _handleAsyncDatePicker,
                )
              ],
            ),
            RaisedButton(
              child: const Text('Add'),
              onPressed: () {
                if ((titleController.text != null) &&
                    (amountController.text != null) &&
                    (selectedCategory != null) &&
                    (selectedDate != null)) {
                  Expenses newItem = Expenses(
                    id: new Uuid().v1(),
                    title: titleController.text,
                    amount: amountController.text,
                    date: selectedDate,
                    category: selectedCategory,
                  );

                  widget.addNewExpenses(newItem);

                  Navigator.of(context).pop();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
