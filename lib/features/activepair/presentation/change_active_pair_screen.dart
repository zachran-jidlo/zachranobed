import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/model/canteen.dart';
import 'package:zachranobed/common/domain/model/entity_pair.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/iterable_widget_utils.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_icon_button.dart';
import 'package:zachranobed/common/presentation/widget/page/error_page.dart';
import 'package:zachranobed/common/presentation/widget/page/loading_page.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/ui_change_pair_tile.dart';
import 'package:zachranobed/features/activepair/domain/model/entity_pairs_summary.dart';
import 'package:zachranobed/features/activepair/domain/usecase/change_active_pair_use_case.dart';
import 'package:zachranobed/features/activepair/domain/usecase/get_entity_pairs_summary_use_case.dart';

/// A screen that displays a list of available pairs and allows to change it.
///
/// For [Canteen] users, this shows charities (recipients) to select from.
/// For Charity users, this shows canteens (donors) to select from.
@RoutePage()
class ChangeActivePairScreen extends StatefulWidget {
  /// Creates a [ChangeActivePairScreen].
  const ChangeActivePairScreen({super.key});

  @override
  State<ChangeActivePairScreen> createState() => _ChangeActivePairScreenState();
}

class _ChangeActivePairScreenState extends State<ChangeActivePairScreen> {
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
    return ScreenScaffold.universal(
      appBar: UiAppBar(
        title: _getTitle(),
        automaticallyImplyLeading: false,
        actions: [
          UiIconButton.solid(
            icon: Icons.close,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      child: FutureBuilder(
        future: _entityPairsSummaryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          } else if (snapshot.hasError || snapshot.data == null) {
            return ErrorPage(onRetryPressed: _loadSummary);
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            UiChangePairTile(
              name: _getEstablishmentName(summary.active),
              activeLabel: _getActiveLabel(),
            ),
            const SizedBox(height: 24.0),
            ...summary.otherPairs.map((pair) {
              return UiChangePairTile(
                name: _getEstablishmentName(pair),
                showIndicator: _shouldShowIndicator(pair),
                onSelectPressed: () {
                  _changeActivePair.invoke(pair.donorId, pair.recipientId);
                  HelperService.updateActivePair(context, pair);
                  Navigator.pop(context);
                },
              );
            }).separated(const SizedBox(height: 8.0)),
          ],
        ),
      ),
    );
  }

  /// Whether the current user is a canteen (selecting charities).
  /// If false, the user is a charity (selecting canteens).
  bool _isCanteenUser() {
    return HelperService.getCurrentUser(context) is Canteen;
  }

  /// Returns the correct title based on user type.
  String _getTitle() {
    if (_isCanteenUser()) {
      return context.l10n.activePairCharityTitle;
    } else {
      return context.l10n.activePairCanteenTitle;
    }
  }

  /// Returns the correct label based on user type.
  String _getActiveLabel() {
    if (_isCanteenUser()) {
      return context.l10n.activePairCardCharityLabel;
    } else {
      return context.l10n.activePairCardCanteenLabel;
    }
  }

  /// Returns the establishment name based on user type.
  String _getEstablishmentName(EntityPair pair) {
    if (_isCanteenUser()) {
      return pair.recipientEstablishmentName;
    } else {
      return pair.donorEstablishmentName;
    }
  }

  /// Returns whether the indicator should be shown for the given pair.
  bool _shouldShowIndicator(EntityPair pair) {
    if (_isCanteenUser()) {
      return pair.donorFoodBoxesCheckup.isCheckupNeeded();
    } else {
      return pair.recipientFoodBoxesCheckup.isCheckupNeeded();
    }
  }
}
