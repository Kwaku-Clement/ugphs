import 'package:flutter/material.dart';
import 'package:tolerance/constants/custom_colors.dart';
import 'package:tolerance/nav/drawer_model.dart';
import 'package:tolerance/nav/drawer_items.dart';

class DrawerWidget extends StatelessWidget {
  final ValueChanged<DrawerItem> onSelectedItem;

  DrawerWidget({Key key, @required this.onSelectedItem}) : super(key: key);
  final Color colors = CustomColors.firebaseGrey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.googleBackground,
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 32, 10, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildDrawerItems(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawerItems(BuildContext context) => Column(
        children: [
          SizedBox(height: 20),
          Column(
            children: DrawerItems.all
                .map(
                  (item) => ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Icon(
                      item.icon,
                      color: colors,
                    ),
                    title: Text(item.title,
                        style: TextStyle(
                          color: colors,
                          fontSize: 18,
                        )),
                    onTap: () => onSelectedItem(item),
                  ),
                )
                .toList(),
          ),
        ],
      );
}
