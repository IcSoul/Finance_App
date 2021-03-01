import 'package:flutter/material.dart';

Widget formTextFieldContainer(Widget widget) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    child: widget
  );
}

Widget formRadioFieldHeader(String value) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.only(top: 30),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 14
        ),
      ),
    ),
  );
}