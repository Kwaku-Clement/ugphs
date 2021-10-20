import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tolerance/authentication/auth.dart';
import 'package:tolerance/constants/custom_colors.dart';
import 'package:tolerance/nav/drawer_model.dart';
import 'package:tolerance/nav/drawer_items.dart';
import 'package:tolerance/nav/drawer_widget.dart';
import 'package:tolerance/pages/announcement.dart';
import 'package:tolerance/pages/forum.dart';
import 'package:tolerance/pages/history.dart';
import 'package:tolerance/pages/homepage.dart';
import 'package:tolerance/pages/leaderboard.dart';
import 'package:tolerance/pages/schedules.dart';
import 'package:tolerance/pages/resources.dart';

class MainPage extends StatefulWidget {
  static const String id = 'main_screen';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double xOffset;
  double yOffset;
  double scaleFactor;
  DrawerItem item = DrawerItems.home;
  bool isDrawerOpen;
  bool isDragging = false;
  final Auth _auth = Auth();

  @override
  void initState() {
    super.initState();

    closeDrawer();
  }

  openDrawer() => setState(() {
        xOffset = 230;
        yOffset = 150;
        scaleFactor = 0.6;

        isDrawerOpen = true;
      });

  closeDrawer() => setState(() {
        xOffset = 0;
        yOffset = 0;
        scaleFactor = 1;

        isDrawerOpen = false;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isDrawerOpen ? CustomColors.googleBackground : Colors.white12,
      body: Stack(children: [
        buildDrawer(),
        buildPage(),
      ]),
    );
  }

  Widget buildDrawer() => SafeArea(
        child: Container(
          width: xOffset,
          child: DrawerWidget(onSelectedItem: (item) {
            switch (item) {
              case DrawerItems.logout:
                return GestureDetector(
                  onTap: () async {
                    await _auth.signOut();
                  },
                );
              default:
                setState(() {
                  this.item = item;
                  closeDrawer();
                });
            }
          }),
        ),
      );

  Widget buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: closeDrawer,
        onHorizontalDragStart: (details) => isDragging = true,
        onHorizontalDragUpdate: (details) {
          if (!isDragging) return;
          const delta = 1;
          if (details.delta.dx > delta) {
            openDrawer();
          } else if (details.delta.dx < -delta) {
            closeDrawer();
          }
          isDragging = false;
        },
        child: AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor),
            duration: Duration(milliseconds: 300),
            child: AbsorbPointer(
              absorbing: isDrawerOpen,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
                child: Container(
                  color: isDrawerOpen ? Colors.grey : CustomColors.firebaseGrey,
                  child: getDrawerPage(),
                ),
              ),
            )),
      ),
    );
  }

  Widget getDrawerPage() {
    switch (item) {
      case DrawerItems.leadership:
        return LeaderboardPage(openDrawer: openDrawer);
      case DrawerItems.announcement:
        return Announcement(openDrawer: openDrawer);
      case DrawerItems.forum:
        return Forum(openDrawer: openDrawer);
      case DrawerItems.resources:
        return Resources(openDrawer: openDrawer);
      case DrawerItems.schedule:
        return Schedules(openDrawer: openDrawer);
      case DrawerItems.history:
        return History(openDrawer: openDrawer);
      case DrawerItems.logout:
        return GestureDetector(
          onTap: () async {
            await FirebaseAuth.instance.signOut();
          },
        );
      default:
        return HomePage(openDrawer: openDrawer);
    }
  }
}
