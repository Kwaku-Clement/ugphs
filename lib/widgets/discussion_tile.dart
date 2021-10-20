import 'package:flutter/material.dart';

class DiscussionTile extends StatelessWidget {
  final String message;
  final String sender;
  final String date;

  DiscussionTile({
    this.message,
    this.sender,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: ListTile(
          title: Text(message,
              style: TextStyle(fontSize: 12.0, color: Colors.black54)),
          subtitle: Column(
            children: [
              Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  child: Text(
                    sender,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              Text(
                date,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
