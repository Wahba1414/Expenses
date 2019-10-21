import 'package:flutter/material.dart';


class CustomDrawer extends StatefulWidget {
  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 100,
            child: DrawerHeader(
              padding: EdgeInsets.all(10),
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 22,
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
            ),
          ),
          // ListTile(
          //   title: Text(
          //     'Categories',
          //     style: TextStyle(
          //       color: Theme.of(context).primaryColorDark,
          //       fontSize: 18,
          //     ),
          //   ),
          //   onTap: () {
          //     print('Here');
          //     // Update the state of the app.
          //     Navigator.of(context).pop();
          //     Navigator.pushNamed(context, CategoryList.routeUrl);  
          //   },
          // ),
        ],
      ),
    );
  }
}
