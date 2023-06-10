import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/theme.dart';

import '../../../models/note.dart';

class TaskTile extends StatelessWidget {
  final Note? note;
  const TaskTile({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    List<Color> getBGColor = [primaryClr, secondaryClr, thirdClr];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: getBGColor[note?.colors ?? 0],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note?.title ?? "",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.clock,
                        color: Colors.grey[200],
                        size: 18,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${note?.startTime} - ${note?.endTime}",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 13, color: Colors.grey[100])),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    note?.note ?? "",
                    style: GoogleFonts.poppins(
                        textStyle:
                            TextStyle(fontSize: 15, color: Colors.grey[300])),
                  )
                ],
              ),
            ),
            // const SizedBox(
            //   width: 10,
            // ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 0.5,
              height: 60,
              color: Colors.grey[200]!.withOpacity(0.7),
              child: RotatedBox(
                quarterTurns: 4,
                child: Center(
                  child: Text(
                    note!.isComplete == 1 ? "DONE" : "TODO",
                    style: GoogleFonts.jua(
                        fontSize: 10,
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
