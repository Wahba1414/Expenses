import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: 2,
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          valueColor: new AlwaysStoppedAnimation<Color>(
            Theme.of(context).backgroundColor,
          ),
        ),
      ),
    );
  }
}
