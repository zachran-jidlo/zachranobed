/// Extensions on generic class.
extension GenericUtils<T> on T {
  /// Return the current value if the given block is satisfied, will return
  /// null if not.
  T? takeIf(bool Function(T it) block) {
    if (this != null && block(this!)) {
      return this;
    }
    return null;
  }
}
