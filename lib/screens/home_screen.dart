import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/screens/add_task_page.dart';
import 'package:to_do_list/service/notifi_helper.dart';
import 'package:to_do_list/theme.dart';

import '../bloc/note_bloc.dart';
import '../cubit/theme_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NotifiHelper? _notifiHelper;
  @override
  void initState() {
    NotifiHelper notifiHelper = NotifiHelper();
    notifiHelper.initializeNotification();
    _notifiHelper = notifiHelper;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeCubit>(context);
    DateTime selectedDate = DateTime.now();
    return Scaffold(
      appBar: AppBar(
          surfaceTintColor: Theme.of(context).canvasColor,
          centerTitle: true,
          title: Text(
            'HomeScreen',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.person_crop_circle))
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          theme.toggleTheme();
          _notifiHelper!
              .displayNotification(title: "HomeScreen", body: "First Notify");
          _notifiHelper!.scheduledNotification();
          // await DatabaseHelper.dropTable();
          // await DatabaseHelper.deleteDatabse();
        },
        child: const Icon(CupertinoIcons.color_filter),
      ),
      body: SafeArea(
        child: Column(children: [
          _taskBar(),
          _dateBar(selectedDate),
          const SizedBox(
            height: 10,
          ),
          _showDate(selectedDate),
        ]),
      ),
    );
  }

  _showDate(DateTime selecteedDate) {
    return BlocBuilder<NoteBloc, NoteState>(
      // bloc: BlocProvider.of<NoteBloc>(context)..add(GetNoteEvent()),
      builder: (context, state) {
        if (state is NoteInitial) {
          const Center(child: CircularProgressIndicator());
        }
        if (state is NoteLoaded) {
          final note = state.note;
          if (note!.isEmpty) {
            return Container();
          }
          print("banyak note" + note.length.toString());
          return note.length > 1
              ? Expanded(
                  child: ListView.builder(
                    itemCount: note.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          trailing: IconButton(
                              onPressed: () {
                                context
                                    .read<NoteBloc>()
                                    .add(DeleteNoteEvent(note[index].id!));

                                context
                                    .read<NoteBloc>()
                                    .add(GetNoteEvent(selecteedDate));
                                // context.read<NoteBloc>().add(GetNoteEvent());
                              },
                              icon: const Icon(CupertinoIcons.trash)),
                          leading: Text(note[index].id!.toString()),
                          title: Text(note[index].title!),
                          tileColor: Colors.grey,
                          subtitle: Text(note[index].note!),
                        ),
                      );
                    },
                  ),
                )
              : Text(note[0].title!);
        }
        return Container();
      },
    );
  }

  _dateBar(DateTime selecteedDate) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DatePicker(
          DateTime.now(),
          height: 100,
          width: 80,
          initialSelectedDate: DateTime.now(),
          selectedTextColor: Colors.white,
          selectionColor: primaryClr,
          dateTextStyle: GoogleFonts.poppins(
              fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600),
          monthTextStyle: GoogleFonts.poppins(
              fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600),
          dayTextStyle: GoogleFonts.poppins(
              fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w400),
          onDateChange: (date) {
            context.read<NoteBloc>().add(GetNoteEvent(date));
          },
        ),
      ),
    );
  }

  _taskBar() {
    return Container(
      color: Theme.of(context).canvasColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DateFormat.yMMMMd().format(DateTime.now()),
                      style: subHeadingStyle,
                    ),
                    Text(
                      'Today',
                      style: GoogleFonts.poppins(),
                    )
                  ],
                ),
                MyButton(
                  label: '+ Add task',
                  ontap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const AddTaskPage();
                      },
                    ));
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String label;
  final Function()? ontap;
  const MyButton({super.key, required this.label, this.ontap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: primaryClr),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: ontap,
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            width: 100,
            height: 40,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
