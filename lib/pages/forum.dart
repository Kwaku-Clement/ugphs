import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:tolerance/constants/constants.dart';
import 'package:tolerance/constants/variables.dart';
import 'package:tolerance/nav/custom_appbar.dart';
import 'package:tolerance/repository/dataRepository.dart';
import 'package:tolerance/repository/questions.dart';
import 'package:tolerance/widgets/card.dart';

import 'comment_screen.dart';

class Forum extends StatefulWidget {
  final VoidCallback openDrawer;
  final String id;
  const Forum({Key key, this.openDrawer, this.id}) : super(key: key);

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  final DataRepository repository = DataRepository();
  final dateFormat = DateFormat('MM-dd-yyyy');
  String currentUser = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    DocumentSnapshot userdoc =
        await userCollection.doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      currentUser = userdoc.get('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildHome(context);
  }

  Widget _buildHome(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        openDrawer: widget.openDrawer,
        title: 'Forum',
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: repository.getStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            return _buildList(context, snapshot.data.docs);
          }),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final forum = Question.fromSnapshot(snapshot);
    if (forum == null) {
      return Container();
    }

    return Container(
        child: InkWell(
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CardWidget(
            gradient: false,
            button: false,
            color: Colors.white60,
            child: ListTile(
              title: Column(
                children: [
                  Text(forum.name == null ? "" : forum.name, style: BoldStyle),
                  Divider(thickness: 2, color: Colors.black),
                  SizedBox(height: 5),
                  ReadMoreText(
                    forum.category == null ? "" : forum.category,
                    trimLines: 3,
                    colorClickableText: Colors.lightBlueAccent,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '...Read More',
                    trimExpandedText: '...Collapse',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(forum.createdBy == null ? '' : forum.createdBy),
                    Text(forum.createdAt == null
                        ? ""
                        : dateFormat.format(forum.createdAt)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        _navigate(BuildContext context) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommentScreen(
                        id: forum.id,
                        title: forum.name,
                      )));
        }

        _navigate(context);
      },
      highlightColor: Colors.green,
      splashColor: Colors.blue,
    ));
  }
}
