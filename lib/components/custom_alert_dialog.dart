// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomAlertDialog extends StatelessWidget {
  VoidCallback? onPressed;
  String imagePath, text1, text2;

  CustomAlertDialog(
      {required this.onPressed,
      required this.imagePath,
      required this.text1,
      required this.text2});

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
                imagePath,
                color: Color(0xFF364960),
              )),
          SizedBox(
            height: 20,
          ),
          Text(text1,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Color(0xFF364960),
              )),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Container(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(
                    text2,
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF364960)),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF364960)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
