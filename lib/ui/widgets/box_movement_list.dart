import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/models/box_movement.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/services/box_movement_srvice.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/box_movement_list_tile.dart';

class BoxMovementList extends StatelessWidget {
  final String title;
  final String weekNumber;
  final UserData user;

  const BoxMovementList({
    super.key,
    required this.title,
    required this.weekNumber,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final boxMovementService = GetIt.I<BoxMovementService>();

    return MultiSliver(
      pushPinnedChildren: true,
      children: <Widget>[
        SliverPinnedHeader(
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: GapSize.xs),
        StreamBuilder<List<BoxMovement>>(
          stream: boxMovementService.loggedUserBoxMovementStream(
            user: user,
            weekNumber: weekNumber,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final boxMovements = snapshot.data!;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: boxMovements.length,
                  (context, index) {
                    return BoxMovementListTile(
                      boxMovement: boxMovements[index],
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
