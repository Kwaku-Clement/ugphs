import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tolerance/constants/constants.dart';
import 'package:tolerance/constants/extension.dart';
import 'package:tolerance/constants/rounded_button.dart';
import 'package:tolerance/nav/mainpage.dart';

class SignIn extends StatefulWidget {
  static const String id = 'signin_screen';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKeyReset = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _spinner = false;
  final bool login = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: ModalProgressHUD(
            inAsyncCall: _spinner,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Flexible(
                    //   child: Hero(
                    //     tag: 'logo',
                    //     child: Container(
                    //       height: 200.0,
                    //       child: Image.asset('assets/images/logo.png'),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 48.0,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Expanded(
                        child: TextFormField(
                          key: ValueKey('email'),
                          autocorrect: false,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isValidEmail) {
                              return null;
                            } else {
                              return 'Please, enter a valid email';
                            }
                          },
                          decoration: kInputTextFieldDecoration.copyWith(
                              labelText: 'Email'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Expanded(
                        child: TextFormField(
                          key: ValueKey('password'),
                          autocorrect: false,
                          controller: _passwordController,
                          obscureText: _isHidden,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value.length >= 6) {
                              return null;
                            } else {
                              return 'Password should not be less than 6 characters ';
                            }
                          },
                          decoration: kInputTextFieldDecoration.copyWith(
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isHidden = !_isHidden;
                                });
                              },
                              child: Icon(_isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () => openEditDialog(),
                              child: Text("Forgot Password?"))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(right: 16.0, left: 16.0),
                      child: RoundedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _spinner = true;
                            });
                          } else {
                            setState(() {
                              _spinner = false;
                            });
                          }
                          final user = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                          try {
                            if (user != null) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => MainPage()),
                                  (route) => false);
                            }
                            setState(() {
                              _spinner = false;
                            });
                          } catch (e) {
                            var snackbar = SnackBar(
                                content: Text(
                              e.toString(),
                            ));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                            setState(() {
                              _spinner = false;
                            });
                          }
                        },
                        title: 'SIGN IN',
                        colour: Colors.indigoAccent,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),
          )),
      // ),
    );
  }

  openEditDialog() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: Form(
              key: _formKeyReset,
              child: ModalProgressHUD(
                inAsyncCall: _spinner,
                child: Container(
                  height: 250,
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Expanded(
                          child: TextFormField(
                            key: ValueKey('email'),
                            autocorrect: false,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isValidEmail) {
                                return null;
                              } else {
                                return 'Please, enter a valid email';
                              }
                            },
                            decoration: kInputTextFieldDecoration.copyWith(
                                labelText: 'Email'),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      InkWell(
                        onTap: () {
                          resetPassword();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 40,
                          decoration: BoxDecoration(color: Colors.blue),
                          child: Center(
                            child: Text(
                              'Reset',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void resetPassword() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _spinner = true;
      });
    } else {
      setState(() {
        _spinner = false;
      });
    }
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailController.text);
    Fluttertoast.showToast(msg: "New password has been sent to your email");
    Navigator.pop(context);
  }
}
