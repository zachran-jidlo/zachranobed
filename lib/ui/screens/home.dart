import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/screens/donations.dart';
import 'package:zachranobed/ui/screens/overview.dart';
import 'package:zachranobed/ui/widgets/new_offer_floating_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final screens = [
    const Overview(),
    const Donations(),
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
      bottomNavigationBar: SizedBox(
        height: 80.0,
        child: BottomNavigationBar(
          unselectedFontSize: 12.0,
          selectedFontSize: 12.0,
          selectedItemColor: ZOColors.primary,
          unselectedItemColor: ZOColors.onPrimaryLight,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: ZOStrings.overview,
            ),
            BottomNavigationBarItem(
              icon: Icon(MaterialSymbols.fastfood),
              label: ZOStrings.donations,
            ),
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          backgroundColor: ZOColors.primaryLight,
        ),
      ),
      floatingActionButton: NewOfferFloatingButton(
        enabled: context.watch<DeliveryNotifier>().deliveryConfirmed(),
      ),
    );
  }
}
