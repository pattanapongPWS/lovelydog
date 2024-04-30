import 'package:flutter/material.dart';

Future<void> normalDialog(BuildContext context, String message) async {
  showDialog(
      context: context,
      builder: (context) => SimpleDialog(
              title: Text(
                message,
                style: TextStyle(fontSize: 16),
              ),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'ตกลง',
                          style: TextStyle(color: Color(0xFFFF7544)),
                        ))
                  ],
                )
              ]));
}
