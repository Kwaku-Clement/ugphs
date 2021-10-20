import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String text;
  final Function onPressed;

  const SectionHeader({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 20,
          width: 4,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
              color: Color(0xFF343434)),
        ),
        Text(
          text,
          style: TextStyle().copyWith(
            fontSize: 17.0,
          ),
        ),
        Spacer(),
        CupertinoButton(
          child: Icon(Icons.arrow_right, color: Colors.lightBlue),
          onPressed: onPressed,
        )
      ],
    );
  }
}
