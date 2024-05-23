import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const colorSeed = Color(0xff424CB8);
const scaffoldBackgroundColor = Color(0xFFF8F7F7);

class AppTheme {

  ThemeData getTheme() => ThemeData(

    useMaterial3: true,
    colorSchemeSeed: colorSeed,


    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 40, fontWeight: FontWeight.bold ),
      titleMedium: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 30, fontWeight: FontWeight.bold ),
      titleSmall: GoogleFonts.inter()
        .copyWith( fontSize: 20 )
    ),


    scaffoldBackgroundColor: scaffoldBackgroundColor,
    


    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStatePropertyAll(
          GoogleFonts.montserratAlternates()
            .copyWith(fontWeight: FontWeight.w700)
          )
      )
    ),

    appBarTheme: AppBarTheme(
      color: scaffoldBackgroundColor,
      titleTextStyle: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black ),
    )
  );

}