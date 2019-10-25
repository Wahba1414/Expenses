import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  final String message;

  const EmptyList(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
