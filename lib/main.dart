import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:two_d_scrolling/pages/base_page.dart';
import 'package:two_d_scrolling/pages/home_page.dart';
import 'package:uicons/uicons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xff181828),
        hintColor: const Color(0xffff2121).withOpacity(0.9),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffff2121),
        ).copyWith(
          brightness: Brightness.light,
          primary: const Color(0xffff2121),
          secondary: const Color(0xff090909),
        ),
        useMaterial3: true,
      ),
      home: BasePage(),
    );
  }
}
