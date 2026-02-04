import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/domain/model/canteen.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/other/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/page/error_page.dart';
import 'package:zachranobed/common/presentation/widget/page/info_page.dart';
import 'package:zachranobed/common/presentation/widget/page/loading_page.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/ui_app_bar.dart';
import 'package:zachranobed/features/food/domain/model/offered_food.dart';
import 'package:zachranobed/features/food/domain/usecase/observe_delivery_meals_use_case.dart';
import 'package:zachranobed/features/food/presentation/widget/meal_tile_factory.dart';

/// A screen that displays the details of a specific delivery including its meals.
///
/// This screen shows a realtime list of meals for a given delivery ID,
/// with different UI for Canteen and Charity users.
@RoutePage()
class DeliveryDetailScreen extends StatefulWidget {
  /// The ID of the delivery to display.
  final String deliveryId;

  const DeliveryDetailScreen({
    super.key,
    required this.deliveryId,
  });

  @override
  State<DeliveryDetailScreen> createState() => _DeliveryDetailScreenState();
}

class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
  late Stream<Iterable<OfferedFood>> _stream;
  Object? _streamKey;

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  @override
  void didUpdateWidget(covariant DeliveryDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deliveryId != widget.deliveryId) {
      _initStream();
    }
  }

  void _initStream() {
    final useCase = GetIt.I<ObserveDeliveryMealsUseCase>();
    _stream = useCase.invoke(widget.deliveryId);
    _streamKey = Object();
  }

  void _retry() {
    setState(() {
      _initStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = HelperService.getCurrentUser(context);
    final isCanteen = user is Canteen;

    return StreamBuilder<Iterable<OfferedFood>>(
      key: ValueKey(_streamKey),
      stream: _stream,
      builder: (_, snapshot) {
        return ScreenScaffold.universalBuilder(
          appBar: UiAppBar(title: context.l10n.deliveryDetailTitle),
          builder: (context) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPage();
            }
            if (snapshot.hasError) {
              return ErrorPage(onRetryPressed: _retry);
            }
            final meals = snapshot.data?.toList() ?? [];
            if (meals.isEmpty) {
              if (isCanteen) {
                return _buildCanteenEmptyState(context);
              } else {
                return _buildCharityEmptyPage(context);
              }
            }
            return _buildContent(context, isCanteen, meals);
          },
        );
      },
    );
  }

  Widget _buildCanteenEmptyState(BuildContext context) {
    return InfoPage(
      image: ImageAssets.imageEmptyMeals,
      title: context.l10n.deliveryDetailEmptyCanteenTitle,
      description: context.l10n.deliveryDetailEmptyCanteenDescription,
      actions: [
        UiPrimaryButton(
          size: UiButtonSize.medium(fullWidth: true),
          text: context.l10n.deliveryDetailAddMealsAction,
          onPressed: () => context.pushRoute(const OfferFoodInitialRoute()),
        ),
        const SizedBox(height: 16),
        UiTextButton(
          size: UiButtonSize.medium(fullWidth: true),
          text: context.l10n.commonClose,
          onPressed: () => context.maybePop(),
        ),
      ],
    );
  }

  Widget _buildCharityEmptyPage(BuildContext context) {
    return InfoPage(
      image: ImageAssets.imageEmptyMeals,
      title: context.l10n.deliveryDetailEmptyCharityTitle,
      description: context.l10n.deliveryDetailEmptyCharityDescription,
      actions: [
        UiPrimaryButton(
          size: UiButtonSize.medium(fullWidth: true),
          text: context.l10n.commonBack,
          onPressed: () => context.maybePop(),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isCanteen,
    List<OfferedFood> meals,
  ) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: [
                  Text(
                    isCanteen
                        ? context.l10n.deliveryDetailCanteenDescription
                        : context.l10n.deliveryDetailCharityDescription,
                    style: context.textStyles.bodyLarge,
                  ),
                  ...meals.map((item) => MealTileFactory.buildMealTile(context, item)),
                ],
              ),
            ),
          ),
        ),
        _buildBottomButtons(context, isCanteen),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context, bool isCanteen) {
    final isMobileLayout = context.watch<AdaptiveLayoutConfig>().isMobile;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Flex(
        spacing: 16.0,
        direction: isMobileLayout ? Axis.vertical : Axis.horizontal,
        children: [
          if (isCanteen)
            UiOutlineButton(
              size: UiButtonSize.medium(fullWidth: isMobileLayout),
              text: context.l10n.deliveryDetailAddMealsAction,
              onPressed: () => context.pushRoute(OfferFoodInitialRoute()),
            ),
          UiPrimaryButton(
            size: UiButtonSize.medium(fullWidth: isMobileLayout),
            text: context.l10n.commonClose,
            onPressed: () => context.maybePop(),
          ),
        ],
      ),
    );
  }
}
