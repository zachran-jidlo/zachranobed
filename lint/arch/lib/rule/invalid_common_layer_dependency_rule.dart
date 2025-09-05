import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:lint_arch/rule/utils/arch_utils.dart';

/// Rule that checks dependencies between Clean Architecture layers in common directory.
class InvalidCommonLayerDependencyRule extends DartLintRule {
  InvalidCommonLayerDependencyRule() : super(code: _code);

  static const _code = LintCode(
    name: 'invalid_common_layer_dependency',
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

    // Match: lib/common/<layer>/...
    final commonPattern = RegExp(r'common/([^/]+)/');
    final match = commonPattern.firstMatch(filePath);

    if (match == null) return;

    final currentLayer = match.group(1);

    context.registry.addImportDirective((node) {
      final importUri = node.uri.stringValue;
      if (importUri == null || !importUri.startsWith('package:')) return;

      final importPath = importUri.replaceFirst('package:', '');
      final importedMatch = commonPattern.firstMatch(importPath);

      // Ignore if not importing another layer
      if (importedMatch == null) return;

      final importedLayer = importedMatch.group(1);

      if (!ArchUtils.isLayerAllowed(currentLayer, importedLayer)) {
        reporter.atNode(node, _code);
      }
    });
  }
}
