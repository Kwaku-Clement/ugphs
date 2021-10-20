import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tolerance/constants/constants.dart';
import 'package:tolerance/constants/variables.dart';
import 'package:tolerance/model/userModel.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // UserModel user;
  User currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        child: StreamBuilder<Object>(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              final user = UserModel.fromDocumentSnapshot(doc: snapshot.data);
              return ListView(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple[800],
                            Colors.deepPurpleAccent
                          ],
                        ),
                      ),
                      child: Column(children: [
                        SizedBox(
                          height: 70.0,
                        ),
                        CircleAvatar(
                          radius: 65.0,
                          backgroundImage: NetworkImage(user.profileUrl == null
                              ? 'http://romanroadtrust.co.uk/wp-content/uploads/2018/01/profile-icon-png-898-300x300.png'
                              : user.profileUrl),
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          user.username == null ? "" : user.username,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          user.email == null ? "" : user.email,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ]),
                    ),
                  ),
                  Expanded(
                      child: Card(
                          child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(children: [
                            Text(
                              'Birthday',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'April 7th',
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            )
                          ]),
                        ),
                        Container(
                            child: Column(
                          children: [
                            Text(
                              'Joined',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              '19 yrs',
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            )
                          ],
                        )),
                      ],
                    ),
                  ))),
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: Colors.grey[200],
                      child: Center(
                          child: Card(
                              margin: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                              child: Container(
                                  width: 310.0,
                                  height: 290.0,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Information",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey[300],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.home,
                                              color: Colors.blueAccent[400],
                                              size: 35,
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Guild",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Text(
                                                  "FairyTail, Magnolia",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[400],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.auto_awesome,
                                              color: Colors.yellowAccent[400],
                                              size: 35,
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Magic",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Text(
                                                  "Spatial & Sword Magic, Telekinesis",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[400],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              color: Colors.pinkAccent[400],
                                              size: 35,
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Loves",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Text(
                                                  "Eating cakes",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[400],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.people,
                                              color: Colors.lightGreen[400],
                                              size: 35,
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Team",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Text(
                                                  "Team Natsu",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[400],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )))),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            }),
      ),
    );
  }
}
