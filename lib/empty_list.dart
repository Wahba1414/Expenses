import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  final String message;

  EmptyList(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
