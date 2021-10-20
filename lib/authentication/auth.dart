import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:tolerance/model/userModel.dart';
import 'package:tolerance/service/database.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging _fcm;

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> signUpUser({UserModel user}) async {
    String retVal = "error";
    try {
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
          email: user.email.trim(), password: user.password);
      UserModel _user = UserModel(
        uid: _authResult.user.uid,
        email: _authResult.user.email,
        username: user.username,
        role: user.role,
        profileUrl: user.profileUrl,
        createdAt: DateTime.now(),
        notifToken: await _fcm.getToken(),
      );
      String _returnString = await Database(uid: _user.uid).createUser(_user);
      if (_returnString == "success") {
        retVal = "success";
      }
    } on PlatformException catch (e) {
      retVal = e.message;
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> loginUserWithEmail({String email, String password}) async {
    String retVal = "error";

    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
    } on PlatformException catch (e) {
      retVal = e.message;
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}
