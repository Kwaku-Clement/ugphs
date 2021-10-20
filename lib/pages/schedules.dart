import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:tolerance/constants/constants.dart';
import 'package:tolerance/constants/variables.dart';
import 'package:tolerance/nav/custom_appbar.dart';
import 'package:tolerance/repository/questions.dart';
import 'package:tolerance/widgets/card.dart';

class Schedules extends StatefulWidget {
  final VoidCallback openDrawer;

  const Schedules({Key key, this.openDrawer}) : super(key: key);

  @override
  _SchedulesState createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
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
        title: 'Schedules',
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: repository.getScheduleStream(),
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
                  title: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question.name == null ? "" : question.name,
                            style: BoldStyle),
                        ReadMoreText(
                          question.category == null ? "" : question.category,
                          trimLines: 3,
                          colorClickableText: Colors.lightBlueAccent,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '...Read More',
                          trimExpandedText: '...Collapse',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 3),
                            Text(user.displayName == null
                                ? ''
                                : user.displayName),
                          ],
                        ),
                        Text(question.createdAt == null
                            ? ""
                            : dateFormat.format(question.createdAt)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
