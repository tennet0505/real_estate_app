import 'package:flutter/material.dart';
import 'package:real_estate_app/Theme/app_color.dart';
import 'package:real_estate_app/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DTT REAL ESTATE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.lightGaryColor),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColor.whiteColor,
          selectedItemColor: AppColor.strongColor,
          unselectedItemColor: AppColor.lightColor,
       )
      ),
      routes: {
        "/main_screen": (context) => const MyHomePage(),
      },
      initialRoute: "/main_screen",
    );
  }
}

