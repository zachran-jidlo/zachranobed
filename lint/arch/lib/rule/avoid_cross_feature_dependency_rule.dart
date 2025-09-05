import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Rule that prevents a feature from importing another feature.
class AvoidCrossFeatureDependencyRule extends DartLintRule {
  AvoidCrossFeatureDependencyRule() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_cross_feature_dependency',
    problemMessage: 'A feature should not depend on another feature directly.',
    correctionMessage: 'Extract shared code into "common" folder.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) {
    context.registry.addImportDirective((node) {
      final importUri = node.uri.stringValue;
      if (importUri == null || !importUri.startsWith('package:')) return;

      final currentUnit = resolver.source.fullName;
      final importPath = importUri.replaceFirst('package:', '');

      final featurePattern = RegExp(r'features/([^/]+)/');

      final currentFeature = featurePattern.firstMatch(currentUnit)?.group(1);
      final importedFeature = featurePattern.firstMatch(importPath)?.group(1);

      if (currentFeature != null && importedFeature != null && currentFeature != importedFeature) {
        reporter.atNode(node, _code);
      }
    });
  }
}
