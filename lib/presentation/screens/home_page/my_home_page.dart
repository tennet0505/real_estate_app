import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/internet_cubitt/cubit/internet_cubit_cubit.dart';
import 'package:real_estate_app/presentation/helpers/app_local.dart';
import 'package:real_estate_app/presentation/screens/favorite_page/favorite_screen_widget.dart';
import 'package:real_estate_app/presentation/screens/home_page/home_page.dart';
import 'package:real_estate_app/presentation/screens/settings_page/settings_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> pages = [HomePage(), FavoritePage(), SettingsPage()];
  void _selectTab(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) {
        if (state is InternetIsConnected && state.isConnected == false) {
          Future.delayed(Duration(seconds: 1), () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                    AppLocal.noInternetConnection.tr(),
                  ),
                  backgroundColor: Colors.red),
            );
          });
        }
      },
      child: Scaffold(
        appBar: _selectedIndex == 1
            ? null
            : AppBar(
                centerTitle: false,
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                title: Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Text(
                    _selectedIndex == 2
                        ? AppLocal.settings.tr()
                        : AppLocal.companyTitle.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'GothamSSm',
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                ),
              ),
        body: pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: _selectedIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
            ],
            onTap: _selectTab,
          ),
        ),
      ),
    );
  }
}
