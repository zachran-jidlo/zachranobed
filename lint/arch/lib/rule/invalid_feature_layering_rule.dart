import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Rule to enforce Clean Architecture layers inside feature folders.
class InvalidFeatureLayeringRule extends DartLintRule {
  InvalidFeatureLayeringRule() : super(code: _code);

  static const _code = LintCode(
    name: 'invalid_feature_layering',
    problemMessage: 'File must be placed inside one of the allowed layers: domain/, data/, presentation/, di/.',
    correctionMessage: 'Move this file to the appropriate Clean Architecture layer.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  static const allowedLayers = ['domain', 'data', 'presentation', 'di'];

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

    if (match != null) {
      final layer = match.group(2);
      if (layer != null && !allowedLayers.contains(layer)) {
        reporter.atOffset(offset: 0, length: 0, errorCode: _code);
      }
    }
  }
}
