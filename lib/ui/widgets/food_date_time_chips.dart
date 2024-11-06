import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/date_time_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_date_time.dart';
import 'package:zachranobed/ui/widgets/assist_chip.dart';
import 'package:zachranobed/ui/widgets/date_time_picker.dart';
import 'package:zachranobed/ui/widgets/form_field_error.dart';

/// A widget that displays a set of chips for selecting food date and time.
///
/// This widget is used food donation related fields and allows users to select
/// a date and time or indicate that the date and time are printed on the
/// packaging. It uses [AssistChip] widgets to display the options and provides
/// callbacks for handling selection changes and validation. Internally uses
/// [FormField] for validation in [Form].
class FoodDateTimeChips extends StatelessWidget {
  /// The currently selected option, or null if none is selected.
  final FoodDateTime? selection;

  /// Callback function triggered when the selection changes.
  final Function(FoodDateTime?) onSelectionChanged;

  /// The list of available options to display as chips.
  final List<FoodDateTimeOption> options;

  /// Focus node for the widget.
  final FocusNode? focusNode;

  /// Signature for validating a form field.
  final FormFieldValidator<FoodDateTime?>? onValidation;

  /// Lambda function to format the selected date. May return null, in this case
  /// the selected date will not be displayed.
  final String? Function(String) formatSelectedDate;

  /// Boolean flag to indicate whether time picker should be shown when option
  /// is selected.
  final bool hasTime;

  /// Lambda function to provide initial time for the time picker.
  final DateTime? Function()? initialTime;

  /// Creates a [FoodDateTimeChips] widget.
  const FoodDateTimeChips({
    super.key,
    required this.selection,
    required this.onSelectionChanged,
    required this.options,
    required this.formatSelectedDate,
    this.hasTime = true,
    this.initialTime,
    this.focusNode,
    this.onValidation,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<FoodDateTime>(
      initialValue: selection,
      validator: onValidation,
      builder: (state) {
        return Focus(
          focusNode: focusNode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: GapSize.xs,
                  runSpacing: GapSize.xs,
                  children: options.map((option) {
                    return AssistChip(
                      text: option.text,
                      selected: _isSelected(state, option),
                      onPressed: () => _onPressed(context, state, option),
                    );
                  }).toList(),
                ),
              ),
              _buildSelectedDate(context, state.value),
              if (state.hasError)
                FormFieldError(message: state.errorText ?? ""),
            ],
          ),
        );
      },
    );
  }

  bool _isSelected(
    FormFieldState<FoodDateTime> state,
    FoodDateTimeOption option,
  ) {
    if (state.value.runtimeType != option.date.runtimeType) {
      return false;
    }
    final selectedDate = state.value?.getDate();
    final optionDate = option.date.getDate();
    return selectedDate?.year == optionDate?.year &&
        selectedDate?.month == optionDate?.month &&
        selectedDate?.day == optionDate?.day;
  }

  void _onPressed(
    BuildContext context,
    FormFieldState<FoodDateTime> state,
    FoodDateTimeOption option,
  ) async {
    FoodDateTime? dateTime;
    TimeOfDay? time;
    switch (option.date) {
      case FoodDateTimeSpecified(date: final date):
        if (hasTime) {
          final initial =
              state.value?.getDate() ?? initialTime?.call() ?? DateTime.now();
          time = await DateTimePicker.pickTime(
            context: context,
            initial: TimeOfDay(
              hour: initial.hour,
              minute: initial.minute,
            ),
          );

          if (time == null) {
            break;
          }

          dateTime = FoodDateTimeSpecified(
            date: DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            ),
          );
          break;
        } else {
          dateTime = FoodDateTimeSpecified(
            date: DateTime(
              date.year,
              date.month,
              date.day,
            ),
          );
        }
      case FoodDateTimeOnPackaging():
        dateTime = FoodDateTimeOnPackaging();
        break;
    }

    if (dateTime != null) {
      state.didChange(dateTime);
      onSelectionChanged(dateTime);
    }
  }

  Widget _buildSelectedDate(BuildContext context, FoodDateTime? selectedDate) {
    if (selectedDate is! FoodDateTimeSpecified) {
      return const SizedBox();
    }

    final dateTime =
        DateTimeUtils().formatDateTime(selectedDate.date, "d.M.yyyy HH:mm");
    final labelText = formatSelectedDate(dateTime);
    if (labelText == null) {
      return const SizedBox();
    }

    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: GapSize.xs),
      child: Text(
        labelText,
        style: textTheme.bodyLarge?.copyWith(color: ZOColors.onPrimaryLight),
      ),
    );
  }
}

/// Represents an option for food date and time selection.
class FoodDateTimeOption {
  /// The text displayed on the chip.
  final String text;

  /// The corresponding [FoodDateTime] value.
  final FoodDateTime date;

  /// Creates a [FoodDateTimeOption] instance.
  FoodDateTimeOption({required this.text, required this.date});

  /// Creates a list of future date and time options.
  ///
  /// Returns a list of [FoodDateTimeOption] instances representing today,
  /// tomorrow, the day after tomorrow, and "on packaging" options.
  static List<FoodDateTimeOption> createFutureOptions(BuildContext context) {
    final now = DateTime.now();
    return [
      FoodDateTimeOption(
        text: context.l10n!.foodDateTimeLabelToday,
        date: FoodDateTimeSpecified(date: now),
      ),
      FoodDateTimeOption(
        text: context.l10n!.foodDateTimeLabelPlus1Day,
        date: FoodDateTimeSpecified(date: now.add(const Duration(days: 1))),
      ),
      FoodDateTimeOption(
        text: context.l10n!.foodDateTimeLabelPlus2Days,
        date: FoodDateTimeSpecified(date: now.add(const Duration(days: 2))),
      ),
      FoodDateTimeOption(
        text: context.l10n!.foodDateTimeLabelOnPackaging,
        date: FoodDateTimeOnPackaging(),
      ),
    ];
  }

  /// Creates a list of past date and time options.
  ///
  /// Returns a list of [FoodDateTimeOption] instances representing today,
  /// yesterday, the day before yesterday, and "on packaging" options.
  static List<FoodDateTimeOption> createPastOptions(BuildContext context) {
    final now = DateTime.now();
    return [
      FoodDateTimeOption(
        text: context.l10n!.foodDateTimeLabelToday,
        date: FoodDateTimeSpecified(date: now),
      ),
      FoodDateTimeOption(
        text: context.l10n!.foodDateTimeLabelMinus1Day,
        date: FoodDateTimeSpecified(date: now.add(const Duration(days: -1))),
      ),
      FoodDateTimeOption(
        text: context.l10n!.foodDateTimeLabelMinus2Days,
        date: FoodDateTimeSpecified(date: now.add(const Duration(days: -2))),
      ),
      FoodDateTimeOption(
        text: context.l10n!.foodDateTimeLabelOnPackaging,
        date: FoodDateTimeOnPackaging(),
      ),
    ];
  }
}
