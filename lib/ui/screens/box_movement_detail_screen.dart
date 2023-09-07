import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/models/box_movement.dart';

@RoutePage()
class BoxMovementDetailScreen extends StatelessWidget {
  final BoxMovement boxMovement;

  const BoxMovementDetailScreen({super.key, required this.boxMovement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
