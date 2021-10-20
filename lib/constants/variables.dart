import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tolerance/admin/add_announcement.dart';
import 'package:tolerance/admin/add_files.dart';
import 'package:tolerance/admin/add_forum.dart';
import 'package:tolerance/admin/add_leader.dart';
import 'package:tolerance/admin/add_program.dart';
import 'package:tolerance/admin/uploadImages.dart';
import 'package:tolerance/authentication/auth.dart';
import 'package:tolerance/authentication/signup_screen.dart';
import 'package:tolerance/constants/rounded_button.dart';
import 'package:tolerance/pages/profile_page.dart';

import 'custom_colors.dart';

CollectionReference forum = FirebaseFirestore.instance.collection('Forums');

CollectionReference userQuestions =
    FirebaseFirestore.instance.collection('Questions');

CollectionReference userAnswers =
    FirebaseFirestore.instance.collection('Answers');

CollectionReference userCollection =
    FirebaseFirestore.instance.collection('Users');

final user = FirebaseAuth.instance.currentUser;
final backgroundColor = CustomColors.firebaseGrey;
final Auth _auth = Auth();

selectedItem(BuildContext context, item) {
  switch (item) {
    case 0:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(),
          ));
      break;
    case 1:
      RoundedButton(
        onPressed: () async {
          await _auth.signOut();
        },
      );
      break;
  }
}

Future<void> signOut() async {
  try {
    await _auth.signOut();
  } catch (e) {
    print(e);
  }
}

selectedUpdate(BuildContext context, item) {
  switch (item) {
    case 0:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddFile(),
          ));
      break;
    case 1:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddAnnouncement(),
          ));
      break;
    case 2:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddLeader(),
          ));
      break;
    case 3:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddSchedule(),
          ));
      break;
    case 4:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddForum(),
          ));
      break;
    case 5:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUp(),
          ));
      break;
  }
}

final List names = [
  'Update resources',
  'Add announcement',
  'Update Executives',
  'Add Schedule',
  'Add Forum',
  'Create user'
];

final List icons = [
  Icons.folder_open_outlined,
  Icons.announcement_outlined,
  Icons.leaderboard,
  Icons.schedule,
  Icons.forum,
  Icons.person_add,
];
