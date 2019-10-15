import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text(
        'No Transactions added yet !!',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
