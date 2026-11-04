import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:lint_arch/rule/rule_context_extensions.dart';

const _problemMessage = 'Invalid import between Clean Architecture layers.';
const _correctionMessage = 'Check imports: domain → none, data → domain, presentation → domain, di → all.';

/// Rule that checks dependencies between Clean Architecture layers in app directory.
class InvalidAppLayerDependencyRule extends InvalidLayerDependencyRule {
  InvalidAppLayerDependencyRule() : super(code: _code, regexPattern: r'app/([^/]+)/');

  static const _code = LintCode(
    'invalid_app_layer_dependency',
    _problemMessage,
    correctionMessage: _correctionMessage,
    severity: DiagnosticSeverity.ERROR,
  );
}

/// Rule that checks dependencies between Clean Architecture layers in feature directories.
class InvalidFeatureLayerDependencyRule extends InvalidLayerDependencyRule {
  InvalidFeatureLayerDependencyRule() : super(code: _code, regexPattern: r'features/[^/]+/([^/]+)/');

  static const _code = LintCode(
    'invalid_feature_layer_dependency',
    _problemMessage,
    correctionMessage: _correctionMessage,
    severity: DiagnosticSeverity.ERROR,
  );
}

/// Rule that checks dependencies between Clean Architecture layers in common directory.
class InvalidCommonLayerDependencyRule extends InvalidLayerDependencyRule {
  InvalidCommonLayerDependencyRule() : super(code: _code, regexPattern: r'common/([^/]+)/');

  static const _code = LintCode(
    'invalid_common_layer_dependency',
    _problemMessage,
    correctionMessage: _correctionMessage,
    severity: DiagnosticSeverity.ERROR,
  );
}

/// Rule that checks dependencies between Clean Architecture layers.
///
/// Subclasses pass a `static const` [LintCode]. The analysis server needs a single instance per code,
/// otherwise `// ignore:` comments stop working.
abstract class InvalidLayerDependencyRule extends AnalysisRule {
  final LintCode _diagnosticCode;
  final RegExp _pattern;

  InvalidLayerDependencyRule({required LintCode code, required String regexPattern})
    : _diagnosticCode = code,
      _pattern = RegExp(regexPattern),
      super(name: code.lowerCaseName, description: code.problemMessage);

  @override
  LintCode get diagnosticCode => _diagnosticCode;

  @override
  void registerNodeProcessors(RuleVisitorRegistry registry, RuleContext context) {
    registry.addImportDirective(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  static final _allLayerPatterns = [
    RegExp(r'features/[^/]+/([^/]+)/'),
    RegExp(r'common/([^/]+)/'),
    RegExp(r'app/([^/]+)/'),
  ];

  final InvalidLayerDependencyRule rule;
  final RuleContext context;

  _Visitor(this.rule, this.context);

  static String? _extractLayer(String path) {
    for (final p in _allLayerPatterns) {
      final m = p.firstMatch(path);
      if (m != null) return m.group(1);
    }
    return null;
  }

  @override
  void visitImportDirective(ImportDirective node) {
    final match = rule._pattern.firstMatch(context.currentPath);
    if (match == null) return;

    final currentLayer = match.group(1);

    final importUri = node.uri.stringValue;
    if (importUri == null || !importUri.startsWith('package:')) return;

    final importPath = importUri.replaceFirst('package:', '');
    final importedLayer = _extractLayer(importPath);

    // Ignore if not importing a known layer
    if (importedLayer == null) return;

    if (!_isLayerAllowed(currentLayer, importedLayer)) {
      rule.reportAtNode(node);
    }
  }

  /// Checks if the imported layer is allowed in the current layer.
  bool _isLayerAllowed(String? currentLayer, String? importedLayer) {
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
