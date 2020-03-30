import 'package:flutter/material.dart';

class BuildContextSingleton {
  static final BuildContextSingleton _singleton =
      BuildContextSingleton._internal();

  static BuildContext context;

  factory BuildContextSingleton() {
    return _singleton;
  }

  BuildContextSingleton._internal();
}
