import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:lint_arch/rule/rule_context_extensions.dart';

/// Rule that prevents a feature from importing another feature.
class AvoidCrossFeatureDependencyRule extends AnalysisRule {
  AvoidCrossFeatureDependencyRule() : super(name: _code.lowerCaseName, description: _code.problemMessage);

  static const _code = LintCode(
    'avoid_cross_feature_dependency',
    'A feature should not depend on another feature directly.',
    correctionMessage: 'Extract shared code into "common" folder.',
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
  static final _featurePattern = RegExp(r'features/([^/]+)/');

  final AnalysisRule rule;
  final RuleContext context;

  _Visitor(this.rule, this.context);

  @override
  void visitImportDirective(ImportDirective node) {
    final importUri = node.uri.stringValue;
    if (importUri == null || !importUri.startsWith('package:')) return;

    final importPath = importUri.replaceFirst('package:', '');

    final currentFeature = _featurePattern.firstMatch(context.currentPath)?.group(1);
    final importedFeature = _featurePattern.firstMatch(importPath)?.group(1);

    if (currentFeature != null && importedFeature != null && currentFeature != importedFeature) {
      rule.reportAtNode(node);
    }
  }
}
