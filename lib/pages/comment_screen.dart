import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tolerance/constants/constants.dart';
import 'package:tolerance/constants/variables.dart';
import 'package:tolerance/service/database.dart';
import 'package:tolerance/widgets/discussion_tile.dart';

class CommentScreen extends StatefulWidget {
  final String id;
  final String title;

  const CommentScreen({
    Key key,
    this.id,
    this.title,
  }) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController messageTextController = TextEditingController();
  Stream<QuerySnapshot> _chats;

  String messageText;
  String currentUser = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    Database().getChats(widget.id).then((val) {
      setState(() {
        _chats = val;
      });
    });
  }

  void getCurrentUser() async {
    DocumentSnapshot userdoc =
        await userCollection.doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      currentUser = userdoc.get('username');
    });
  }

  Widget _chatMessages() {
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return DiscussionTile(
                    message: snapshot.data.docs[index].get('message'),
                    sender: snapshot.data.docs[index].get('sender'),
                  );
                })
            : Container();
      },
    );
  }

  _sendMessage() {
    if (messageTextController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageTextController.text,
        "sender": currentUser,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      Database().sendMessage(widget.id, chatMessageMap);

      setState(() {
        messageTextController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum discussion'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        child: Stack(
          children: [
            _chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Colors.grey[700],
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Send a message ...",
                            hintStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: Icon(Icons.send, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
