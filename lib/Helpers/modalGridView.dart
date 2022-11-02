

import 'package:flutter/material.dart';
import 'package:keep_notes/Widgets/text_plus.dart';


void showModalGridView( BuildContext ctx ){

  showDialog(
    context: ctx,
    barrierColor: Colors.white60,
    useSafeArea: true,
    builder: (context) 
      => AlertDialog(
        content: Container(
          height: 200,
          child: Column(
            children: [
              TextPlus(text: 'Options')
            ],
          ),
        ),
      ),
  );

}