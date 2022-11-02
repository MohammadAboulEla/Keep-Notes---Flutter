import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextPlus extends StatelessWidget {

  final String text;
  final double fontSize;
  final bool isTitle;
  final FontWeight fontWeight;
  final Color color;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final double? letterSpacing;

  const TextPlus({
    Key? key, 
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.color = Colors.black,
    this.maxLines = 1,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.right,
    this.letterSpacing,
    this.isTitle = false,
  });

  @override
  Widget build(BuildContext context){
    return Text(
      text,
      style: GoogleFonts.getFont( isTitle ? 'Tajawal' : 'Cairo', fontSize: fontSize, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      textDirection: TextDirection.rtl,
    );
  }
}