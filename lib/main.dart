import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:real_estate_app/business_logic/house_bloc.dart';
import 'package:real_estate_app/data/clients/repository.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/screens/detail_page/detail_screen_widget.dart';
import 'package:real_estate_app/presentation/screens/favorite_page/favorite_screen_widget.dart';
import 'package:real_estate_app/presentation/screens/home_page/my_home_page.dart';
import 'package:real_estate_app/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // Initialize Hive
  Hive.registerAdapter(HouseAdapter()); // Register the Hive adapter
  final sharedPreferences = await SharedPreferences.getInstance(); // Await to get SharedPreferences instance
  final houseBloc = HouseBloc(HouseRepository(), sharedPreferences); // Initialize the HouseBloc

  runApp(MyApp(houseBloc: houseBloc)); 
}

class MyApp extends StatelessWidget {
  final HouseBloc houseBloc;
  const MyApp({super.key, required this.houseBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: houseBloc, // Provide the existing HouseBloc instance
      child: MaterialApp(
        title: 'DTT REAL ESTATE',
        theme: ThemeDataStyle.light,
        darkTheme: ThemeDataStyle.dark,
        themeMode: ThemeMode.system,
        routes: {
          "/main_screen": (context) => const MyHomePage(),
          "/detail_screen": (context) => const DetailScreen(),
          "/favorite_screen": (context) => const FavoritePage(),
        },
        initialRoute: "/main_screen",
      ),
    );
  }
}