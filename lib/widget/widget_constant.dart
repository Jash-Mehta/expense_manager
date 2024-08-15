import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget datePick(context, bool time, {title, onpress, color}) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(02), // Set border radius here
      ),
    ),
    onPressed: onpress,
    icon: Icon(
      time ? CupertinoIcons.clock : Icons.calendar_month,
      color: Theme.of(context).highlightColor,
    ),
    label: Text(
      title != null ? title : "Date",
      style: TextStyle(fontSize: 14, color: color),
    ),
  );
}
