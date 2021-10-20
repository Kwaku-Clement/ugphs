import 'package:flutter/material.dart';
import 'package:tolerance/nav/drawer_menu_widget.dart';

class Settings extends StatelessWidget {
  final VoidCallback openDrawer;

  const Settings({Key key, this.openDrawer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: DrawerMenuWidget(
          onClicked: openDrawer,
        ),
      ),
      body: Center(child: Text('Welcome to Settings \nUnder development')),
    );
  }
}
 