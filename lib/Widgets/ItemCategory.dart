import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_notes/Bloc/Notes/notes_bloc.dart';

import 'text_plus.dart';

class ItemCategory extends StatelessWidget {
  
  final Color color;
  final String text;
  final VoidCallback onPressed;

  const ItemCategory({ required this.color, required this.text, required this.onPressed });
  

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        margin: EdgeInsets.only(bottom: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  child: BlocBuilder<NotesBloc, NotesState>(
                    builder: (_, state) 
                      => state.category == text ? Icon(Icons.check) : Container(),
                  ),
                )
              ],
            ),
            Row(
              children: [
                TextPlus(text: text, fontSize: 14 ),
                SizedBox(width: 10.0),
                Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                      border: Border.all(color: color, width: 4.0),
                      borderRadius: BorderRadius.circular(7.0)
                  ),
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }
}