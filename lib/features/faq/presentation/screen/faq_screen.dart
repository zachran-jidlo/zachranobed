import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/utils/iterable_utils.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_list_tile.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_gradient_icon.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_icon.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/layout/sectioned_list_view.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/page/error_page.dart';
import 'package:zachranobed/common/presentation/widget/page/loading_page.dart';
import 'package:zachranobed/features/faq/domain/model/faq_category.dart';
import 'package:zachranobed/features/faq/domain/model/faq_item.dart';
import 'package:zachranobed/features/faq/domain/usecase/observe_faq_items_use_case.dart';
import 'package:zachranobed/features/faq/presentation/widget/faq_question_list_view.dart';

/// Entry point screen for FAQ. Shows categories if multiple exist,
/// otherwise goes directly to the questions list.
class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late final Stream<List<FaqItem>> _faqStream = GetIt.I<ObserveFaqItemsUseCase>().invoke();

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      appBar: UiAppBar(
        title: context.l10n.faqTitle,
      ),
      builder: (context) {
        return StreamBuilder<List<FaqItem>>(
          stream: _faqStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingPage();
            }
            if (snapshot.hasError || snapshot.data == null) {
              return ErrorPage();
            }
            return _buildContent(snapshot.data!);
          },
        );
      },
    );
  }

  Widget _buildContent(List<FaqItem> items) {
    final categories = items.mapNotNull((item) => item.category).toSet().sortedBy<num>((category) => category.order);

    if (categories.length > 1) {
      return _buildCategoryList(categories, items);
    }

    return FaqQuestionListView(items: items);
  }

  Widget _buildCategoryList(List<FaqCategory> categories, List<FaqItem> allItems) {
    return SectionedListView(
      entries: categories.map<SectionedListEntry<Widget>>((category) {
        return SectionedListItem(
          UiListTile(
            title: category.title,
            supportingText: category.description,
            end: UiGradientIcon(
              spec: UiIconSpec.data(Icons.chevron_right),
              gradient: context.uiColors.primaryGradient,
              size: 24,
            ),
            onPressed: () {
              final categoryItems = allItems.where((item) => item.category?.id == category.id).toList();
              context.pushRoute(
                FaqQuestionsRoute(
                  items: categoryItems,
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
