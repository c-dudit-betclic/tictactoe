import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tictactoe/features/home/presentation/home_page_screen.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

final class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Tic Tac Toe',
    theme: ThemeData(
      colorScheme: .fromSeed(
        seedColor: const Color(0xFFE81E2B),
        primary: const Color(0xFFE81E2B),
        onPrimary: Colors.white,
        surface: Colors.grey[200],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE81E2B),
          foregroundColor: Colors.white,
          minimumSize: const .fromHeight(60),
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: .all(.circular(8))),
        ),
      ),
      textTheme: GoogleFonts.dmSansTextTheme().copyWith(
        displayLarge: GoogleFonts.dmSans(fontSize: 60, fontWeight: FontWeight.w900, height: 1),
      ),
    ),
    home: const HomePageScreen(),
  );
}
