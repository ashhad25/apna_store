// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomAlertDialog extends StatelessWidget {
  Function? onRetry;

  CustomAlertDialog({this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: 200,
              child: Image.asset(
                'assets/images/no_connection.png',
                color: Color(0xFF364960),
              )),
          Container(
            width: 200,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                onRetry!();
              },
              child: Text(
                'RETRY',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF364960)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
