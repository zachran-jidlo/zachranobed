import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup_reported_count.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_box_counter_tile.dart';
import 'package:zachranobed/common/presentation/widget/form/ui_counter_field.dart';
import 'package:zachranobed/common/presentation/widget/layout/content_with_loading.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_temporary_snackbar.dart';
import 'package:zachranobed/features/food/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/food/domain/usecase/report_food_boxes_mismatch_use_case.dart';

/// Screen shown when the user reports a mismatch on the food boxes checkup.
///
/// Lists every box type with its in-system count and a counter field
/// pre-filled with that count. On submit, the real vs. system counts are
/// written to the food boxes checkup record under the role-appropriate path
/// (donor/recipient) so admins can resolve the mismatch without contacting
/// the user.
@RoutePage()
class FoodBoxesCheckupMismatchScreen extends StatefulWidget {
  /// The user reporting the mismatch. Role determines where counts are stored.
  final UserData user;

  /// The box statistics captured when the user opened this screen.
  final List<FoodBoxStatistics> statistics;

  const FoodBoxesCheckupMismatchScreen({
    super.key,
    required this.user,
    required this.statistics,
  });

  @override
  State<FoodBoxesCheckupMismatchScreen> createState() => _FoodBoxesCheckupMismatchScreenState();
}

class _FoodBoxesCheckupMismatchScreenState extends State<FoodBoxesCheckupMismatchScreen> {
  late final ReportFoodBoxesMismatchUseCase _reportMismatch;

  /// Per-type system count captured on entry. Immutable baseline for
  /// deciding whether the submit button is enabled.
  late final Map<String, int> _systemCounts;

  /// Per-type real count edited by the user. Starts as a copy of [_systemCounts].
  late final Map<String, int> _realCounts;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _reportMismatch = GetIt.I<ReportFoodBoxesMismatchUseCase>();
    _systemCounts = {
      for (final stat in widget.statistics) stat.type.id: _systemCountFor(stat),
    };
    _realCounts = Map<String, int>.from(_systemCounts);
  }

  /// The in-system count shown to the user.
  int _systemCountFor(FoodBoxStatistics stat) {
    return switch (widget.user) {
      Canteen() => stat.availableQuantityAtCanteen,
      Charity() => stat.availableQuantityAtCharity,
    };
  }

  bool get _hasChange {
    return _realCounts.entries.any((e) => e.value != _systemCounts[e.key]);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universal(
      appBar: UiAppBar(title: context.l10n.foodBoxesCheckupMismatchScreenTitle),
      child: ContentWithLoading(
        isLoading: _isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildContent(context)),
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 16.0,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.foodBoxesCheckupMismatchScreenDescription,
            style: context.textStyles.bodyLarge,
          ),
          ...widget.statistics.map((stat) => _buildTile(context, stat)),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, FoodBoxStatistics stat) {
    final systemCount = _systemCounts[stat.type.id] ?? 0;
    return UiBoxCounterTile(
      title: stat.type.name,
      subtitle: context.l10n.foodBoxesCheckupMismatchSystemCountLabel(systemCount),
      counterField: UiCounterField(
        label: context.l10n.foodBoxesCheckupMismatchRealCountLabel,
        value: _realCounts[stat.type.id] ?? systemCount,
        noValueFallback: systemCount,
        onChanged: (value) {
          setState(() {
            _realCounts[stat.type.id] = value;
          });
        },
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: UiPrimaryButton(
        text: context.l10n.foodBoxesCheckupMismatchSubmitAction,
        size: UiButtonSize.medium(fullWidth: true),
        enabled: _hasChange,
        onPressed: () => _submit(context),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final reports = _realCounts.entries.map((entry) {
      return FoodBoxesCheckupReportedCount(
        foodBoxId: entry.key,
        realCount: entry.value,
        systemCount: _systemCounts[entry.key] ?? 0,
      );
    }).toList();

    final success = await _reportMismatch.invoke(widget.user, reports: reports);
    if (!context.mounted) {
      return;
    }

    if (success) {
      await HelperService.loadUserInfo(context);
      if (!context.mounted) {
        return;
      }
      UiTemporarySnackBar.show(context, message: context.l10n.foodBoxesCheckupSuccessMessage);
      context.router.popUntilRouteWithName(HomeRoute.name);
    } else {
      UiTemporarySnackBar.showError(context, message: context.l10n.foodBoxesCheckupErrorMessage);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
