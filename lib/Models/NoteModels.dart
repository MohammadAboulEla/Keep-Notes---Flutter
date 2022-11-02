import 'package:hive/hive.dart';

part 'NoteModels.g.dart';

// command
// flutter packages pub run build_runner build


@HiveType(typeId: 1)
class NoteModels {

  @HiveField(0)
  String? title; // ok

  @HiveField(1)
  String? body; // ok

  @HiveField(2)
  String? category; //ok

  @HiveField(3)
  DateTime? created; //ok


  // NoteModels({ this.title, this.body, this.isComplete, this.color, this.category, this.created });
  NoteModels({ this.title, this.body, this.category, this.created });

}
