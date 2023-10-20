// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
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
            final data = element.dateTime?.split(" ")[0];
            final date1 = date.split(" ")[0];
            // print(date);
            // print(date1);
            return data == date1;
          }).toList();
          // print(task.first.dateTime);
          // print(event.date.toString());
          emit(_Loaded(newtask));
        }
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });

    on<_AddNoteEvent>((event, emit) async {
      // final state = this.state;
      List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
      final note = event.note;
      if (repeatList.contains(note.repeat)) {
        switch (note.repeat) {
          case "None":
            await DatabaseHelper.insertDatabase(event.note);
            emit(const _Initial());
            break;
          case "Daily":
            List<Note> newNote = [];
            String format = 'yyyy-MM-dd HH:mm:ss';

            DateTime lastDayOfMoth =
                DateTime(DateTime.now().year, DateTime.now().month, 0);
            DateTime dateTime = DateFormat(format).parse(note.dateTime!);
            for (int i = 0; i < lastDayOfMoth.day; i++) {
              DateTime tanggal = dateTime.add(Duration(days: i * 1));
              newNote.add(Note(
                  colors: note.colors,
                  title: note.title,
                  isComplete: note.isComplete,
                  note: note.note,
                  dateTime: tanggal.toString(),
                  startTime: note.startTime,
                  endTime: note.endTime,
                  remind: note.remind,
                  repeat: note.repeat));
            }
            for (var note in newNote) {
              await DatabaseHelper.insertDatabase(note);
            }

            emit(const _Initial());

            break;
          case "Weekly":
            List<Note> newNote = [];
            String format = 'yyyy-MM-dd HH:mm:ss';
            DateTime dateTime = DateFormat(format).parse(note.dateTime!);
            for (int i = 0; i < 10; i++) {
              DateTime tanggal = dateTime.add(Duration(days: i * 7));
              newNote.add(Note(
                  colors: note.colors,
                  title: note.title,
                  isComplete: note.isComplete,
                  note: note.note,
                  dateTime: tanggal.toString(),
                  startTime: note.startTime,
                  endTime: note.endTime,
                  remind: note.remind,
                  repeat: note.repeat));
            }
            for (var note in newNote) {
              await DatabaseHelper.insertDatabase(note);
            }

            emit(const _Initial());
            break;
          case "Monthly":
            List<Note> newNote = [];
            String format = 'yyyy-MM-dd HH:mm:ss';

            DateTime dateTime = DateFormat(format).parse(note.dateTime!);
            for (int i = 0; i < 12; i++) {
              DateTime lastDayOfMoth =
                  DateTime(DateTime.now().year, DateTime.now().month + i, 0);

              DateTime tanggal =
                  dateTime.add(Duration(days: i * lastDayOfMoth.day));
              newNote.add(Note(
                  colors: note.colors,
                  title: note.title,
                  isComplete: note.isComplete,
                  note: note.note,
                  dateTime: tanggal.toString(),
                  startTime: note.startTime,
                  endTime: note.endTime,
                  remind: note.remind,
                  repeat: note.repeat));
            }
            for (var note in newNote) {
              await DatabaseHelper.insertDatabase(note);
            }

            emit(const _Initial());

            break;
          default:
            emit(const _Initial());
        }
      }
    });

    on<_DeleteNoteEvent>((event, emit) async {
      final state = this.state;
      if (state is _Loaded) {
        await DatabaseHelper.deleteNoteById(event.id);
        emit(const _Initial());
      }
    });

    on<_UpdateNoteEvent>((event, emit) async {
      if (state is _Loaded) {
        await DatabaseHelper.updateNoteById(event.id, event.isComplete);
        emit(const _Initial());
      }
    });
  }
}
