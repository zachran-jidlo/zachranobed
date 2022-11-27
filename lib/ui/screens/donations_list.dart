import 'package:flutter/material.dart';
import 'package:zachranobed/constants.dart';

class DonationsList extends StatefulWidget {
  const DonationsList({Key? key}) : super(key: key);

  @override
  State<DonationsList> createState() => _DonationsListState();
}

class _DonationsListState extends State<DonationsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ZachranObedStrings.donationList),
      ),
    );
  }
}
