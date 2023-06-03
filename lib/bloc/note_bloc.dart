// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:to_do_list/db/db_helper.dart';
import 'package:to_do_list/models/note.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteInitial()) {
    on<GetNoteEvent>((event, emit) async {
      emit(NoteInitial());
      try {
        // await Future.delayed(Duration(seconds: 5));
        List<Note> task = await DatabaseHelper.queryDatabase();

        emit(NoteLoaded(note: task));

        if (state is NoteLoaded) {
          emit(NoteInitial());
          final date = event.date.toString();
          final newtask = task.where((element) {
            final data = element.dateTime?.split(" ")[0].split("-")[2];
            final date1 = date.split(" ")[0].split("-")[2];
            print(date);
            print(date1);
            return int.parse(data!) == int.parse(date1);
          }).toList();
          print(task.first.dateTime);
          print(event.date.toString());
          emit(NoteLoaded(note: newtask));
        }
      } catch (e) {
        print(e);
      }
    });

    on<AddNoteEvent>((event, emit) async {
      final state = this.state;
      if (state is NoteLoaded) {
        final result = await DatabaseHelper.insertDatabase(event.note);
        print(result);
        // List<Note> task = await DatabaseHelper.queryDatabase();
        // emit(NoteLoaded(note: task));
      }
      // note.add(event.note);
      // if (note.isEmpty) {
      //   emit(const NoteError('Note Is Empity'));
      // }
      // emit(NoteLoaded(note: note));
    });

    on<DeleteNoteEvent>((event, emit) async {
      final state = this.state;
      if (state is NoteLoaded) {
        await DatabaseHelper.deleteNoteById(event.id);
        List<Note> task = await DatabaseHelper.queryDatabase();
        emit(NoteInitial());
      }
    });
  }
}
