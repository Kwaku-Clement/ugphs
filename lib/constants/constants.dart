import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:tolerance/repository/dataRepository.dart';

const BoldStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    decorationStyle: TextDecorationStyle.double);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kInputTextFieldDecoration = InputDecoration(
  labelText: 'Enter your value',
  labelStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
);

final DataRepository repository = DataRepository();
final dateFormat = DateFormat('MM-dd-yyyy');

buildText(text) {
  return ReadMoreText(
    text,
    style: TextStyle(color: Colors.black),
    trimLines: 5,
    colorClickableText: Colors.pinkAccent,
    trimMode: TrimMode.Line,
    trimCollapsedText: 'Read More',
    trimExpandedText: 'Read Less',
  );
}

String getFilename(String url) {
  RegExp reqExp = new RegExp(r'.+(\/|%2F)(.+)\?.+');
  var matches = reqExp.allMatches(url);

  var match = matches.elementAt(0);
  return Uri.decodeFull(match.group(2));
}
