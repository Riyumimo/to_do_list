// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  initheme() async {
    final pref = await SharedPreferences.getInstance();
    final savedTheme = pref.getString('theme');
    if (savedTheme != null) {
      print("THIS THEME : ${savedTheme.toString()}");
      final themeMode = ThemeMode.values.firstWhere(
        (element) => element.toString() == savedTheme,
        orElse: () => ThemeMode.dark,
      );
      emit(themeMode);
    }
  }

  toggleTheme() async {
    final pref = await SharedPreferences.getInstance();
    final currentTheme = state;
    final newTheme =
        currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    pref.setString('theme', newTheme.toString());
    emit(newTheme);
  }
}
