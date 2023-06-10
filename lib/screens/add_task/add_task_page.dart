import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/cubit/theme_cubit.dart';
import 'package:to_do_list/models/note.dart';
import 'package:to_do_list/screens/home/home_screen.dart';
import 'package:to_do_list/theme.dart';

import '../../bloc/note_bloc.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _dateTime = DateTime.now();
  Time _time = Time(
    hour: DateTime.now().hour,
    minute: DateTime.now().minute,
  );
  int _selectRemind = 5;
  List<int> remindList = [4, 5, 10, 15];
  String _seleceRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  String startTime = DateFormat("hh:mm").format(DateTime.now()).toString();
  int _selectColor = 0;
  @override
  void initState() {
    super.initState();
  }

  void onTimeChange(Time newtime) {
    setState(() {
      _time = newtime;
    });
    print(_time.format(context).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Task',
                    style: GoogleFonts.poppins(
                        fontSize: 26, fontWeight: FontWeight.w600),
                  ),
                  MyInputField(
                    title: 'Title',
                    color:
                        state == ThemeMode.dark ? Colors.white : Colors.black,
                    hint: 'Enter title',
                    textEditingController: _titleController,
                  ),
                  MyInputField(
                    title: 'Note',
                    color:
                        state == ThemeMode.dark ? Colors.white : Colors.black,
                    hint: 'Enter note here.',
                    textEditingController: _noteController,
                  ),
                  MyInputField(
                    title: 'Date',
                    color:
                        state == ThemeMode.dark ? Colors.white : Colors.black,
                    hint: DateFormat.yMd().format(_dateTime),
                    widget: IconButton(
                      onPressed: () {
                        _getDateFormUser();
                      },
                      icon: const Icon(CupertinoIcons.calendar_badge_plus),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: MyInputField(
                        title: 'Start Time',
                        color: state == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        hint: startTime,
                        widget: IconButton(
                          onPressed: () {
                            _getHourFromUser(isStartTime: true);
                          },
                          icon: const Icon(CupertinoIcons.time),
                        ),
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: MyInputField(
                        title: 'End Time',
                        color: state == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        hint: _time.format(context),
                        widget: IconButton(
                            onPressed: () {
                              Navigator.push(context, _showTime());
                            },
                            icon: const Icon(CupertinoIcons.time)),
                      ))
                    ],
                  ),
                  MyInputField(
                    title: "Remind",
                    color:
                        state == ThemeMode.dark ? Colors.white : Colors.black,
                    hint: "$_selectRemind minute Early",
                    widget: DropdownButton(
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subHeadingStyle,
                      underline: Container(height: 0),
                      onChanged: (String? value) {
                        setState(() {
                          _selectRemind = int.parse(value!);
                        });
                      },
                      items: remindList.map<DropdownMenuItem<String>>((int e) {
                        return DropdownMenuItem<String>(
                            value: e.toString(),
                            child: Text(
                              e.toString(),
                              style: TextStyle(
                                  color: state == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black),
                            ));
                      }).toList(),
                    ),
                  ),
                  MyInputField(
                    title: "Repeat",
                    color:
                        state == ThemeMode.dark ? Colors.white : Colors.black,
                    hint: _seleceRepeat,
                    widget: DropdownButton(
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subHeadingStyle,
                      underline: Container(height: 0),
                      onChanged: (value) {
                        setState(() {
                          _seleceRepeat = value!;
                        });
                      },
                      items: repeatList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: state == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black),
                            ));
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _palleteColor(),
                      MyButton(
                        label: "Create Task",
                        ontap: () {
                          _validateData(context);
                        },
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _validateData(BuildContext buildContext) {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      //Format end time to 10:58 format
      DateTime endDate =
          DateFormat("HH:mm").parse(_time.format(context).toString());
      final end = endDate.toString().split(" ")[1];
      final timeParts = end.split(":");
      final endTimeHour = "${timeParts[0]}:${timeParts[1]}";
      //adding DATA
      final note = Note(
        title: _titleController.text.toString(),
        note: _noteController.text.toString(),
        dateTime: _dateTime.toString(),
        startTime: startTime,
        endTime: endTimeHour,
        remind: _selectRemind,
        repeat: _seleceRepeat,
        colors: _selectColor,
        isComplete: 0,
      );
      //SetState To ADD to DB
      context.read<NoteBloc>().add(NoteEvent.addNoteEvent(note: note));
      //SetState to Show Note
      context
          .read<NoteBloc>()
          .add(NoteEvent.getNoteEvent(date: DateTime.now()));
      Navigator.pop(context);
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      final snackbar = SnackBar(
        duration: const Duration(seconds: 2),
        content: const Text("Semua Harus Di isikan"),
        action: SnackBarAction(
          label: "Ok",
          onPressed: () =>
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
        ),
      );
      return ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Column _palleteColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: subHeadingStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
            children: List<Widget>.generate(3, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectColor = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, state) {
                  return CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? secondaryClr
                            : thirdClr,
                    child: _selectColor == index
                        ? Icon(
                            CupertinoIcons.check_mark_circled,
                            color: state == ThemeMode.dark
                                ? Colors.black
                                : Colors.white,
                          )
                        : Container(),
                  );
                },
              ),
            ),
          );
        }))
      ],
    );
  }

  _getHourFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    if (pickedTime == null) {
    } else {
      String formattedTime =
          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
      if (isStartTime == true) {
        setState(() {
          startTime = formattedTime;
        });
      } else {
        setState(() {});
      }
    }
  }

  _showTime() {
    return showPicker(
      width: 400,
      value: _time,
      iosStylePicker: true,
      onChange: onTimeChange,
      context: context,
    );
  }

  _showTimePicker() async {
    return await showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(startTime.split(":")[0]),
            minute: int.parse(startTime.split(":")[1].split(" ")[0])));
  }

  _getDateFormUser() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2024));

    if (pickerDate != null) {
      setState(() {
        _dateTime = pickerDate;
      });
    } else {}
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.back),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.person_crop_circle))
        ]);
  }
}

// ignore: must_be_immutable
class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? textEditingController;
  final Widget? widget;

  Color color;

  MyInputField({
    super.key,
    required this.title,
    required this.hint,
    this.textEditingController,
    required this.color,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: subHeadingStyle,
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
                border: Border.all(color: color, width: 0.5),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  readOnly: widget == null ? false : true,
                  autofocus: false,
                  controller: textEditingController,
                  style: subHeadingStyle,
                  decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subHeadingStyle,
                      focusedBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 0)),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 0))),
                )),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
