import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/business_logic/house_bloc.dart';
import 'package:real_estate_app/data/clients/repository.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/helpers/app_local.dart';
import 'package:real_estate_app/presentation/screens/detail_page/detail_screen_widget.dart';
import 'package:real_estate_app/presentation/screens/favorite_page/favorite_screen_widget.dart';
import 'package:real_estate_app/presentation/screens/home_page/my_home_page.dart';
import 'package:real_estate_app/presentation/screens/about_page/about_page.dart';
import 'package:real_estate_app/presentation/screens/settings_page/settings_page.dart';
import 'package:real_estate_app/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(HouseAdapter());
  await EasyLocalization.ensureInitialized();
  // Initialize SharedPreferences and HouseBloc
  final sharedPreferences = await SharedPreferences.getInstance();
  final houseBloc = HouseBloc(HouseRepository(), sharedPreferences);

  // Initialize EasyLocalization and run the app
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('nl')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: ChangeNotifierProvider(
        create: (context) =>
            ThemeProvider(), // Provide the ThemeProvider to the widget tree
        child: MyApp(houseBloc: houseBloc), // Pass the houseBloc to MyApp
      ), // Pass the houseBloc to MyApp
    ),
  );
}

class MyApp extends StatelessWidget {
  final HouseBloc houseBloc;

  const MyApp({super.key, required this.houseBloc});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return BlocProvider.value(
          value: houseBloc, 
          child: MaterialApp(
            title: AppLocal.companyTitle,
            theme: ThemeDataStyle.light,
            darkTheme: ThemeDataStyle.dark,
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routes: {
              "/main_screen": (context) => const MyHomePage(),
              "/detail_screen": (context) => const DetailPage(),
              "/favorite_screen": (context) => const FavoritePage(),
              "/settings_screen": (context) => const SettingsPage(),
              "/about_screen": (context) => const AboutPage(),
            },
            initialRoute: "/main_screen",
            // Add localization delegates
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            locale: context.locale,
          ),
        );
      },
    );
  }
}
