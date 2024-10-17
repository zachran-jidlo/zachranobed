import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/common/utils/iterable_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/activepair/domain/model/entity_pairs_summary.dart';
import 'package:zachranobed/features/activepair/domain/usecase/change_active_pair_use_case.dart';
import 'package:zachranobed/features/activepair/domain/usecase/get_entity_pairs_summary_use_case.dart';
import 'package:zachranobed/models/charity.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/card_row.dart';
import 'package:zachranobed/ui/widgets/error_content.dart';

/// A screen that displays a list of available pairs and allows to change it.
///
/// Note: It should be shown only for [Charity] user, but with a few text
/// changes it may be used also for [Canteen].
@RoutePage()
class ChangeActivePairScreen extends StatefulWidget {
  /// Creates a [ChangeActivePairScreen].
  const ChangeActivePairScreen({super.key});

  @override
  State<ChangeActivePairScreen> createState() =>
      _ChangeActiveCanteenScreenState();
}

class _ChangeActiveCanteenScreenState extends State<ChangeActivePairScreen> {
  final _getEntityPairsSummary = GetIt.I<GetEntityPairsSummaryUseCase>();
  final _changeActivePair = GetIt.I<ChangeActivePairUseCase>();

  late Future<EntityPairsSummary> _entityPairsSummaryFuture;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n!.activePairCanteenTitle),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _entityPairsSummaryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loading();
          } else if (snapshot.hasError || snapshot.data == null) {
            return _error(context);
          }
          return _entityPairs(snapshot.data!);
        },
      ),
    );
  }

  /// Loads entity pairs summary.
  void _loadSummary() {
    setState(() {
      final user = HelperService.getCurrentUser(context)!;
      _entityPairsSummaryFuture = _getEntityPairsSummary.invoke(user);
    });
  }

  /// Builds the entity pairs content for the given [summary].
  Widget _entityPairs(EntityPairsSummary summary) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(WidgetStyle.padding),
        child: Column(
          children: [
            CardRow(
              label: context.l10n!.activePairCardCanteenLabel,
              title: summary.active.donorEstablishmentName,
            ),
            const SizedBox(height: 8.0),
            ...summary.otherPairs.map((pair) {
              return CardRow(
                title: pair.donorEstablishmentName,
                action: (context) {
                  return ZOButton(
                    text: context.l10n!.activePairCardSelectAction,
                    type: ZOButtonType.secondary,
                    height: 40.0,
                    fullWidth: false,
                    onPressed: () {
                      _changeActivePair.invoke(pair.donorId, pair.recipientId);
                      HelperService.updateActivePair(context, pair);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            }).separated(const SizedBox(height: 8.0)),
          ],
        ),
      ),
    );
  }

  /// Builds a loading screen.
  Widget _loading() {
    return const Expanded(child: Center(child: CircularProgressIndicator()));
  }

  /// Builds a generic error screen.
  Widget _error(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(WidgetStyle.padding),
        child: ErrorContent(onRetryPressed: _loadSummary),
      ),
    );
  }
}
