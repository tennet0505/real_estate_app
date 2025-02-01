import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';
import 'package:real_estate_app/presentation/helpers/app_local.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            ListTile(
              title: Text(AppLocal.language.tr(),
                  style: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge?.color)),
              trailing: DropdownButton<String>(
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                value: context.locale.languageCode,
                items: [
                  DropdownMenuItem(
                      value: 'en',
                      child: Text('English',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.color))),
                  DropdownMenuItem(
                      value: 'nl',
                      child: Text('Dutch',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.color))),
                ],
                onChanged: (value) {
                  if (value != null) {
                    context.setLocale(Locale(value));
                  }
                },
              ),
            ),
            ListTile(
              title: context.read<ThemeProvider>().isDarkMode
                  ? Text(AppLocal.lightMode.tr(),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge?.color))
                  : Text(AppLocal.darkMode.tr(),
                      style: TextStyle(
                          color:
                              Theme.of(context).textTheme.titleLarge?.color)),
              trailing: Switch(
                value: context.watch<ThemeProvider>().isDarkMode,
                onChanged: (value) {
                  context.read<ThemeProvider>().isDarkMode = value;
                },
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.logo,
                  height: 48,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/about_screen');
                  },
                  child: Text(
                    AppLocal.aboutDtt.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  set isDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}
