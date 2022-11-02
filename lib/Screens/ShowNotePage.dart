import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_notes/Bloc/Notes/notes_bloc.dart';
import 'package:keep_notes/Helpers/modalSelectCategory.dart';
import 'package:keep_notes/Models/NoteModels.dart';
import 'package:keep_notes/Widgets/TextFieldBody.dart';
import 'package:keep_notes/Widgets/TextFieldTitle.dart';
import 'package:keep_notes/Widgets/text_plus.dart';

import '../Helpers/modal_warning.dart';


class ShowNotePage extends StatefulWidget {

  final NoteModels note;
  final int index;

  const ShowNotePage({required this.note, required this.index});

  @override
  _ShowNotePageState createState() => _ShowNotePageState();
}

class _ShowNotePageState extends State<ShowNotePage> {

  late TextEditingController _titleController;
  late TextEditingController _noteController;


  @override
  void initState() {

    _titleController = TextEditingController(text: widget.note.title);
    _noteController = TextEditingController(text: widget.note.body);

    //BlocProvider.of<NotesBloc>(context).add(SelectedColorEvent(widget.note.color!));
    BlocProvider.of<NotesBloc>(context).add(SelectedCategoryEvent(widget.note.category!, BlocProvider.of<NotesBloc>(context).state.categoryColor ));


    super.initState();
  }

  @override
  void dispose() {
    clearText();
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void clearText(){
    _titleController.clear();
    _noteController.clear();
  }

  @override
  Widget build(BuildContext context)
  {
    final noteBloc = BlocProvider.of<NotesBloc>(context);

    return Scaffold(
      backgroundColor: Color(0xffF2F3F7),
      appBar: AppBar(
        backgroundColor: Color(0xffF2F3F7),
        elevation: 0,
        //title: TextPlus(isTitle: true,text: widget.note.title!, fontWeight: FontWeight.w500, fontSize: 18 ),
        title: TextPlus(isTitle: true,text: 'معاينة الموضوع', fontWeight: FontWeight.w500, fontSize: 18 ),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: TextPlus(text: 'إلغاء', fontSize: 15, color: Colors.blueGrey,)
          )
        ),
        actions: [
          InkWell(
            onTap: () {
              if(_titleController.text.trim().isNotEmpty && _noteController.text.trim().isNotEmpty){

                noteBloc.add( UpdateNoteEvent(
                    title: _titleController.text,
                    body: _noteController.text,
                    created: DateTime.now(),
                    category: noteBloc.state.category,
                    index: widget.index
                ));
                clearText();
                Navigator.pop(context);

              }else{
                modalWarning(context, 'يجب تحديد العنوان والموضوع');
              }

            },
            child: Container(
              alignment: Alignment.center,
              width: 60,
              child: TextPlus(text: 'حفظ', fontSize: 15, color: Colors.blueGrey,)
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                TextTitle(controller: _titleController,),
                SizedBox(height: 10.0),
                TextWriteNote(controller: _noteController),
                SizedBox(height: 10.0),
                _Category(),
                SizedBox(height: 10.0),
                //SelectedColors(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _Category extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      height: 60,
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffF6F8F9)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            alignment: Alignment.center,
            height: 40,
            width: 180,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 7, spreadRadius: -5.0)
                ]
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () => showDialogBottomFrave(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<NotesBloc, NotesState>(
                      builder: (_, state)
                      => Container(
                        height: 18,
                        width: 18,
                        decoration: BoxDecoration(
                            border: Border.all(color: state.categoryColor, width: 4.0),
                            borderRadius: BorderRadius.circular(7.0)
                        ),
                      ),
                    ),
                    BlocBuilder<NotesBloc, NotesState>(
                        builder: (_, state) => TextPlus(text: state.category, fontWeight: FontWeight.w600 )
                    ),
                    Icon(Icons.expand_more)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextPlus(text: 'التصنيف'),
          ),

        ],
      ),
    );
  }
}


