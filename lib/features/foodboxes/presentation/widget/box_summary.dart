import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/features/foodboxes/presentation/widget/box_data_table.dart';
import 'package:zachranobed/features/foodboxes/presentation/widget/box_summary_check_delayed.dart';
import 'package:zachranobed/features/foodboxes/presentation/widget/box_summary_check_in_progress.dart';
import 'package:zachranobed/features/foodboxes/presentation/widget/box_summary_check_needed.dart';
import 'package:zachranobed/features/foodboxes/presentation/widget/box_summary_header.dart';
import 'package:zachranobed/features/foodboxes/presentation/widget/box_summary_mismatch.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/models/charity.dart';
import 'package:zachranobed/models/food_boxes_checkup_state.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/ui/widgets/snackbar/temporary_snackbar.dart';

/// A widget that displays a summary of the user's food box status and supports monthly food boxes checkup.
///
/// This widget observes the statistics related to the user's food boxes and dynamically updates the UI based on the
/// status of the food boxes.
class BoxSummary extends StatefulWidget {
  /// The user data to display the summary for.
  final UserData user;

  /// The current state of the food boxes checkup.
  final FoodBoxesCheckupState state;

  /// Refreshes the state of the food boxes checkup.
  final VoidCallback refreshState;

  /// Sets the state of the food boxes checkup to in-progress.
  final VoidCallback setInProgress;

  /// Creates a [BoxSummary] widget.
  const BoxSummary({
    super.key,
    required this.user,
    required this.state,
    required this.refreshState,
    required this.setInProgress,
  });

  @override
  State<BoxSummary> createState() => _BoxSummaryState();
}

class _BoxSummaryState extends State<BoxSummary> {
  late FoodBoxRepository _repository;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _repository = GetIt.I<FoodBoxRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<FoodBoxStatistics>>(
      stream: _repository.observeStatistics(widget.user),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoxSummaryHeader(
                isVerified:
                    widget.state is FoodBoxesCheckupAllGood && (widget.state as FoodBoxesCheckupAllGood).isVerified,
              ),
              const SizedBox(height: 8.0),
              _content(
                context: context,
                state: widget.state,
                boxes: snapshot.data!,
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  /// Builds the content based on the current [state].
  Widget _content({
    required BuildContext context,
    required FoodBoxesCheckupState state,
    required Iterable<FoodBoxStatistics> boxes,
  }) {
    switch (state) {
      case FoodBoxesCheckupAllGood():
        return _boxTable(boxes: boxes);
      case FoodBoxesCheckupCheckNeeded():
        return BoxSummaryCheckNeeded(
          isLoading: _isLoading,
          state: state,
          onCheckPressed: widget.setInProgress,
          onDelayPressed: _onDelayPressed,
        );
      case FoodBoxesCheckupCheckInProgress():
        return BoxSummaryCheckInProgress(
          isLoading: _isLoading,
          boxTable: _boxTable(boxes: boxes, focusRelevantColumns: true),
          onMatchesPressed: _onMatchesPressed,
          onMismatchesPressed: _onMismatchesPressed,
        );
      case FoodBoxesCheckupDelayed():
        return BoxSummaryCheckDelayed(
          isLoading: _isLoading,
          boxTable: _boxTable(boxes: boxes),
          state: state,
          onPressed: widget.setInProgress,
        );
      case FoodBoxesCheckupMismatch():
        return BoxSummaryMismatch(
          boxTable: _boxTable(boxes: boxes, alertColors: true),
        );
    }
  }

  /// Builds the table displaying the food box data.
  ///
  /// The [boxes] parameter contains the food box statistics, and [alertColors] determines whether to highlight the
  /// whole table with alert colors. Additionally it is possible to highlight only relevant columns (or basically fade
  /// non-relevant ones).
  Widget _boxTable({
    required Iterable<FoodBoxStatistics> boxes,
    bool alertColors = false,
    bool focusRelevantColumns = false,
  }) {
    final List<BoxDataTableColumn> focusedColumns;
    if (focusRelevantColumns) {
      switch (widget.user) {
        case Charity():
          focusedColumns = [BoxDataTableColumn.name, BoxDataTableColumn.charity];
        case Canteen():
          focusedColumns = [BoxDataTableColumn.name, BoxDataTableColumn.canteen];
        default:
          focusedColumns = BoxDataTableColumn.values;
      }
    } else {
      focusedColumns = BoxDataTableColumn.values;
    }
    return BoxDataTable(boxes: boxes, alertColors: alertColors, focusedColumns: focusedColumns);
  }

  /// Handles the "Delay" button press by delaying the food box checkup. After the state is updated in Firebase,
  /// widget's state is updated and UI is redrawn.
  void _onDelayPressed() {
    _withLoading(
      context: context,
      action: () => _repository.delayFoodBoxesCheckup(user: widget.user),
    );
  }

  /// Handles the "Matches" button press by verifying the food box checkup. After the state is updated in Firebase,
  /// widget's state is updated and UI is redrawn.
  void _onMatchesPressed() {
    _withLoading(
      context: context,
      action: () => _repository.verifyFoodBoxesCheckup(user: widget.user),
      onSuccess: () {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          ZOTemporarySnackBar(message: context.l10n!.foodBoxesCheckupSuccessMessage),
        );
      },
    );
  }

  /// Handles the "Mismatches" button press by reporting a mismatch in the food box checkup. After the state is
  /// updated in Firebase, widget's state is updated and UI is redrawn.
  void _onMismatchesPressed() {
    _withLoading(
      context: context,
      action: () => _repository.reportFoodBoxesMismatch(user: widget.user),
    );
  }

  /// Executes an [action] with a loading indicator.
  ///
  /// If the [action] is successful, it reloads the user information and refreshes the state. If the action fails,
  /// it shows an error message.
  void _withLoading({
    required BuildContext context,
    required Future<bool> Function() action,
    Function()? onSuccess,
  }) async {
    setState(() {
      _isLoading = true;
    });

    final success = await action();
    if (context.mounted) {
      if (success) {
        await HelperService.loadUserInfo(context);
        widget.refreshState();
        onSuccess?.call();
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          ZOTemporarySnackBar(message: context.l10n!.foodBoxesCheckupErrorMessage),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }
}
