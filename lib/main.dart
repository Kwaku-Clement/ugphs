import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tolerance/authentication/signup_screen.dart';
import 'package:tolerance/nav/mainpage.dart';

import 'authentication/login_screen.dart';
import 'provider/provider_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ModelNotifier>(
          create: (context) => ModelNotifier(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return MainPage();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Unknown Error Occurred'),
                );
              } else {
                return SignIn();
              }
            },
          )),
    );
  }
}
