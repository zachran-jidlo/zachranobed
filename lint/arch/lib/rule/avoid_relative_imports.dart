import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Rule that prevents using relative imports.
class AvoidRelativeImports extends DartLintRule {
  AvoidRelativeImports() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_relative_imports',
    problemMessage: 'Avoid relative imports.',
    correctionMessage: 'Use "package" imports instead of relative paths.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    void check(UriBasedDirective node) {
      final importUri = node.uri.stringValue;
      if (importUri == null) return;

      // Relative imports start with ./ or ../
      if (importUri.startsWith('.')) {
        reporter.atNode(node, _code);
      }
    }

    context.registry
      ..addImportDirective(check)
      ..addExportDirective(check);
  }
}
