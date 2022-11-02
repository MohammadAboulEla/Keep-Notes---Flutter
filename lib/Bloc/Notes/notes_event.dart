part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent {}

class AddNoteEvent extends NotesEvent {
  final String title;
  final String body;
  final DateTime created;
  final String category;

  AddNoteEvent(
      {required this.title,
      required this.body,
      required this.created,
      required this.category,
      });
}

class SelectedColorEvent extends NotesEvent {
  final int color;

  SelectedColorEvent(this.color);
}

class SelectedCategoryEvent extends NotesEvent {
  final String category;
  final Color categoryColor;

  SelectedCategoryEvent(this.category, this.categoryColor);
}

class ChangedListToGrid extends NotesEvent {
  final bool isList;

  ChangedListToGrid(this.isList);
}

class UpdateNoteEvent extends NotesEvent {
  final String title;
  final String body;
  final DateTime created;
  final String category;
  final int index;

  UpdateNoteEvent(
      {required this.title,
      required this.body,
      required this.created,
      required this.category,
      required this.index});
}

class DeleteNoteEvent extends NotesEvent {
  final int index;

  DeleteNoteEvent(this.index);
}

class LengthAllNotesEvent extends NotesEvent {
  final int length;

  LengthAllNotesEvent(this.length);
}
