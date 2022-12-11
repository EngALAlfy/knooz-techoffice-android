import 'package:flutter/material.dart';

class DividerWithText extends StatefulWidget {
  final String text;
  DividerWithText({Key key, @required this.text}) : super(key: key);

  @override
  State<DividerWithText> createState() => _DividerWithTextState();
}

class _DividerWithTextState extends State<DividerWithText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(endIndent: 10, indent: 10, color: Colors.grey),
          ),
          Text(
            widget.text,
            style: TextStyle(color: Colors.grey),
          ),
          Expanded(
            child: Divider(endIndent: 10, indent: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
