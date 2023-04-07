import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/shared/custom_icons.dart';
import 'package:zachranobed/ui/screens/donations.dart';
import 'package:zachranobed/ui/screens/menu.dart';
import 'package:zachranobed/ui/screens/overview.dart';
import 'package:zachranobed/ui/screens/statistics.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final screens = [
    const Overview(),
    const Donations(),
    const Statistics(),
    const Menu(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedFontSize: 12.0,
        selectedFontSize: 12.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: ZachranObedStrings.overview,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: ZachranObedStrings.donations,
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.graph),
            label: ZachranObedStrings.statistics,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: ZachranObedStrings.menu,
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        backgroundColor: ZachranObedColors().secondary,
      ),
    );
  }
}
