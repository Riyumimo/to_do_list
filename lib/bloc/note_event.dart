part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class AddNoteEvent extends NoteEvent {
  final Note note;

  const AddNoteEvent({required this.note});
}

class GetNoteEvent extends NoteEvent {
  final DateTime date;

  const GetNoteEvent(this.date);
}

class DeleteNoteEvent extends NoteEvent {
  final int id;
  const DeleteNoteEvent(this.id);
}
