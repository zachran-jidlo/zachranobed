import 'package:flutter/widgets.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// The base class for all entries within a [SectionedListView].
sealed class SectionedListEntry<T> {
  const SectionedListEntry();
}

/// Represents a textual section header in the list.
class SectionedListHeader<T> extends SectionedListEntry<T> {
  /// The text to display in the header.
  final String header;

  const SectionedListHeader(this.header);
}

/// Represents a content item in the list containing a value of type [T].
class SectionedListItem<T> extends SectionedListEntry<T> {
  /// The data object associated with this item.
  final T value;

  const SectionedListItem(this.value);
}

/// A scrollable list widget that displays a sequence of headers and items with automatic spacing.
class SectionedListView<T> extends StatelessWidget {
  /// The list of entries to display.
  ///
  /// This list can contain both [SectionedListHeader] and [SectionedListItem] objects.
  final List<SectionedListEntry> entries;

  /// A builder function to create the widget for a [SectionedListItem].
  ///
  /// This is only called for [SectionedListItem] entries. Headers are rendered
  /// using a default text style.
  final Widget Function(BuildContext, T)? itemBuilder;

  /// An optional controller for the scroll view.
  final ScrollController? controller;

  const SectionedListView({
    super.key,
    required List<SectionedListEntry<Widget>> this.entries,
    this.controller,
  }) : itemBuilder = null;

  const SectionedListView.builder({
    super.key,
    required this.entries,
    required Widget Function(BuildContext, T) this.itemBuilder,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.all(16.0),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final topPadding = _calculateTopPadding(index);

        final child = switch (entry) {
          SectionedListHeader() => _buildHeader(context, entry.header),
          SectionedListItem() => _buildItem(context, entry.value),
        };

        if (topPadding == 0) {
          return child;
        }

        return Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: child,
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, T item) {
    if (itemBuilder != null) {
      return itemBuilder!(context, item);
    }

    if (item is Widget) {
      return item;
    }

    // Should never happen if constructors are used correctly
    throw StateError('SectionedListView was used without a builder, but items are not Widgets.');
  }

  Widget _buildHeader(BuildContext context, String text) {
    return Text(
      text,
      style: context.textStyles.titleMedium,
    );
  }

  double _calculateTopPadding(int index) {
    if (index == 0) return 0.0;

    final current = entries[index];
    final previous = entries[index - 1];

    return switch ((previous, current)) {
      // Header is always 24 from the previous item
      (_, SectionedListHeader()) => 24.0,

      // Item is 8 from a Header or 16 from another Item
      (SectionedListHeader(), SectionedListItem()) => 8.0,
      (SectionedListItem(), SectionedListItem()) => 16.0,
    };
  }
}
