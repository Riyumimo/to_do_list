// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:to_do_list/db/db_helper.dart';
import 'package:to_do_list/models/note.dart';

part 'note_event.dart';
part 'note_bloc.freezed.dart';
part 'note_state.dart';

@injectable
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(const _Initial()) {
    on<_GetNoteEvent>((event, emit) async {
      emit(const _Initial());
      try {
        // await Future.delayed(Duration(seconds: 5));
        List<Note> task = await DatabaseHelper.queryDatabase();
        emit(_Loaded(task));
        if (state is _Loaded) {
          emit(const _Initial());
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
          emit(_Loaded(newtask));
        }
      } catch (e) {
        emit(_Error(e.toString()));
        print("Error$e");
      }
    });

    on<_AddNoteEvent>((event, emit) async {
      // final state = this.state;
      final result = await DatabaseHelper.insertDatabase(event.note);
      print(result);
      emit(const _Initial());
    });

    on<_DeleteNoteEvent>((event, emit) async {
      final state = this.state;
      if (state is _Loaded) {
        await DatabaseHelper.deleteNoteById(event.id);
        emit(const _Initial());
      }
    });
  }
}
