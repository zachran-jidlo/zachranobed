import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:lint_arch/rule/rule_context_extensions.dart';

/// Rule that checks invalid dependencies between top-level modules (app, features, common).
class InvalidModuleDependencyRule extends AnalysisRule {
  InvalidModuleDependencyRule() : super(name: _code.lowerCaseName, description: _code.problemMessage);

  static const _code = LintCode(
    'invalid_module_dependency',
    'Invalid dependency between modules.',
    correctionMessage: 'App → Feature/Common, Feature → Common, Common → none.',
    severity: DiagnosticSeverity.ERROR,
  );

  @override
  LintCode get diagnosticCode => _code;

  @override
  void registerNodeProcessors(RuleVisitorRegistry registry, RuleContext context) {
    registry.addImportDirective(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  // Match the current module: app/*, features/*, or common/*
  static final _modulePattern = RegExp(r'^(?:.*/)?(app|features|common)/');

  final AnalysisRule rule;
  final RuleContext context;

  // Cached per unit, so the path regex runs once per file instead of once per import.
  String? _currentPath;
  String? _currentModule;

  _Visitor(this.rule, this.context);

  String? get _moduleOfCurrentUnit {
    final path = context.currentPath;
    if (path != _currentPath) {
      _currentPath = path;
      _currentModule = _modulePattern.firstMatch(path)?.group(1);
    }
    return _currentModule;
  }

  @override
  void visitImportDirective(ImportDirective node) {
    final currentModule = _moduleOfCurrentUnit;
    if (currentModule == null) return;

    final importUri = node.uri.stringValue;
    if (importUri == null || !importUri.startsWith('package:')) return;

    final importPath = importUri.replaceFirst('package:', '');
    final importedMatch = _modulePattern.firstMatch(importPath);

    // Ignore if not importing another top-level module
    if (importedMatch == null) return;

    final importedModule = importedMatch.group(1);

    if (!_isModuleAllowed(currentModule, importedModule)) {
      rule.reportAtNode(node);
    }
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
