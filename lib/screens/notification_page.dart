import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/note_bloc.dart';
import '../models/note.dart';
import '../theme.dart';

class NotificationPage extends StatelessWidget {
  final Note note;
  const NotificationPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    List<Color> getBGColor = [primaryClr, secondaryClr, thirdClr];

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title!),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: getBGColor[note.colors!]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title!,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          note.note!,
                          maxLines: 5,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                            child: MyButton(
                          colors: Colors.green,
                          label: "Complete",
                          onTap: () {
                            context.read<NoteBloc>().add(
                                NoteEvent.updateNoteEvent(
                                    id: note.id!, isComplete: 1));
                            context.read<NoteBloc>().add(
                                NoteEvent.getNoteEvent(date: DateTime.now()));
                            Navigator.pop(context);
                          },
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: MyButton(
                          label: "InComplete",
                          colors: Colors.red,
                          onTap: () => Navigator.pop(context),
                        )),
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  final Color colors;
  const MyButton({
    super.key,
    required this.label,
    required this.colors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(15), color: colors),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
            width: double.infinity,
            child: Center(
                child: Text(
              label,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            )),
          ),
        ),
      ),
    );
  }
}
