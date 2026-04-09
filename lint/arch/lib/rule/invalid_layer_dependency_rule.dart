import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Rule that checks dependencies between Clean Architecture layers in app directory.
class InvalidAppLayerDependencyRule extends InvalidLayerDependencyRule {
  InvalidAppLayerDependencyRule()
      : super(
          lintName: 'invalid_app_layer_dependency',
          regexPattern: r'app/([^/]+)/',
        );
}

/// Rule that checks dependencies between Clean Architecture layers in feature directories.
class InvalidFeatureLayerDependencyRule extends InvalidLayerDependencyRule {
  InvalidFeatureLayerDependencyRule()
      : super(
          lintName: 'invalid_feature_layer_dependency',
          regexPattern: r'features/[^/]+/([^/]+)/',
        );
}

/// Rule that checks dependencies between Clean Architecture layers in common directory.
class InvalidCommonLayerDependencyRule extends InvalidLayerDependencyRule {
  InvalidCommonLayerDependencyRule()
      : super(
          lintName: 'invalid_common_layer_dependency',
          regexPattern: r'common/([^/]+)/',
        );
}

/// Rule that checks dependencies between Clean Architecture layers.
class InvalidLayerDependencyRule extends DartLintRule {
  final String lintName;
  final String regexPattern;

  InvalidLayerDependencyRule({
    required this.lintName,
    required this.regexPattern,
  }) : super(
          code: LintCode(
            name: lintName,
            problemMessage: 'Invalid import between Clean Architecture layers.',
            correctionMessage: 'Check imports: domain → none, data → domain, presentation → domain, di → all.',
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  static final _allLayerPatterns = [
    RegExp(r'features/[^/]+/([^/]+)/'),
    RegExp(r'common/([^/]+)/'),
    RegExp(r'app/([^/]+)/'),
  ];

  static String? _extractLayer(String path) {
    for (final p in _allLayerPatterns) {
      final m = p.firstMatch(path);
      if (m != null) return m.group(1);
    }
    return null;
  }

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) {
    final filePath = resolver.source.fullName;

    final pattern = RegExp(regexPattern);
    final match = pattern.firstMatch(filePath);

    if (match == null) return;

    final currentLayer = match.group(1);

    context.registry.addImportDirective((node) {
      final importUri = node.uri.stringValue;
      if (importUri == null || !importUri.startsWith('package:')) return;

      final importPath = importUri.replaceFirst('package:', '');
      final importedLayer = _extractLayer(importPath);

      // Ignore if not importing a known layer
      if (importedLayer == null) return;

      if (!_isLayerAllowed(currentLayer, importedLayer)) {
        reporter.atNode(node, code);
      }
    });
  }

  /// Checks if the imported layer is allowed in the current layer.
  bool _isLayerAllowed(String? currentLayer, String? importedLayer) {
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
