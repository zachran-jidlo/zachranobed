import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:lint_arch/rule/avoid_cross_feature_dependency_rule.dart';
import 'package:lint_arch/rule/avoid_relative_imports.dart';
import 'package:lint_arch/rule/invalid_feature_layering_rule.dart';
import 'package:lint_arch/rule/invalid_layer_dependency_rule.dart';
import 'package:lint_arch/rule/invalid_module_dependency_rule.dart';

final plugin = _ArchitecturePlugin();

class _ArchitecturePlugin extends Plugin {
  @override
  String get name => 'lint_arch';

  // Warning rules are enabled by default, so the app does not have to list them in analysis_options.yaml.
  @override
  void register(PluginRegistry registry) {
    registry
      ..registerWarningRule(AvoidRelativeImports())
      ..registerWarningRule(AvoidCrossFeatureDependencyRule())
      ..registerWarningRule(InvalidFeatureLayeringRule())
      ..registerWarningRule(InvalidModuleDependencyRule())
      ..registerWarningRule(InvalidAppLayerDependencyRule())
      ..registerWarningRule(InvalidFeatureLayerDependencyRule())
      ..registerWarningRule(InvalidCommonLayerDependencyRule());
  }
}
