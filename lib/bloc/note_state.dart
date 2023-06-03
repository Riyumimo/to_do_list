part of 'note_bloc.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoaded extends NoteState {
  final List<Note>? note;

  const NoteLoaded({this.note});
}

class NoteError extends NoteState {
  final String message;

  const NoteError(this.message);
}
