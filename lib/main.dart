import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/screens/detail_page/detail_screen_widget.dart';
import 'package:real_estate_app/presentation/screens/home_page/my_home_page.dart';
import 'package:real_estate_app/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // Initialize Hive
  Hive.registerAdapter(HouseAdapter()); // Register the Hive adapter
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DTT REAL ESTATE',
      theme: ThemeDataStyle.light,
      darkTheme: ThemeDataStyle.dark,
      themeMode: ThemeMode.system,
      routes: {
        "/main_screen": (context) => const MyHomePage(),
        "/detail_screen": (context) => const DetailScreen(),
      },
      initialRoute: "/main_screen",
    );
  }
}
