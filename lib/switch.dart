import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {

  final switchText;
  final switchValue;
  final Function switchOnChanged;

  CustomSwitch(this.switchText, this.switchValue, this.switchOnChanged);

  @override
  Widget build(BuildContext context) {
    // Size object of screen.
    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: Container(
        width: screenSize.width * .5,
        child: Row(
          children: <Widget>[
            Text(
              switchText,
            ),
            Switch(
              value: switchValue,
              onChanged: switchOnChanged,
            ),
          ],
        ),
      ),
    );
  }
}
