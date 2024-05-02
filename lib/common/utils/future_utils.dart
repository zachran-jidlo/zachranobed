/// Extensions on Future class.
extension FutureExtensions<T> on Future<T> {

  /// Converts generic Future to success flag.
  Future<bool> toSuccess() => then((_) => true, onError: (_) => false);
}
