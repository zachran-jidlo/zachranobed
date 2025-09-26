import 'package:flutter/widgets.dart';

/// Extensions on Iterable with Widgets.
extension IterableWidgets<T> on Iterable<Widget> {
  /// Creates a new iterable with widgets, which are separated via given
  /// [element] separator widget. Flags [leading] and [trailing] flags allow to add
  /// separator to the start or end of the list.
  Iterable<Widget> separated(Widget element, {bool leading = false, bool trailing = false}) sync* {
    final iterator = this.iterator;
    if (leading) {
      yield element;
    }
    if (iterator.moveNext()) {
      yield iterator.current;
      while (iterator.moveNext()) {
        yield element;
        yield iterator.current;
      }
      if (trailing) {
        yield element;
      }
    }
  }
}
