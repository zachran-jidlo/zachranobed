import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:lint_arch/rule/rule_context_extensions.dart';

/// Rule to enforce Clean Architecture layers inside feature folders.
class InvalidFeatureLayeringRule extends AnalysisRule {
  InvalidFeatureLayeringRule() : super(name: _code.lowerCaseName, description: _code.problemMessage);

  static const _code = LintCode(
    'invalid_feature_layering',
    'File must be placed inside one of the allowed layers: domain/, data/, presentation/, di/.',
    correctionMessage: 'Move this file to the appropriate Clean Architecture layer.',
    severity: DiagnosticSeverity.ERROR,
  );

  static const allowedLayers = ['domain', 'data', 'presentation', 'di'];

  @override
  LintCode get diagnosticCode => _code;

  @override
  void registerNodeProcessors(RuleVisitorRegistry registry, RuleContext context) {
    registry.addCompilationUnit(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  // Match: lib/features/<feature>/<layer>/...
  static final _featurePattern = RegExp(r'features/([^/]+)/([^/]+)/');

  final AnalysisRule rule;
  final RuleContext context;

  _Visitor(this.rule, this.context);

  @override
  void visitCompilationUnit(CompilationUnit node) {
    final match = _featurePattern.firstMatch(context.currentPath);
    if (match == null) return;

    final layer = match.group(2);
    if (layer != null && !InvalidFeatureLayeringRule.allowedLayers.contains(layer)) {
      rule.reportAtOffset(0, 0);
    }
  }
}
