import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tolerance/nav/drawer_model.dart';

class DrawerItems {
  static const home = DrawerItem(icon: FontAwesomeIcons.home, title: 'Home');
  static const leadership =
      DrawerItem(icon: Icons.leaderboard, title: 'Party Executives');
  static const announcement =
      DrawerItem(icon: Icons.announcement, title: 'Announcement');
  static const resources =
      DrawerItem(icon: Icons.folder_open_outlined, title: 'Resources');
  static const schedule = DrawerItem(icon: Icons.schedule, title: 'Schedule');
  static const forum =
      DrawerItem(icon: FontAwesomeIcons.discourse, title: 'Forums');
  static const history = DrawerItem(icon: Icons.history, title: 'History');

  static const logout = DrawerItem(icon: Icons.logout, title: 'Logout');

  static final List<DrawerItem> all = [
    home,
    leadership,
    announcement,
    resources,
    schedule,
    forum,
    history,
    logout,
  ];
}
