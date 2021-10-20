import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tolerance/authentication/auth.dart';
import 'package:tolerance/constants/variables.dart';
import 'package:tolerance/nav/drawer_menu_widget.dart';
import 'package:tolerance/pages/profile_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback openDrawer;
  final String title;
  CustomAppBar({Key key, @required this.openDrawer, this.title})
      : super(key: key);
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        DrawerMenuWidget(
          onClicked: openDrawer,
        ),
        Text(title),
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(
              'http://romanroadtrust.co.uk/wp-content/uploads/2018/01/profile-icon-png-898-300x300.png'),
        ),
      ]),
      actions: [
        PopupMenuButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.black,
            size: 34,
          ),
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 0,
              child: Text('Settings'),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Text('Logout'),
              onTap: () async {
                await _auth.signOut();
              },
            ),
          ],
          onSelected: (item) => selectedItem(context, item),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
