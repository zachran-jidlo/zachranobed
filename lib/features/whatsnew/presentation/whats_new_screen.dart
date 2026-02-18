import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/progress/ui_page_indicator.dart';

/// Data class representing a single page in the What's New screen.
class _WhatsNewPageData {
  final String image;
  final String title;
  final String description;

  const _WhatsNewPageData({
    required this.image,
    required this.title,
    required this.description,
  });
}

/// A screen that displays new features and updates to users.
///
/// Shows a paginated carousel with different content for canteen and charity users.
/// Each page displays a phone mockup image, title, and description.
/// Users can skip through pages or close on the last page.
@RoutePage()
class WhatsNewScreen extends StatefulWidget {
  /// Creates a [WhatsNewScreen].
  const WhatsNewScreen({super.key});

  @override
  State<WhatsNewScreen> createState() => _WhatsNewScreenState();
}

class _WhatsNewScreenState extends State<WhatsNewScreen> {
  static const double _textHorizontalPadding = 32.0;

  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = HelperService.getCurrentUser(context);
    if (user == null) {
      return const SizedBox.shrink();
    }

    final pages = _getPages(context, user);

    return ScreenScaffold.universalBuilder(
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth - _textHorizontalPadding * 2;
            final descriptions = pages.map((e) => e.description).toList();
            final style = context.textStyles.bodyLarge;
            final descriptionHeight = _calculateMaxHeight(context, availableWidth, descriptions, style);

            return _buildContent(context, pages, descriptionHeight);
          },
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, List<_WhatsNewPageData> pages, double descriptionHeight) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          top: 90,
          child: SvgPicture.asset(ImageAssets.imageWhatsNewBackground),
        ),
        Column(
          children: [
            _buildTopBar(context, pages.length),
            Expanded(
              child: _buildPageView(context, pages, descriptionHeight),
            ),
            _buildBottomSection(context, pages.length),
          ],
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context, int pageCount) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: UiTextButton(
          text: context.l10n.commonClose,
          onPressed: () => context.router.maybePop(),
        ),
      ),
    );
  }

  Widget _buildPageView(
    BuildContext context,
    List<_WhatsNewPageData> pages,
    double descriptionHeight,
  ) {
    return PageView.builder(
      controller: _pageController,
      itemCount: pages.length,
      itemBuilder: (context, index) {
        final page = pages[index];
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.08, 0.92, 1.0],
                  ).createShader(bounds),
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(
                    page.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _textHorizontalPadding),
              child: Text(
                page.title,
                style: context.textStyles.displaySmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _textHorizontalPadding),
              child: SizedBox(
                height: descriptionHeight,
                child: Text(
                  page.description,
                  style: context.textStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomSection(BuildContext context, int pageCount) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: UiPageIndicator(
        controller: _pageController,
        pageCount: pageCount,
      ),
    );
  }

  List<_WhatsNewPageData> _getPages(BuildContext context, UserData user) {
    final l10n = context.l10n;
    switch (user) {
      case Canteen():
        return [
          _WhatsNewPageData(
            image: ImageAssets.imageWhatsNewCanteen1,
            title: l10n.whatsNewTitle1,
            description: l10n.whatsNewDescription1,
          ),
          _WhatsNewPageData(
            image: ImageAssets.imageWhatsNewCanteen2,
            title: l10n.whatsNewTitle2,
            description: l10n.whatsNewDescription2,
          ),
          _WhatsNewPageData(
            image: ImageAssets.imageWhatsNewCanteen3,
            title: l10n.whatsNewTitle3,
            description: l10n.whatsNewDescription3,
          ),
          _WhatsNewPageData(
            image: ImageAssets.imageWhatsNewCanteen4,
            title: l10n.whatsNewTitle4,
            description: l10n.whatsNewDescription4,
          ),
          _WhatsNewPageData(
            image: ImageAssets.imageWhatsNewCanteen5,
            title: l10n.whatsNewTitle5,
            description: l10n.whatsNewDescription5,
          ),
        ];
      case Charity():
        return [
          _WhatsNewPageData(
            image: ImageAssets.imageWhatsNewCharity1,
            title: l10n.whatsNewTitle1,
            description: l10n.whatsNewDescription1,
          ),
          _WhatsNewPageData(
            image: ImageAssets.imageWhatsNewCharity2,
            title: l10n.whatsNewTitle2,
            description: l10n.whatsNewDescription2,
          ),
          _WhatsNewPageData(
            image: ImageAssets.imageWhatsNewCharity3,
            title: l10n.whatsNewTitle3,
            description: l10n.whatsNewDescription3,
          ),
          _WhatsNewPageData(
            image: ImageAssets.imageWhatsNewCharity4,
            title: l10n.whatsNewTitle4,
            description: l10n.whatsNewDescription4,
          ),
          _WhatsNewPageData(
            image: ImageAssets.imageWhatsNewCharity5,
            title: l10n.whatsNewTitle5,
            description: l10n.whatsNewDescription5,
          ),
        ];
    }
  }

  double _calculateMaxHeight(
    BuildContext context,
    double width,
    List<String> descriptions,
    TextStyle style,
  ) {
    double height = 0;
    final textScaler = MediaQuery.textScalerOf(context);

    for (var text in descriptions) {
      final tp = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
      )..layout(maxWidth: width);

      height = max(height, tp.height);
    }

    return height;
  }
}
