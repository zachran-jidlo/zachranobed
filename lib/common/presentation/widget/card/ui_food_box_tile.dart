import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_card.dart';

/// Represents the size variant of [UiFoodBoxTile].
enum UiFoodBoxTileSize {
  /// Full size with multiple stat boxes and total count.
  full,

  /// Small size with a single stat box.
  small,
}

/// Represents a single stat item in the food box tile.
class UiFoodBoxTileStat {
  /// The numeric value to display.
  final int value;

  /// The label displayed below the value.
  final String label;

  /// Creates a [UiFoodBoxTileStat].
  const UiFoodBoxTileStat({
    required this.value,
    required this.label,
  });
}

/// A tile widget that displays food box statistics.
///
/// This widget shows a card with a title, optional total count,
/// and one or more stat boxes showing values with labels.
class UiFoodBoxTile extends StatelessWidget {
  /// The title displayed at the top of the tile.
  final String title;

  /// The list of statistics to display.
  ///
  /// For [UiFoodBoxTileSize.small], only the first stat is shown.
  /// For [UiFoodBoxTileSize.full], up to three stats are shown.
  final List<UiFoodBoxTileStat> stats;

  /// The total count displayed on the right side of the header.
  ///
  /// Only visible when [size] is [UiFoodBoxTileSize.full].
  final String? totalLabel;

  /// The size variant of the tile.
  final UiFoodBoxTileSize size;

  /// Whether the first stat box should show a selected/check state.
  final bool isSelected;

  /// Creates a [UiFoodBoxTile] widget.
  const UiFoodBoxTile({
    super.key,
    required this.title,
    required this.stats,
    this.totalLabel,
    this.size = UiFoodBoxTileSize.small,
    this.isSelected = false,
  }) : assert(stats.length > 0, 'stats must contain at least one item');

  @override
  Widget build(BuildContext context) {
    return UiCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final label = size == UiFoodBoxTileSize.full ? totalLabel : null;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.titleMedium.copyWith(
              color: context.uiColors.textPrimary,
            ),
          ),
        ),
        if (label != null)
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.labelMedium.copyWith(
              color: context.uiColors.textSecondary,
            ),
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (size == UiFoodBoxTileSize.small) {
      return SizedBox(
        width: double.infinity,
        child: _StatBox(
          stat: stats.first,
        ),
      );
    }

    return Row(
      spacing: 4.0,
      children: stats.asMap().entries.map((entry) {
        final i = entry.key;
        return Expanded(
          child: _StatBox(
            stat: entry.value,
            hasBorder: i == 0 && isSelected,
            isHighlighted: i == 0,
            isDimmed: i != 0 && isSelected,
          ),
        );
      }).toList(),
    );
  }
}

/// A container displaying a single statistic with value and label.
class _StatBox extends StatelessWidget {
  /// The stat data to display.
  final UiFoodBoxTileStat stat;

  /// Whether to show a border around the box.
  final bool hasBorder;

  /// Whether to use a darker background color.
  final bool isHighlighted;

  /// Whether to dim the value text.
  final bool isDimmed;

  /// Creates a [_StatBox] widget.
  const _StatBox({
    required this.stat,
    this.hasBorder = false,
    this.isHighlighted = false,
    this.isDimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isHighlighted ? context.uiColors.surfaceGrayDark : context.uiColors.surfaceGray;

    final border = hasBorder ? Border.all(color: context.uiColors.textSecondary, width: 1) : null;

    return Container(
      constraints: const BoxConstraints(minWidth: 106),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
        border: border,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 4.0,
        children: [
          Text(
            stat.value.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.titleHeavy.copyWith(
              color: isDimmed ? context.uiColors.textSecondary : context.uiColors.textPrimary,
            ),
          ),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.labelSmall.copyWith(
              color: context.uiColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
