import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tolerance/constants/constants.dart';
import 'package:tolerance/constants/extension.dart';
import 'package:tolerance/constants/variables.dart';

class SignUp extends StatefulWidget {
  static const String id = 'signUp_screen';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPass = TextEditingController();

  final _auth = FirebaseAuth.instance;

  static const values = <String>['User', 'Admin'];
  String selectedValue = values.first;
  final selectedColor = Colors.blue;
  final unSelectedColor = Colors.grey;

  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _spinner = false;
  final bool login = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crreate User'),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: ModalProgressHUD(
                inAsyncCall: _spinner,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 12.0, bottom: 12),
                        child: Expanded(
                          child: TextFormField(
                            key: ValueKey('username'),
                            autocorrect: false,
                            controller: _usernameController,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value.isValidName) {
                                return null;
                              } else {
                                return 'Please, enter your full namee';
                              }
                            },
                            decoration: kInputTextFieldDecoration.copyWith(
                                labelText: 'Full Name'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12.0, bottom: 12),
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
                        padding: EdgeInsets.only(top: 12.0, bottom: 12),
                        child: Expanded(
                          child: TextFormField(
                            key: ValueKey('password'),
                            autocorrect: false,
                            obscureText: _isHidden,
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value.length >= 8) {
                                return null;
                              } else {
                                return 'Password should not be less than 8 characters ';
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
                          padding: EdgeInsets.only(top: 12.0, bottom: 12),
                          child: TextFormField(
                            key: ValueKey('confirmPassword'),
                            controller: _confirmPass,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _isHidden,
                            decoration: kInputTextFieldDecoration.copyWith(
                              prefixIcon: Icon(Icons.lock),
                              labelText: 'Confirm Password',
                            ),
                            validator: (value) {
                              FocusScope.of(context).unfocus();

                              if (value != _passwordController.text) {
                                return 'Password do not match';
                              }
                              if (value.isValidPassword) {
                                return null;
                              }
                              return null;
                            },
                          )),
                      Divider(height: 2, color: Colors.grey[700]),
                      SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          'User Role',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 12.0, bottom: 12),
                          child: Expanded(
                            child: Column(
                              children: values.map(
                                (value) {
                                  final selected = this.selectedValue == value;
                                  final color = selected
                                      ? selectedColor
                                      : unSelectedColor;
                                  return RadioListTile(
                                    title: Text(
                                      value,
                                      style: TextStyle(color: color),
                                    ),
                                    activeColor: selectedColor,
                                    value: value,
                                    groupValue: selectedValue,
                                    onChanged: (value) => setState(
                                        () => this.selectedValue = value),
                                  );
                                },
                              ).toList(),
                            ),
                          )),
                      Divider(height: 2, color: Colors.grey[700]),
                      SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
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
                          try {
                            final newUser = await _auth
                                .createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text)
                                .then((value) => {
                                      userCollection.doc(value.user.uid).set({
                                        'username': _usernameController.text,
                                        'email': _emailController.text,
                                        'password': _passwordController.text,
                                        'uid': value.user.uid,
                                        'role': selectedValue,
                                        'createdAt': Timestamp.now(),
                                      })
                                    });

                            if (newUser != null) {
                              Navigator.pop(context);
                            }
                            setState(() {
                              _spinner = false;
                            });
                          } catch (e) {
                            print(e);
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
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 100),
                          child: Text(
                            "Create User",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))),
      ),
    );
  }
}
