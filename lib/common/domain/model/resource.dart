/// Represents the state of an asynchronously loaded value.
sealed class Resource<T> {
  const Resource();
}

/// The value is still being loaded.
class ResourceLoading<T> extends Resource<T> {
  const ResourceLoading();
}

/// The value has been loaded successfully.
class ResourceSuccess<T> extends Resource<T> {
  final T data;

  const ResourceSuccess(this.data);
}

/// Loading the value failed.
class ResourceError<T> extends Resource<T> {
  final Object? error;

  const ResourceError([this.error]);
}
