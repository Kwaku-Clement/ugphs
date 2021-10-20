import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tolerance/constants/constants.dart';
import 'package:tolerance/nav/custom_appbar.dart';
import 'package:tolerance/repository/questions.dart';
import 'package:tolerance/widgets/card.dart';

class LeaderboardPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const LeaderboardPage({Key key, this.openDrawer}) : super(key: key);

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  String title;
  String details;

  bool readMore = false;

  @override
  Widget build(BuildContext context) {
    return _buildHome(context);
  }

  Widget _buildHome(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        openDrawer: widget.openDrawer,
        title: 'Executives',
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: repository.getLeadersStream(),
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
    final question = Question.fromSnapshot(snapshot);
    if (question == null) {
      return Container();
    }
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: CardWidget(
                color: Colors.white,
                gradient: false,
                button: false,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(question.image),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(question.name == null ? "" : question.name,
                        style: BoldStyle),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      question.category == null ? "" : question.category,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
