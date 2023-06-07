import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryClr = const Color(0xFF393646);
Color errorClr = const Color(0xFFDF2E38);
Color buttonClr = const Color(0xFF46466E);
Color secondaryClr = const Color(0xFF5F264A);
Color thirdClr = const Color(0xFFC74B50);
Color backgroudnClr = const Color(0xFFF3E99F);
Color contrasClr = const Color(0xFF98D8AA);

// ThemeData customDark = ThemeData(
//   colorScheme: ColorScheme(
//       brightness: Brightness.light,
//       primary: primaryClr,
//       onPrimary: onprimaryClr,
//       secondary: secondaryClr,
//       onSecondary: onprimaryClr,
//       error: errorClr,
//       onError: onprimaryClr,
//       background: backgroudnClr,
//       onBackground: contrasClr,
//       surface: backgroudnClr,
//       onSurface: contrasClr),
// );
TextStyle get subHeadingStyle {
  return GoogleFonts.poppins(
      textStyle: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  ));
}
