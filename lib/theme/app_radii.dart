import 'package:flutter/material.dart';

class AppRadii {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
}

const double radius12 = AppRadii.sm;
const double radius16 = AppRadii.md;
const double radius20 = AppRadii.lg;
const double radius24 = AppRadii.xl;

const BorderRadius cardRadius = BorderRadius.all(Radius.circular(radius20));
const BorderRadius inputRadius = BorderRadius.all(Radius.circular(radius16));
const BorderRadius chipRadius = BorderRadius.all(Radius.circular(radius24));
