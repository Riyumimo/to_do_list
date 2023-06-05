import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:to_do_list/screens/add_task_page.dart';
import 'package:to_do_list/service/notifi_helper.dart';
import 'package:to_do_list/theme.dart';

import '../bloc/note_bloc.dart';
import '../cubit/theme_cubit.dart';
import '../db/db_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NotifiHelper? _notifiHelper;
  DateTime selectedDate = DateTime.now();

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
    return Scaffold(
      appBar: _appBar(context),
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

  AppBar _appBar(BuildContext context) {
    return AppBar(
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
        ]);
  }

  _showDate(DateTime selecteedDate) {
    RefreshController _refreshcontroller =
        RefreshController(initialRefresh: false);
    return BlocBuilder<NoteBloc, NoteState>(
        // bloc: BlocProvider.of<NoteBloc>(context)..add(GetNoteEvent()),
        builder: (context, state) {
      return state.when(
          initial: () => Container(),
          loaded: (note) {
            if (note.isEmpty) {
              return Container();
            }
            print("banyak note" + note.length.toString());
            return Expanded(
              child: SmartRefresher(
                controller: _refreshcontroller,
                onRefresh: () {
                  context
                      .read<NoteBloc>()
                      .add(NoteEvent.getNoteEvent(date: selectedDate));
                },
                child: ListView.builder(
                  itemCount: note.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        trailing: IconButton(
                            onPressed: () {
                              context.read<NoteBloc>().add(
                                  NoteEvent.deleteNoteEvent(
                                      id: note[index].id!));

                              context.read<NoteBloc>().add(
                                  NoteEvent.getNoteEvent(date: selecteedDate));
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
              ),
            );
          },
          error: (message) {
            return Center(child: Text(message));
          });
    });
  }

  _dateBar(DateTime selecteedDate) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DatePicker(
          DateTime(DateTime.now().year, DateTime.now().month, 1),
          height: 100,
          width: 80,
          initialSelectedDate: selecteedDate,
          selectedTextColor: Colors.white,
          selectionColor: primaryClr,
          dateTextStyle: GoogleFonts.poppins(
              fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600),
          monthTextStyle: GoogleFonts.poppins(
              fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600),
          dayTextStyle: GoogleFonts.poppins(
              fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w400),
          onDateChange: (date) {
            context.read<NoteBloc>().add(NoteEvent.getNoteEvent(date: date));
            setState(() {
              selectedDate = date;
            });
            print("SECOND DATETIME : $selectedDate");
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
