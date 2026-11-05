import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// Rule that prevents using relative imports.
class AvoidRelativeImports extends AnalysisRule {
  AvoidRelativeImports() : super(name: _code.lowerCaseName, description: _code.problemMessage);

  static const _code = LintCode(
    'avoid_relative_imports',
    'Avoid relative imports.',
    correctionMessage: 'Use "package" imports instead of relative paths.',
    severity: DiagnosticSeverity.ERROR,
  );

  @override
  LintCode get diagnosticCode => _code;

  @override
  void registerNodeProcessors(RuleVisitorRegistry registry, RuleContext context) {
    final visitor = _Visitor(this);
    registry
      ..addImportDirective(this, visitor)
      ..addExportDirective(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  _Visitor(this.rule);

  @override
  void visitImportDirective(ImportDirective node) => _check(node);

  @override
  void visitExportDirective(ExportDirective node) => _check(node);

  void _check(UriBasedDirective node) {
    final importUri = node.uri.stringValue;
    if (importUri == null) return;

    // Relative imports start with ./ or ../
    if (!importUri.startsWith('package') && !importUri.startsWith('dart')) {
      rule.reportAtNode(node);
    }
  }
}
