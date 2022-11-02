import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TextTitle extends StatelessWidget {
  
  final TextEditingController controller;

  const TextTitle({ required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: TextField(
        maxLength: 20,
        textDirection: TextDirection.rtl,
        controller: controller,
        style: GoogleFonts.getFont('Inter'),
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: "",
          hintTextDirection: TextDirection.rtl,
          hintText: 'عنوان',
          contentPadding: EdgeInsets.only(right: 10.0)
        ),
      ),
    );
  }
}
