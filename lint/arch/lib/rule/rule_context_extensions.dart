import 'package:analyzer/analysis_rule/rule_context.dart';

extension RuleContextPath on RuleContext {
  /// Path of the compilation unit being visited. Falls back to the library file outside of visits.
  String get currentPath => currentUnit?.file.path ?? definingUnit.file.path;
}
