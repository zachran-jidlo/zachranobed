import 'package:flutter/widgets.dart';

/// Extensions on Iterable class.
extension IterableUtils<T> on Iterable<T> {

  /// Maps an [Iterable] (like map), but filters out any null values and cast
  /// the resulting Iterable to be null-safe.
  Iterable<V> mapNotNull<V>(V? Function(T) mapper) {
    return map(mapper).filterNotNull().cast();
  }

  /// Given an [Iterable] on a nullable type T?, filters out any null elements
  /// and cast the resulting Iterable<T?> to Iterable<T>.
  Iterable<T> filterNotNull() {
    return where((e) => e != null).cast();
  }

  /// Creates a new iterable with chunks of elements of given [size].
  Iterable<Iterable<T>> chunked(int size) sync* {
    List<T> chunk = [];
    for (var element in this) {
      chunk.add(element);
      if (chunk.length == size) {
        yield chunk;
        chunk = [];
      }
    }
    if (chunk.isNotEmpty) {
      yield chunk;
    }
  }
}

/// Extensions on Iterable with Widgets.
extension IterableWidgets<T> on Iterable<Widget> {

  /// Creates a new iterable with widgets, which are separated via given
  /// [element] separator widget.
  Iterable<Widget> separated(Widget element) sync* {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
      while(iterator.moveNext()) {
        yield element;
        yield iterator.current;
      }
    }
  }
}
