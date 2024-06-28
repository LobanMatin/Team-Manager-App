import 'package:flutter/material.dart';

// Determine application
const primaryColour = Color.fromARGB(255,114,137,218);
const secondaryColour = Color.fromARGB(255,66,69,73);
const tertiaryColour = Color.fromARGB(255,54,57,62);
const textColour = Color.fromARGB(255,255,255,255);

// Determine application colourscheme
const appColourScheme = ColorScheme(
  primary: primaryColour,
  onPrimary: textColour,
  secondary: secondaryColour,
  onSecondary: textColour,
  tertiary: tertiaryColour,
  onTertiary: textColour,
  brightness: Brightness.light,
  surface: primaryColour,
  onSurface: textColour,
  error: tertiaryColour,
  onError: textColour,
);
