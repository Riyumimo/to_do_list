part of 'note_bloc.dart';

@freezed
class NoteState with _$NoteState {
  const factory NoteState.initial() = _Initial;
  const factory NoteState.loaded(List<Note> note) = _Loaded;
  const factory NoteState.error(String message) = _Error;
}

// abstract class NoteState extends Equatable {
//   const NoteState();

//   @override
//   List<Object> get props => [];
// }

// class NoteInitial extends NoteState {}

// class NoteLoaded extends NoteState {
//   final List<Note>? note;

//   const NoteLoaded({this.note});
// }

// class NoteError extends NoteState {
//   final String message;

//   const NoteError(this.message);
// }
