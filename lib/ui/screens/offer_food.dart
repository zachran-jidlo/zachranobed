import 'package:flutter/material.dart';

class OfferFood extends StatefulWidget {
  const OfferFood({Key? key}) : super(key: key);

  @override
  State<OfferFood> createState() => _OfferFoodState();
}

class _OfferFoodState extends State<OfferFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nabídnout"),
      ),
    );
  }
}
