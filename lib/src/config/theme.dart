import "package:flutter/material.dart";

const _primaryBlue = Color(0xFF1E5BD8);
const _scaffoldGrey = Color(0xFFF1F1F4);

ThemeData getTheme() => ThemeData(
  useMaterial3: true,
  colorSchemeSeed: _primaryBlue,
  scaffoldBackgroundColor: _scaffoldGrey,
  appBarTheme: const AppBarThemeData(
    backgroundColor: _primaryBlue,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  tabBarTheme: const TabBarThemeData(
    labelColor: Colors.white,
    unselectedLabelColor: Colors.white70,
    indicatorColor: Colors.white,
    labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 1,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
