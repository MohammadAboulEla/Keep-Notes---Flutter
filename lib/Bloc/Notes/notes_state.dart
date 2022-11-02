part of 'notes_bloc.dart';

@immutable
class NotesState {

  final String category;
  final Color categoryColor;
  final bool isList;
  final int noteLength;

  const NotesState({
    this.category = 'غير محدد',
    this.categoryColor = Colors.grey,
    this.isList = true,
    this.noteLength = 0,
  });

  NotesState copyWith({ int? color, String? category, Color? colorCategory, bool? isList, int? noteLength, })
    => NotesState(
      category: category ?? this.category,
      categoryColor: colorCategory ?? this.categoryColor,
      isList: isList ?? this.isList,
      noteLength: noteLength ?? this.noteLength,
  );

}

