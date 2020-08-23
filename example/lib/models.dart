import 'package:flutter/material.dart' show Color, Colors;
import 'package:themes_manager/custom_data.dart';

class Name {
  final String name;
  final String description;
  final int no;
  Name({this.name, this.description, this.no});
}

class ThemeSelectorThemes {
  final Color color;

  ThemeSelectorThemes({this.color});

  static List<CustomThemeManagerData> themeData = [
    CustomThemeManagerData(
      key: 'amber',
      data: ThemeSelectorThemes(color: Colors.amber),
    ),
    CustomThemeManagerData(
      key: 'green',
      data: ThemeSelectorThemes(color: Colors.green),
    ),
  ];
}
