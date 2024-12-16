import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/house_bloc.dart';
import 'package:real_estate_app/data/clients/repository.dart';
import 'package:real_estate_app/presentation/helpers/app_color.dart';
import 'package:real_estate_app/presentation/about_page.dart';
import 'package:real_estate_app/presentation/main_page/main_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _selectTab(int index) {
    if (_selectedIndex == index) {
      return;
    } else {
      _selectedIndex = index;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 1
          ? null // Hide the AppBar when AboutPage is selected
          : AppBar(
              centerTitle: false,
              backgroundColor: AppColor.lightGrayColor,
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: const Text(
                  'DTT REAL ESTATE',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'GothamSSm',
                  ),
                ),
              ),
            ),
      body: IndexedStack(index: _selectedIndex, children: [
        BlocProvider(
            create: (context) => HouseBloc(HouseRepository()),
            child: const MainPage()),
        const AboutWidget(),
      ]),
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
            BottomNavigationBarItem(icon: Icon(Icons.info), label: ''),
          ],
          onTap: _selectTab,
        ),
      ),
    );
  }
}
