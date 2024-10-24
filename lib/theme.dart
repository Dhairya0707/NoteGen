import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _darkGreen = Color(0xFF0F4C3A);
  static const Color _mediumGreen = Color(0xFF3A7D6F);
  static const Color _lightGreen = Color(0xFF9CC5B9);
  static const Color _veryLightGreen = Color(0xFFE1EFEA);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: _mediumGreen,
    scaffoldBackgroundColor: _veryLightGreen,
    appBarTheme: const AppBarTheme(
      backgroundColor: _mediumGreen,
      foregroundColor: Colors.white,
    ),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        color: _darkGreen,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.lato(
        color: _darkGreen,
        fontSize: 16,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: _mediumGreen,
      secondary: _lightGreen,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: _darkGreen,
      onSurface: _darkGreen,
      // onBackground: _darkGreen,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: _lightGreen,
    scaffoldBackgroundColor: _darkGreen,
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkGreen,
      foregroundColor: _veryLightGreen,
    ),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        color: _veryLightGreen,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.lato(
        color: _veryLightGreen,
        fontSize: 16,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: _lightGreen,
      secondary: _mediumGreen,
      surface: _darkGreen,
      onPrimary: _darkGreen,
      onSecondary: _veryLightGreen,
      onSurface: _veryLightGreen,
    ),
  );
}

// ignore_for_file: unused_field

Color backgroundColor1 = const Color(0xffE9EAF7);
Color backgroundColor2 = const Color(0xffF4EEF2);
Color backgroundColor3 = const Color(0xffEBEBF2);
Color backgroundColor4 = const Color(0xffE3EDF5);
Color primaryColor = const Color(0xffD897FD);
Color textColor1 = const Color(0xff353047);
Color textColor2 = const Color(0xff6F6B7A);
Color buttonColor = const Color(0xffFD6B68);

Color btncolor(double x) {
  return Color.fromRGBO(20, 25, 122, x);
}

class NoteGenieTheme {
  static const _lightPrimaryColor = Color(0xFF6200EE);
  // static const _darkPrimaryColor = Color(0xFF9C7BEA);
  static const _darkPrimaryColor = Color.fromARGB(255, 66, 56, 91);
  static const _blueDarkPrimaryColor = Color(0xFF82B1FF);

  static ThemeData light() {
    return _buildTheme(
      brightness: Brightness.light,
      primaryColor: _darkPrimaryColor,
      backgroundColor: const Color(0xFFF5F5F5),
      // backgroundColor: Colors.white,
      surfaceColor: backgroundColor1,
      onSurfaceColor: Colors.black87,
    );
  }

  static ThemeData dark() {
    return _buildTheme(
      brightness: Brightness.dark,
      primaryColor: _darkPrimaryColor,
      backgroundColor: Color(0xFF1E1E1E),
      surfaceColor: Color(0xFF2C2C2C),
      onSurfaceColor: Colors.white.withOpacity(0.87),
    );
  }

  static ThemeData blueDark() {
    return _buildTheme(
      brightness: Brightness.dark,
      primaryColor: _blueDarkPrimaryColor,
      backgroundColor: Color(0xFF0E1724),
      surfaceColor: Color(0xFF1A2634),
      onSurfaceColor: Colors.white.withOpacity(0.87),
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primaryColor,
    required Color backgroundColor,
    required Color surfaceColor,
    required Color onSurfaceColor,
  }) {
    final ColorScheme colorScheme = ColorScheme(
      brightness: brightness,
      primary: primaryColor,
      onPrimary: brightness == Brightness.light ? Colors.white : Colors.black,
      secondary: primaryColor,
      onSecondary: brightness == Brightness.light ? Colors.white : Colors.black,
      error: Colors.red.shade400,
      onError: Colors.white,
      background: backgroundColor,
      onBackground: onSurfaceColor,
      surface: surfaceColor,
      onSurface: onSurfaceColor,
    );

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        color: surfaceColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: GoogleFonts.poppins(
          color: onSurfaceColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: IconThemeData(color: primaryColor),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white; // White icon color when pressed
            }
            return primaryColor; // Default icon color
          }),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return primaryColor
                  .withOpacity(0.2); // Light blue background when pressed
            }
            return Colors.transparent; // Transparent background by default
          }),
          overlayColor: MaterialStateProperty.all(primaryColor
              .withOpacity(0.1)), // Slight overlay color for hover effect
        ),
      ),
      fontFamily: GoogleFonts.roboto().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 96,
          fontWeight: FontWeight.w300,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 60,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 48,
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 34,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleMedium: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15,
        ),
        titleSmall: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        labelLarge: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
        bodySmall: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        labelSmall: GoogleFonts.roboto(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5,
        ),
      ).apply(
        bodyColor: onSurfaceColor,
        displayColor: onSurfaceColor,
      ),
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor:
            brightness == Brightness.light ? Colors.white : Colors.black,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: onSurfaceColor.withOpacity(0.6),
      ),
      dividerColor: onSurfaceColor.withOpacity(0.1),
    );
  }
}
