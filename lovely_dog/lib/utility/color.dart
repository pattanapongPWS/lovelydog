import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFFFEEE9),
  100: Color(0xFFFFD6C7),
  200: Color(0xFFFFBAA2),
  300: Color(0xFFFF9E7C),
  400: Color(0xFFFF8A60),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFFFF6D3E),
  700: Color(0xFFFF6235),
  800: Color(0xFFFF582D),
  900: Color(0xFFFF451F),
});
const int _primaryPrimaryValue = 0xFFFF7544;

const MaterialColor primaryAccent =
    MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_primaryAccentValue),
  400: Color(0xFFFFD6CE),
  700: Color(0xFFFFC0B5),
});
const int _primaryAccentValue = 0xFFFFFFFF;
