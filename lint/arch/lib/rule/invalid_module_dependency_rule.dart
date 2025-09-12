import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Rule that checks invalid dependencies between top-level modules (app, features, common).
class InvalidModuleDependencyRule extends DartLintRule {
  InvalidModuleDependencyRule()
      : super(
          code: LintCode(
            name: 'invalid_module_dependency',
            problemMessage: 'Invalid dependency between modules.',
            correctionMessage: 'App → Feature/Common, Feature → Common, Common → none.',
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) {
    final filePath = resolver.source.fullName;

    // Match the current module: app/*, features/*, or common/*
    final modulePattern = RegExp(r'^(?:.*/)?(app|features|common)/');
    final match = modulePattern.firstMatch(filePath);

    if (match == null) return;

    print(filePath);

    final currentModule = match.group(1);

    context.registry.addImportDirective((node) {
      final importUri = node.uri.stringValue;
      if (importUri == null || !importUri.startsWith('package:')) return;

      final importPath = importUri.replaceFirst('package:', '');
      final importedMatch = modulePattern.firstMatch(importPath);

      // Ignore if not importing another top-level module
      if (importedMatch == null) return;

      final importedModule = importedMatch.group(1);

      if (!_isModuleAllowed(currentModule, importedModule)) {
        reporter.atNode(node, code);
      }
    });
  }

  /// Checks if the imported module is allowed in the current module.
  bool _isModuleAllowed(String? currentModule, String? importedModule) {
    if (currentModule == null || importedModule == null) return true;

    if (currentModule == importedModule) {
      // allow intra-module imports
      return true;
    }

    switch (currentModule) {
      case 'app':
        // app may depend on features and common
        return importedModule == 'features' || importedModule == 'common';
      case 'features':
        // features may depend only on common
        return importedModule == 'common';
      case 'common':
        // common must not depend on app or features
        return false;
      default:
        return true;
    }
  }
}
