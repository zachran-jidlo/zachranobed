import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Rule that checks dependencies between Clean Architecture layers.
class InvalidFeatureLayerDependencyRule extends DartLintRule {
  InvalidFeatureLayerDependencyRule() : super(code: _code);

  static const _code = LintCode(
    name: 'invalid_feature_layer_dependency',
    problemMessage: 'Invalid import between Clean Architecture layers.',
    correctionMessage: 'Check Clean Architecture rules: domain → none, data → domain, presentation → domain, di → all.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final filePath = resolver.source.fullName;

    // Match: lib/features/<feature>/<layer>/...
    final featurePattern = RegExp(r'features/([^/]+)/([^/]+)/');
    final match = featurePattern.firstMatch(filePath);

    if (match == null) return;

    final currentLayer = match.group(2);

    context.registry.addImportDirective((node) {
      final importUri = node.uri.stringValue;
      if (importUri == null || !importUri.startsWith('package:')) return;

      final importPath = importUri.replaceFirst('package:', '');
      final importedMatch = featurePattern.firstMatch(importPath);

      // Ignore if not importing another layer
      if (importedMatch == null) return;

      final importedLayer = importedMatch.group(2);

      if (!_isAllowed(currentLayer, importedLayer)) {
        reporter.atNode(node, _code);
      }
    });
  }

  bool _isAllowed(String? currentLayer, String? importedLayer) {
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
