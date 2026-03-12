import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_app_bar.dart';
import 'package:zachranobed/features/faq/domain/model/faq_item.dart';
import 'package:zachranobed/features/faq/presentation/widget/faq_question_list_view.dart';

/// Screen that displays a list of FAQ questions for a given category.
@RoutePage()
class FaqQuestionsScreen extends StatelessWidget {
  final List<FaqItem> items;

  const FaqQuestionsScreen({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      appBar: UiAppBar(
        title: context.l10n.faqTitle,
      ),
      builder: (context) {
        return FaqQuestionListView(items: items);
      },
    );
  }
}
