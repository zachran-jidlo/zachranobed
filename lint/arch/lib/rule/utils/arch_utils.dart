/// Utils for Clean Architecture rules.
class ArchUtils {
  ArchUtils._();

  /// Checks if the imported layer is allowed in the current layer.
  static bool isLayerAllowed(String? currentLayer, String? importedLayer) {
    if (currentLayer == null || importedLayer == null) {
      return true;
    }

    if (currentLayer == importedLayer) {
      // allow same layer imports
      return true;
    }

    switch (currentLayer) {
      case 'domain':
        // domain cannot depend on any other feature layer
        return false;
      case 'data':
        // data can depend only on domain
        return importedLayer == 'domain';
      case 'presentation':
        // presentation can depend only on domain
        return importedLayer == 'domain';
      case 'di':
        // di may depend on every layer
        return ['domain', 'data', 'presentation', 'di'].contains(importedLayer);
      default:
        // ignore non-feature files
        return true;
    }
  }
}
