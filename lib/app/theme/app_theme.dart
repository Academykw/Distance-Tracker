
import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  static const _seed = Color(0xFF6C63FF);

  static ThemeData  get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seed),
    useMaterial3: true,
  );

  static ThemeData get dark => ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
      brightness: Brightness.dark,),
    scaffoldBackgroundColor: Colors.black,
    useMaterial3: true,


  );
}