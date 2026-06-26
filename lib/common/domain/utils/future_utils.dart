import 'package:zachranobed/common/domain/model/resource.dart';

/// Extensions on Future class.
extension FutureExtensions<T> on Future<T> {

  /// Converts generic Future to success flag.
  Future<bool> toSuccess() => then((_) => true, onError: (_) => false);

  /// Awaits this future and wraps the outcome in a [Resource], reporting
  /// [ResourceSuccess] on completion and [ResourceError] on failure.
  Future<Resource<T>> toResource() async {
    try {
      return ResourceSuccess(await this);
    } catch (error) {
      return ResourceError(error);
    }
  }
}
