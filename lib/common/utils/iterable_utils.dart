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
}