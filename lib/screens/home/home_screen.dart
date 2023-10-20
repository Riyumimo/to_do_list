import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:to_do_list/models/note.dart';
import 'package:to_do_list/screens/home/widgets/task_tile.dart';
import 'package:to_do_list/service/notifi_helper.dart';
import 'package:to_do_list/service/notifi_sercvice.dart';
import 'package:to_do_list/theme.dart';

import '../../bloc/note_bloc.dart';
import '../../cubit/theme_cubit.dart';
import '../../db/db_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final NotifiHelper _notifiHelper = NotifiService.notifiservice;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeCubit>(context);
    return Scaffold(
      appBar: _appBar(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonClr,
        onPressed: () async {
          theme.toggleTheme();
          _notifiHelper.displayNotification(
              title: "HomeScreen", body: "First Notify");
          // _notifiHelper!.scheduledNotification();
          // await DatabaseHelper.dropTable();
          // await DatabaseHelper.deleteDatabse();
        },
        child: const Icon(
          CupertinoIcons.color_filter,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          _taskBar(),
          _dateBar(selectedDate),
          const SizedBox(
            height: 10,
          ),
          _showTask(selectedDate),
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

  _showTask(DateTime selecteedDate) {
    RefreshController refreshcontroller =
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
            print("banyak note${note.length}");
            return Expanded(
              child: SmartRefresher(
                controller: refreshcontroller,
                onRefresh: () {
                  context
                      .read<NoteBloc>()
                      .add(NoteEvent.getNoteEvent(date: selectedDate));
                },
                child: ListView.builder(
                  itemCount: note.length,
                  itemBuilder: (context, index) {
                    Note task = note[index];
                    print(task.toJson());
                    //Format Data became to Datetime and parsing to
                    DateTime date = DateFormat("HH:mm")
                        .parse(note[index].endTime.toString());
                    var myTime = DateFormat("HH:mm").format(date);

                    //parsing to schduleNotification
                    _notifiHelper.scheduledNotification(
                        int.parse(myTime.toString().split(":")[0]),
                        int.parse(myTime.toString().split(":")[1]),
                        note[index]);

                    return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showBottomSheet(
                                        context, note[index], index);
                                  },
                                  child: TaskTile(
                                    note: note[index],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
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

// ShowBottom Sheet
  Future<dynamic> _showBottomSheet(BuildContext context, Note note, int index) {
    return showModalBottomSheet(
      elevation: 0, // barrierColor: Colors.transparent.withOpacity(0.5),
      useSafeArea: true,
      context: context,
      builder: (context) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, state) {
            return AnimationConfiguration.staggeredList(
              position: index,
              child: FadeInAnimation(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 4),
                  height: note.isComplete == 1
                      ? MediaQuery.of(context).size.height * 0.24
                      : MediaQuery.of(context).size.height * 0.36,
                  color: state == ThemeMode.dark
                      ? Colors.grey[1000]
                      : Colors.white,
                  child: Column(children: [
                    Container(
                      height: 6,
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: state == ThemeMode.dark
                              ? Colors.grey[600]
                              : Colors.grey[300]),
                    ),
                    const Expanded(child: SizedBox()),
                    note.isComplete == 1
                        ? Container()
                        : _bottomSheetButton(
                            label: "Task Complete",
                            ontap: () {
                              context.read<NoteBloc>().add(
                                  NoteEvent.updateNoteEvent(
                                      id: note.id!, isComplete: 1));
                              context.read<NoteBloc>().add(
                                  NoteEvent.getNoteEvent(date: selectedDate));
                              Navigator.pop(context);
                              // note.isComplete = 1;
                            },
                            clrs: buttonClr),
                    _bottomSheetButton(
                        label: "DeleteTask",
                        ontap: () {
                          context
                              .read<NoteBloc>()
                              .add(NoteEvent.deleteNoteEvent(id: note.id!));
                          context
                              .read<NoteBloc>()
                              .add(NoteEvent.getNoteEvent(date: selectedDate));
                          Navigator.pop(context);
                        },
                        clrs: errorClr),
                    const SizedBox(
                      height: 40,
                    ),
                    _bottomSheetButton(
                        label: "Cancel",
                        isClose: true,
                        ontap: () {
                          Navigator.pop(context);
                        },
                        clrs: Colors.grey)
                  ]),
                ),
              ),
            );
          },
        );
      },
    );
  }

  _bottomSheetButton(
      {required String label,
      required Function() ontap,
      required Color clrs,
      bool isClose = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    width: 2,
                    color: isClose == true
                        ? state == ThemeMode.light
                            ? const Color(0xFF303030)
                            : Colors.white
                        : clrs),
                color: isClose == true ? Colors.transparent : clrs),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: ontap,
                child: SizedBox(
                  child: Center(
                      child: Text(
                    label,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isClose == true
                            ? state == ThemeMode.dark
                                ? Colors.white
                                : Colors.grey[850]
                            : Colors.white),
                  )),
                ),
              ),
            ),
          );
        },
      ),
    );
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
          initialSelectedDate: DateTime.now(),
          selectedTextColor: Colors.white,
          selectionColor: buttonClr,
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
                  ontap: () async {
                    await Future.delayed(const Duration(microseconds: 10), () {
                      Navigator.pushNamed(context, '/add');
                    });
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
          borderRadius: BorderRadius.circular(15), color: buttonClr),
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
