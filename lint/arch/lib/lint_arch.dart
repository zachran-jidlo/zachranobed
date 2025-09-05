import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:lint_arch/rule/avoid_cross_feature_dependency_rule.dart';
import 'package:lint_arch/rule/avoid_relative_imports.dart';
import 'package:lint_arch/rule/invalid_common_layer_dependency_rule.dart';
import 'package:lint_arch/rule/invalid_feature_layer_dependency_rule.dart';
import 'package:lint_arch/rule/invalid_feature_layering_rule.dart';

PluginBase createPlugin() => _ArchitecturePlugin();

class _ArchitecturePlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return [
      AvoidRelativeImports(),
      AvoidCrossFeatureDependencyRule(),
      InvalidFeatureLayeringRule(),
      InvalidFeatureLayerDependencyRule(),
      InvalidCommonLayerDependencyRule(),
    ];
  }
}
