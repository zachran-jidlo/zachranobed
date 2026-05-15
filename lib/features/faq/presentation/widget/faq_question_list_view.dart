import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_list_tile.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_gradient_icon.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_icon.dart';
import 'package:zachranobed/common/presentation/widget/layout/sectioned_list_view.dart';
import 'package:zachranobed/features/faq/domain/model/faq_item.dart';

/// Reusable widget that renders a list of FAQ questions.
class FaqQuestionListView extends StatelessWidget {
  final List<FaqItem> items;

  const FaqQuestionListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SectionedListView(
      entries: items.map<SectionedListEntry<Widget>>((item) {
        return SectionedListItem(
          UiListTile(
            title: item.question,
            end: UiGradientIcon(
              spec: UiIconSpec.data(Icons.chevron_right),
              gradient: context.uiColors.primaryGradient,
              size: 24,
            ),
            onPressed: () {
              context.pushRoute(FaqDetailRoute(item: item));
            },
          ),
        );
      }).toList(),
    );
  }
}
