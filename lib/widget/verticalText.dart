import 'package:flutter/material.dart';

class VerticalText extends StatefulWidget {
  final String title;

  const VerticalText({Key key, @required this.title}): super(key: key);
  @override
  _VerticalTextState createState() => _VerticalTextState();
}

class _VerticalTextState extends State<VerticalText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 10),
      child: RotatedBox(
          quarterTurns: -1,
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w900,
            ),
          )),
    );
  }
}