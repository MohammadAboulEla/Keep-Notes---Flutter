import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:keep_notes/Bloc/Notes/notes_bloc.dart';
import 'package:keep_notes/Bloc/general/general_bloc.dart';
import 'package:keep_notes/Models/NoteModels.dart';
import 'package:keep_notes/Screens/HomePage.dart';
import 'package:timeago/timeago.dart' as timeago;



void main() async {


  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelsAdapter());
  //await Hive.deleteBoxFromDisk('keepNote');
  await Hive.openBox<NoteModels>('keepNote');

  timeago.setLocaleMessages('ar', timeago.ArMessages());
  timeago.setDefaultLocale('ar');

  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark ));

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NotesBloc()),
        BlocProvider(create: (context) => GeneralBloc()),
      ],
      child: MaterialApp(
        title: 'Islamic Notes',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}