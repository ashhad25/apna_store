// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  String text;
  EdgeInsets padding;
  CustomAppBar({super.key, required this.text, required this.padding});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  Size get preferredSize => const Size.fromHeight(200);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            blurStyle: BlurStyle.normal,
            offset: Offset(0, 3),
          )
        ],
        color: Color(0xFF364960),
      ),
      child: Padding(
        padding: widget.padding,
        child: Text(
          widget.text,
          style: GoogleFonts.poppins(fontSize: 35, color: Colors.white),
        ),
      ),
    );
  }
}
