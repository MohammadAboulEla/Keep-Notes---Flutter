import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:keep_notes/Bloc/Notes/notes_bloc.dart';
import 'package:keep_notes/Bloc/general/general_bloc.dart';
import 'package:keep_notes/Helpers/extensions.dart';
import 'package:keep_notes/Helpers/modal_warning.dart';
import 'package:keep_notes/Models/NoteModels.dart';
import 'package:keep_notes/Screens/AddNotePage.dart';
import 'package:keep_notes/Screens/ShowNotePage.dart';
import 'package:keep_notes/Widgets/text_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePage extends StatefulWidget{

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late ScrollController _scrollController;
  String appBarTitle = 'المدونة الشخصية';

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollControllerApp);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(_scrollControllerApp);
    super.dispose();
  }


  void _scrollControllerApp(){

    if(_scrollController.offset > 170){
      BlocProvider.of<GeneralBloc>(context).add(IsScrollTopAppBarEvent(true));
    }else{
      BlocProvider.of<GeneralBloc>(context).add(IsScrollTopAppBarEvent(false));
    }

  }
  String _analyzeNoteNumbers(NotesState state){
    String text;
    switch(state.noteLength) {
      case 0: {  text = 'أضف موضوعًا'; }
      break;
      case 1: {  text = 'موضوع واحد'; }
      break;
      case 2: {  text = 'موضوعين'; }
      break;
      default: { text = '${state.noteLength.toArabicDigits()} موضوعات';}
      break;
    }
    return text;
  }

  @override
  Widget build(BuildContext context){

    
    final noteBloc = BlocProvider.of<NotesBloc>(context);
    final box = Hive.box<NoteModels>('keepNote');
    return Scaffold(
      backgroundColor: Color(0xffF2F3F7),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            BlocBuilder<GeneralBloc, GeneralState>(
              builder: (context, state) => SliverAppBar(
                flexibleSpace: FlexibleSpaceBar(
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 100),
                    opacity: state.isScrollAppBar ? 1 : 0,
                    child: TextPlus(
                      text: appBarTitle, isTitle: true, fontSize: 20, color: Colors.black)
                  ),
                  background: Container(
                    color: Color(0xffF2F3F7),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                        opacity: !state.isScrollAppBar ? 1 : 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextPlus(
                            text: appBarTitle,
                            isTitle: true, 
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                          BlocBuilder<NotesBloc, NotesState>(
                            builder: (context, state) => TextPlus(
                              text: _analyzeNoteNumbers(state),
                              fontWeight: FontWeight.w500,
                              fontSize: 22, 
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                expandedHeight: MediaQuery.of(context).size.height * .4,
                pinned: false,
                elevation: 0,
                backgroundColor: Color(0xffF2F3F7),
                leading: IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    
                  },
                  icon: Icon(Icons.menu_rounded, color: Colors.black),  
                ),
                actions: [
                  BlocBuilder<NotesBloc, NotesState>(
                    builder: (context, state) => IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        noteBloc.add(ChangedListToGrid(!state.isList));
                      }, 
                      icon: Icon( state.isList ? Icons.view_agenda_outlined : Icons.grid_view_rounded, color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (_, Box box, __){

                    noteBloc.add(LengthAllNotesEvent(box.length));
              
                    if( box.values.isEmpty ){
                      return Center(
                        child: TextPlus(text: 'المحرر فارغ', color: Colors.grey),
                      );
                    }
                    
                    return BlocBuilder<NotesBloc, NotesState>(
                      builder: (_, state) {
                                
                        return state.isList 
                        ? Column(
                          children: [
                            _ListNotes(),
                            state.noteLength == 5 
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height * .1,
                              )
                            : const SizedBox()

                          ],
                        )
                        : _GridViewNote();
                                
                      } 
                    );
              
                  },
                ),
              ])
            )
          ],
        ),
      ),
      floatingActionButton: InkWell(
        borderRadius: BorderRadius.circular(50.0),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddNotePage())),
        child: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blueGrey,//Color(0xff1977F3),
          child: const Icon(Icons.bookmark_add, color: Colors.white),
        ),
      ),
    );
  }

}

class _ListNotes extends StatelessWidget {

  const _ListNotes({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {

    final noteBloc = BlocProvider.of<NotesBloc>(context);
    final box = Hive.box<NoteModels>('keepNote');

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: box.values.length,
      itemBuilder: (_, i){
    
        NoteModels note = box.getAt(i)!;
    
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ShowNotePage(note: note, index: i ))),
          onLongPress: (){
            ok(){noteBloc.add( DeleteNoteEvent(i));}
            modalWarning(context, "حذف الموضوع",cancelButton: true,function: ok);
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(bottom: 15.0),
            //height: 110,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextPlus(text: note.category!, fontSize: 10, color: Colors.blueGrey ),
                    TextPlus(isTitle: false,text: note.title.toString(), fontWeight: FontWeight.bold ),
                  ],
                ),
                //SizedBox(height: 10.0),
                TextPlus(
                  text: note.body.toString(),
                  fontSize: 12,
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Icon(Icons.circle, color: Color(note.color!), size: 15)
                    // ),
                    TextPlus(text: timeago.format(note.created!), fontSize: 12, color: Colors.blueGrey ),
                  ],
                )
              ],
            ),
          ),
        ); 
      },
    );
  }
}


class _GridViewNote extends StatelessWidget {

  const _GridViewNote({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context){ 

    final noteBloc = BlocProvider.of<NotesBloc>(context);
    final box = Hive.box<NoteModels>('keepNote');
    
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        //childAspectRatio: 4 / 2,
        crossAxisSpacing: 10,
        maxCrossAxisExtent: 200,
        mainAxisExtent: 200
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: box.values.length,
      itemBuilder: (_, i){

        NoteModels note = box.getAt(i)!;

        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ShowNotePage(note: note, index: i ))),
          onLongPress: (){
            ok(){noteBloc.add( DeleteNoteEvent(i));}
            modalWarning(context, "حذف الموضوع",cancelButton: true,function: ok);
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: TextPlus(text: note.title.toString(), fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 2.0),
                Expanded(
                  child: Container(
                    child: TextPlus(
                      text: note.body.toString(),
                      fontSize: 12,
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextPlus(text: timeago.format(note.created!), fontSize: 12, color: Colors.blueGrey ),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Icon(Icons.circle, color: Color(note.color!), size: 15)
                    // ),
                  ],
                )
              ],
            ),
          ),
        ); 
      }
    );
  }
}


// class _GridViewNote extends StatelessWidget {
//
//   const _GridViewNote({Key? key}): super(key: key);
//
//   @override
//   Widget build(BuildContext context){
//
//     final noteBloc = BlocProvider.of<NotesBloc>(context);
//     final box = Hive.box<NoteModels>('keepNote');
//
//     return GridView.builder(
//         physics: const NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//             childAspectRatio: 2 / 2,
//             crossAxisSpacing: 10,
//             maxCrossAxisExtent: 200,
//             mainAxisExtent: 250
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//         itemCount: box.values.length,
//         itemBuilder: (_, i){
//
//           NoteModels note = box.getAt(i)!;
//
//           return GestureDetector(
//             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ShowNotePage(note: note, index: i ))),
//             child: Dismissible(
//               key: Key(note.title!),
//               direction: DismissDirection.endToStart,
//               background: Container(),
//               secondaryBackground: Container(
//                 padding: EdgeInsets.only(bottom: 35.0),
//                 margin: EdgeInsets.only(bottom: 15.0),
//                 alignment: Alignment.bottomCenter,
//                 decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0))
//                 ),
//                 child: Icon(Icons.delete, color: Colors.white, size: 40),
//               ),
//               onDismissed: (direction) => noteBloc.add( DeleteNoteEvent(i) ),
//               child: Container(
//                 padding: EdgeInsets.all(10.0),
//                 margin: EdgeInsets.only(bottom:  .0),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0),
//                     color: Colors.white
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                         child: TextPlus(text: note.title.toString(), fontWeight: FontWeight.bold)
//                     ),
//                     SizedBox(height: 2.0),
//                     Expanded(
//                       child: Container(
//                           child: TextPlus(
//                             text: note.body.toString(),
//                             fontSize: 12,
//                             color: Colors.grey,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 3,
//                           )
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextPlus(text: timeago.format(note.created!), fontSize: 12, color: Colors.blueGrey ),
//                         // Align(
//                         //   alignment: Alignment.centerRight,
//                         //   child: Icon(Icons.circle, color: Color(note.color!), size: 15)
//                         // ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }
//     );
//   }
// }

