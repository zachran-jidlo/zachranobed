import 'package:auto_route/annotations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_fill_icon_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_icon_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_icon_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/donation/ui_donation_countdown_label.dart';
import 'package:zachranobed/common/presentation/widget/donation/ui_donation_status_card.dart';
import 'package:zachranobed/common/presentation/widget/donation/ui_donation_time_range_label.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_nav_bar.dart';
import 'package:zachranobed/common/presentation/widget/progress/ui_page_indicator.dart';
import 'package:zachranobed/common/presentation/widget/progress/ui_progress_bar.dart';
import 'package:zachranobed/common/presentation/widget/progress/ui_progress_stepper.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_box_counter_tile.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_change_pair_tile.dart';
import 'package:zachranobed/common/presentation/widget/chip/ui_chip.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_contact_tile.dart';
import 'package:zachranobed/common/presentation/widget/form/ui_counter_field.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_food_box_return_tile.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_food_box_tile.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_gradient_icon.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_icon.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_list_tile.dart';
import 'package:zachranobed/common/presentation/widget/chip/ui_meal_badge.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_meal_tile.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_navigation_drawer_item.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_notification_tile.dart';
import 'package:zachranobed/common/presentation/widget/form/ui_password_text_field.dart';
import 'package:zachranobed/common/presentation/widget/form/ui_text_field.dart';

@RoutePage()
class ComponentsScreen extends StatelessWidget {
  const ComponentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universal(
      appBar: const UiAppBar(
        title: "Components screen",
      ),
      child: CustomScrollView(
        slivers: [
          const _Header.h1("Typography"),
          const _TypographyComponents(),
          const _Header.h1("Icons"),
          const _IconComponents(),
          const _Header.h1("Buttons"),
          const _Header.h2("Text buttons"),
          const _TextButtonComponents(),
          const _Header.h2("Primary buttons"),
          const _PrimaryButtonComponents(),
          const _Header.h2("Outline buttons"),
          const _OutlineButtonComponents(),
          const _Header.h2("Icon buttons"),
          const _IconButtonComponents(),
          const _Header.h1("Navigation"),
          const _NavigationComponents(),
          const _Header.h1("Navigation drawer items"),
          const _NavigationDrawerItemComponents(),
          const _Header.h1("Progress"),
          _ProgressComponents(),
          const _Header.h1("Chips"),
          const _ChipComponents(),
          const _Header.h1("Text fields"),
          _TextFieldComponents(),
          const _Header.h1("Food box tiles"),
          const _FoodBoxTileComponents(),
          const _Header.h1("Food box return tiles"),
          const _FoodBoxReturnTileComponents(),
          const _Header.h1("Box counter tiles"),
          _BoxCounterTileComponents(),
          const _Header.h1("Notification tiles"),
          const _NotificationTileComponents(),
          const _Header.h1("Meal tiles"),
          const _MealTileComponents(),
          const _Header.h1("List tiles"),
          const _ListTileComponents(),
          const _Header.h1("Contact tiles"),
          const _ContactTileComponents(),
          const _Header.h1("Change pair tiles"),
          const _ChangePairTileComponents(),
          const _Header.h1("Donation status cards"),
          const _DonationStatusCardComponents(),
        ],
      ),
    );
  }
}

enum _HeaderSize {
  h1,
  h2,
  h3,
}

class _Header extends StatelessWidget {
  final String text;
  final _HeaderSize size;

  const _Header.h1(this.text) : size = _HeaderSize.h1;

  const _Header.h2(this.text) : size = _HeaderSize.h2;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 24,
          bottom: 16,
          left: 16,
          right: 16,
        ),
        child: Text(
          text,
          style: _getStyle(context),
        ),
      ),
    );
  }

  TextStyle? _getStyle(BuildContext context) {
    switch (size) {
      case _HeaderSize.h1:
        return context.textStyles.headlineLarge;
      case _HeaderSize.h2:
        return context.textStyles.headlineMedium;
      case _HeaderSize.h3:
        return context.textStyles.headlineSmall;
    }
  }
}

class _TypographyComponents extends StatelessWidget {
  const _TypographyComponents();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24.0,
          children: [
            _TypographyRow(
              label: 'Display Large',
              details: 'Futura PT Medium 57/64 . 0',
              style: context.textStyles.displayLarge,
            ),
            _TypographyRow(
              label: 'Display Medium',
              details: 'Futura PT Medium 45/52 . 0',
              style: context.textStyles.displayMedium,
            ),
            _TypographyRow(
              label: 'Display Small',
              details: 'Futura PT 36/44 . 0',
              style: context.textStyles.displaySmall,
            ),
            const SizedBox(height: 8),
            _TypographyRow(
              label: 'Headline Heavy',
              details: 'Futura PT Bold 32/40 . 0',
              style: context.textStyles.headlineHeavy,
            ),
            _TypographyRow(
              label: 'Headline Large',
              details: 'Futura PT 32/40 . 0',
              style: context.textStyles.headlineLarge,
            ),
            _TypographyRow(
              label: 'Headline Medium',
              details: 'Futura PT 28/36 . 0',
              style: context.textStyles.headlineMedium,
            ),
            _TypographyRow(
              label: 'Headline Small',
              details: 'Futura PT 24/32 . 0',
              style: context.textStyles.headlineSmall,
            ),
            const SizedBox(height: 8),
            _TypographyRow(
              label: 'Title Heavy',
              details: 'Futura PT Bold 22/28 . 0',
              style: context.textStyles.titleHeavy,
            ),
            _TypographyRow(
              label: 'Title Large',
              details: 'Futura PT 22/28 . 0',
              style: context.textStyles.titleLarge,
            ),
            _TypographyRow(
              label: 'Title Medium',
              details: 'Futura PT SemiBold 16/24 . +0.15',
              style: context.textStyles.titleMedium,
            ),
            _TypographyRow(
              label: 'Title Small',
              details: 'Futura PT Medium 14/20 . +0.1',
              style: context.textStyles.titleSmall,
            ),
            const SizedBox(height: 8),
            _TypographyRow(
              label: 'Label Large',
              details: 'Plus Jakarta Sans Bold 14/20 . 0',
              style: context.textStyles.labelLarge,
            ),
            _TypographyRow(
              label: 'Label Medium',
              details: 'Plus Jakarta Sans Medium 12/16 . 0',
              style: context.textStyles.labelMedium,
            ),
            _TypographyRow(
              label: 'Label Small',
              details: 'Plus Jakarta Sans Medium 11/16 . 0',
              style: context.textStyles.labelSmall,
            ),
            const SizedBox(height: 8),
            _TypographyRow(
              label: 'Body Large',
              details: 'Plus Jakarta Sans 16/24 . +0.5',
              style: context.textStyles.bodyLarge,
            ),
            _TypographyRow(
              label: 'Body Medium',
              details: 'Plus Jakarta Sans 14/20 . +0.25',
              style: context.textStyles.bodyMedium,
            ),
            _TypographyRow(
              label: 'Body Small',
              details: 'Plus Jakarta Sans Medium 12/16 . +0.4',
              style: context.textStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _TypographyRow extends StatelessWidget {
  final String label;
  final String details;
  final TextStyle style;

  const _TypographyRow({
    required this.label,
    required this.details,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "$label - $details",
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _IconComponents extends StatelessWidget {
  const _IconComponents();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Material icons'),
            const SizedBox(height: 4),
            Row(
              spacing: 16.0,
              children: [
                UiIcon(
                  spec: UiIconSpec.data(Icons.home),
                ),
                UiIcon(
                  spec: UiIconSpec.data(Icons.favorite),
                ),
                UiIcon(
                  spec: UiIconSpec.data(Icons.star),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Custom icons'),
            const SizedBox(height: 4),
            Row(
              spacing: 16.0,
              children: [
                UiIcon(
                  spec: UiIconSpec.svg(ImageAssets.iconDeliveryRun),
                ),
                UiIcon(
                  spec: UiIconSpec.svg(ImageAssets.iconDeliveryAccept),
                ),
                UiIcon(
                  spec: UiIconSpec.svg(ImageAssets.iconAllergens),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Gradient icons'),
            const SizedBox(height: 4),
            Row(
              spacing: 16.0,
              children: [
                UiGradientIcon(
                  spec: UiIconSpec.data(Icons.favorite),
                  gradient: context.uiColors.primaryGradient,
                  size: 24,
                ),
                UiGradientIcon(
                  spec: UiIconSpec.data(Icons.star),
                  gradient: context.uiColors.primaryGradient,
                  size: 24,
                ),
                UiGradientIcon(
                  spec: UiIconSpec.svg(ImageAssets.iconDeliveryRun),
                  gradient: context.uiColors.primaryGradient,
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TextButtonComponents extends StatelessWidget {
  const _TextButtonComponents();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            UiTextButton(
              text: 'Změnit',
              onPressed: () {},
            ),
            UiTextButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
            ),
            UiTextButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
              enabled: false,
            ),
            UiTextButton(
              text: 'Změnit',
              onPressed: () {},
              size: UiButtonSize.medium(),
            ),
            UiTextButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
              size: UiButtonSize.medium(),
            ),
            UiTextButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
              enabled: false,
              size: UiButtonSize.medium(),
            ),
            UiTextButton(
              text: 'Změnit',
              onPressed: () {},
              size: UiButtonSize.large(),
            ),
            UiTextButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
              size: UiButtonSize.large(),
            ),
            UiTextButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
              enabled: false,
              size: UiButtonSize.large(),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlineButtonComponents extends StatelessWidget {
  const _OutlineButtonComponents();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            UiOutlineButton(
              text: 'Změnit',
              onPressed: () {},
            ),
            UiOutlineButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
            ),
            UiOutlineButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
              enabled: false,
            ),
            UiOutlineButton(
              text: 'Změnit',
              onPressed: () {},
              size: UiButtonSize.medium(),
            ),
            UiOutlineButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
              size: UiButtonSize.medium(),
            ),
            UiOutlineButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
              enabled: false,
              size: UiButtonSize.medium(),
            ),
            UiOutlineButton(
              text: 'Změnit',
              onPressed: () {},
              size: UiButtonSize.large(),
            ),
            UiOutlineButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
              size: UiButtonSize.large(),
            ),
            UiOutlineButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
              enabled: false,
              size: UiButtonSize.large(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButtonComponents extends StatelessWidget {
  const _PrimaryButtonComponents();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            UiPrimaryButton(
              text: 'Změnit',
              onPressed: () {},
            ),
            UiPrimaryButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
            ),
            UiPrimaryButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
              enabled: false,
            ),
            UiPrimaryButton(
              text: 'Změnit',
              onPressed: () {},
              size: UiButtonSize.medium(),
            ),
            UiPrimaryButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
              size: UiButtonSize.medium(),
            ),
            UiPrimaryButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
              enabled: false,
              size: UiButtonSize.medium(),
            ),
            UiPrimaryButton(
              text: 'Změnit',
              onPressed: () {},
              size: UiButtonSize.large(),
            ),
            UiPrimaryButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
              size: UiButtonSize.large(),
            ),
            UiPrimaryButton(
              text: 'Změnit',
              onPressed: () {},
              icon: Icons.sync,
              enabled: false,
              size: UiButtonSize.large(),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButtonComponents extends StatelessWidget {
  const _IconButtonComponents();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            Row(
              spacing: 16.0,
              children: [
                UiIconFillButton(
                  onPressed: () {},
                  icon: Icons.add,
                ),
                UiIconFillButton(
                  onPressed: () {},
                  icon: Icons.add,
                  enabled: false,
                ),
              ],
            ),
            Row(
              spacing: 16.0,
              children: [
                UiIconOutlineButton(
                  onPressed: () {},
                  icon: Icons.remove,
                ),
                UiIconOutlineButton(
                  onPressed: () {},
                  icon: Icons.remove,
                  enabled: false,
                ),
              ],
            ),
            Row(
              spacing: 16.0,
              children: [
                UiIconButton.gradient(
                  onPressed: () {},
                  icon: Icons.favorite,
                ),
                UiIconButton.gradient(
                  onPressed: () {},
                  icon: Icons.favorite,
                  enabled: false,
                ),
              ],
            ),
            Row(
              spacing: 16.0,
              children: [
                UiIconButton.solid(
                  onPressed: () {},
                  icon: Icons.close,
                ),
                UiIconButton.solid(
                  onPressed: () {},
                  icon: Icons.close,
                  enabled: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationComponents extends StatefulWidget {
  const _NavigationComponents();

  @override
  State<_NavigationComponents> createState() => _NavigationComponentsState();
}

class _NavigationComponentsState extends State<_NavigationComponents>
    with SingleTickerProviderStateMixin {
  static const List<UiNavBarItem> items = [
    UiNavBarItem(icon: UiIconSpec.data(Icons.home_rounded), label: 'Přehled'),
    UiNavBarItem(icon: UiIconSpec.svg(ImageAssets.iconHistory), label: 'Historie'),
    UiNavBarItem(icon: UiIconSpec.data(Icons.notifications), label: 'Notifikace'),
  ];

  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: items.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            UiNavBar(
              controller: _controller,
              items: items,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationDrawerItemComponents extends StatefulWidget {
  const _NavigationDrawerItemComponents();

  @override
  State<_NavigationDrawerItemComponents> createState() =>
      _NavigationDrawerItemComponentsState();
}

class _NavigationDrawerItemComponentsState extends State<_NavigationDrawerItemComponents> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            SizedBox(
              width: 220.0,
              child: Column(
                spacing: 8.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  UiNavigationDrawerItem(
                    label: 'Přehled',
                    icon: UiIconSpec.data(Icons.home_rounded),
                    selected: _selectedIndex == 0,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                  ),
                  UiNavigationDrawerItem(
                    label: 'Historie',
                    icon: UiIconSpec.svg(ImageAssets.iconHistory),
                    selected: _selectedIndex == 1,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                  ),
                  UiNavigationDrawerItem(
                    label: 'Notifikace',
                    icon: UiIconSpec.data(Icons.notifications),
                    selected: _selectedIndex == 2,
                    showIndicator: true,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressComponents extends StatefulWidget {
  @override
  State<_ProgressComponents> createState() => _ProgressComponentsState();
}

class _ProgressComponentsState extends State<_ProgressComponents> {
  int _currentStep = 2;
  bool _isCurrentStepActive = true;
  bool _isProgressComplete = false;

  int _currentProgress = 5;
  final int _maxProgress = 10;

  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            Text(
              'Current step: ${_currentStep + 1} '
              '\nCurrent step active: $_isCurrentStepActive '
              '\nProgress complete: $_isProgressComplete',
            ),
            UiProgressStepper(
              currentStep: _currentStep,
              isCurrentStepActive: _isCurrentStepActive,
              isProgressComplete: _isProgressComplete,
              icons: const [
                UiIconSpec.data(Icons.today_rounded),
                UiIconSpec.data(Icons.food_bank_rounded),
                UiIconSpec.data(Icons.shopping_bag_rounded),
                UiIconSpec.data(Icons.moped_rounded),
                UiIconSpec.data(Icons.check_circle_rounded),
              ],
            ),
            Row(
              spacing: 16.0,
              children: [
                UiIconFillButton(
                  onPressed: () {
                    setState(() {
                      if (!_isCurrentStepActive) {
                        _isCurrentStepActive = true;
                      } else if (_currentStep < 4) {
                        _currentStep += 1;
                        _isCurrentStepActive = false;
                      } else {
                        _isProgressComplete = true;
                      }
                    });
                  },
                  icon: Icons.add,
                  enabled: !_isProgressComplete,
                ),
                UiIconOutlineButton(
                  onPressed: () {
                    setState(() {
                      if (_isProgressComplete) {
                        _isProgressComplete = false;
                      } else if (_isCurrentStepActive) {
                        _isCurrentStepActive = false;
                      } else {
                        _currentStep -= 1;
                        _isCurrentStepActive = true;
                      }
                    });
                  },
                  icon: Icons.remove,
                  enabled: _currentStep > 0 || _isCurrentStepActive,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Progress: ${_currentProgress.toDouble() / _maxProgress * 100}%',
            ),
            UiProgressBar(
              progress: _currentProgress.toDouble() / _maxProgress,
            ),
            Row(
              spacing: 16.0,
              children: [
                UiIconFillButton(
                  onPressed: () {
                    setState(() {
                      _currentProgress += 1;
                    });
                  },
                  icon: Icons.add,
                  enabled: _currentProgress < _maxProgress,
                ),
                UiIconOutlineButton(
                  onPressed: () {
                    setState(() {
                      _currentProgress -= 1;
                    });
                  },
                  icon: Icons.remove,
                  enabled: _currentProgress > 0,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text('Page Indicator:'),
            SizedBox(
              height: 100,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Text(
                        'Page ${index + 1}',
                        style: context.textStyles.headlineMedium,
                      ),
                    );
                  },
                ),
              ),
            ),
            Center(
              child: UiPageIndicator(
                controller: _pageController,
                pageCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipComponents extends StatelessWidget {
  const _ChipComponents();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          spacing: 16.0,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.0,
              children: [
                UiChip(
                  text: "Dnes",
                  onPressed: () {},
                ),
                UiChip(
                  text: "Dnes",
                  onPressed: () {},
                  enabled: false,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.0,
              children: [
                UiChip(
                  text: "Dnes",
                  onPressed: () {},
                  selected: true,
                ),
                UiChip(
                  text: "Dnes",
                  onPressed: () {},
                  enabled: false,
                  selected: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TextFieldComponents extends StatefulWidget {
  @override
  State<_TextFieldComponents> createState() => _TextFieldComponentsState();
}

class _TextFieldComponentsState extends State<_TextFieldComponents> {
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController(text: 'Input text');
  final _controller5 = TextEditingController(text: 'Input text');
  final _controller6 = TextEditingController(text: 'Error text');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: context.uiColors.surfaceGray,
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 32.0,
          children: [
            UiTextField(
              controller: _controller1,
              hintText: 'Basic',
            ),
            UiTextField(
              controller: _controller2,
              hintText: 'With label',
              labelText: 'Label',
            ),
            UiTextField(
              controller: _controller3,
              hintText: 'With label and supporting text',
              labelText: 'Label',
              supportingText: 'Supporting text',
            ),
            UiTextField(
              controller: _controller4,
              labelText: 'Label',
              supportingText: 'With trailing button',
              trailingIcon: Icons.cancel,
              onTrailingIconPressed: () {
                _controller4.clear();
              },
            ),
            UiTextField(
              controller: _controller5,
              labelText: 'Label',
              supportingText: 'With leading button',
              leadingIcon: Icons.search,
              trailingIcon: Icons.cancel,
              onTrailingIconPressed: () {
                _controller5.clear();
              },
            ),
            UiTextField(
              controller: _controller6,
              labelText: 'Label',
              errorText: 'Error message',
              trailingIcon: Icons.error,
            ),
            const UiTextField(
              labelText: 'Label',
              hintText: 'Input text',
              supportingText: 'enabled: false',
              enabled: false,
            ),
            Form(
              key: _formKey,
              child: UiTextField(
                labelText: 'Label',
                hintText: 'Enter at least 3 characters',
                supportingText: 'Validates on form submit',
                onValidation: (value) {
                  if (value == null || value.length < 3) {
                    return 'Minimum 3 characters required';
                  }
                  return null;
                },
                trailingIcon: Icons.check_circle_rounded,
                onTrailingIconPressed: () {
                  _formKey.currentState?.validate();
                },
              ),
            ),
            UiTextField(
              labelText: 'Label',
              hintText: 'Enter numbers',
              supportingText: 'Numbers only',
              textInputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
            const UiTextField(
              labelText: 'Label',
              initialValue: 'Cannot edit this',
              supportingText: 'readOnly: true',
              readOnly: true,
            ),
            const UiTextField(
              labelText: 'Label',
              supportingText: 'disableAutocorrect: true',
              disableAutocorrect: true,
            ),
            const UiPasswordTextField(
              labelText: 'Password',
              hintText: 'Enter password',
              supportingText: 'Password field with visibility toggle',
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodBoxTileComponents extends StatelessWidget {
  const _FoodBoxTileComponents();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            // Small size - two in a row
            Row(
              spacing: 16.0,
              children: [
                Expanded(
                  child: UiFoodBoxTile(
                    title: 'REkrabička',
                    stats: [
                      UiFoodBoxTileStat(value: 16, label: 'K dispozici'),
                    ],
                  ),
                ),
                Expanded(
                  child: UiFoodBoxTile(
                    title: 'IKEA velká',
                    stats: [
                      UiFoodBoxTileStat(value: 24, label: 'K dispozici'),
                    ],
                  ),
                ),
              ],
            ),
            // Full size - Jídelna type
            UiFoodBoxTile(
              title: 'REkrabička',
              size: UiFoodBoxTileSize.full,
              totalLabel: 'Celkem 34 ks',
              stats: [
                UiFoodBoxTileStat(value: 8, label: 'K dispozici'),
                UiFoodBoxTileStat(value: 18, label: 'Jídelna'),
              ],
            ),
            // Full size - Charita type
            UiFoodBoxTile(
              title: 'REkrabička',
              size: UiFoodBoxTileSize.full,
              totalLabel: 'Celkem 34 ks',
              stats: [
                UiFoodBoxTileStat(value: 8, label: 'K dispozici'),
                UiFoodBoxTileStat(value: 18, label: 'Charita'),
              ],
            ),
            // Full size - Selected state (Jídelna)
            UiFoodBoxTile(
              title: 'REkrabička',
              size: UiFoodBoxTileSize.full,
              totalLabel: 'Celkem 34 ks',
              isSelected: true,
              stats: [
                UiFoodBoxTileStat(value: 8, label: 'K dispozici'),
                UiFoodBoxTileStat(value: 18, label: 'Jídelna'),
              ],
            ),
            // Full size - Selected state (Charita)
            UiFoodBoxTile(
              title: 'REkrabička',
              size: UiFoodBoxTileSize.full,
              totalLabel: 'Celkem 34 ks',
              isSelected: true,
              stats: [
                UiFoodBoxTileStat(value: 8, label: 'K dispozici'),
                UiFoodBoxTileStat(value: 18, label: 'Charita'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodBoxReturnTileComponents extends StatelessWidget {
  const _FoodBoxReturnTileComponents();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            UiFoodBoxReturnTile(
              title: 'Charita zadala vratku krabiček',
              subtitle: 'Krabičky na cestě k vám',
              count: 15,
              progress: 0.2,
            ),
            UiFoodBoxReturnTile(
              title: 'Dnes vám budou doručeny vratné krabičky',
              subtitle: 'Krabičky na cestě k vám',
              count: 15,
              progress: 0.8,
              action: UiOutlineButton(
                text: 'Přijmout krabičky',
                onPressed: () {},
              ),
            ),
            UiFoodBoxReturnTile(
              title: 'Krabičky na cestě k vám',
              subtitle: 'Celkem',
              count: 15,
            ),
            UiFoodBoxReturnTile(
              title: 'Krabičky na cestě k vám',
              subtitle: 'Celkem',
              count: 15,
              action: UiPrimaryButton(
                text: 'Potvrdit doručení',
                onPressed: () {},
                icon: Icons.check,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTileComponents extends StatelessWidget {
  const _NotificationTileComponents();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            UiNotificationTile(
              title: 'Kontrola krabiček',
              description: 'Je potřeba provést pravidelnou kontrolu vratných krabiček.',
              icon: Icons.warning_rounded,
              trailing: UiIconButton.solid(
                icon: Icons.close,
                onPressed: () {},
              ),
              actions: [
                UiOutlineButton(
                  text: 'Zkontrolovat',
                  onPressed: () {},
                  size: UiButtonSize.medium(),
                )
              ],
            ),
            UiNotificationTile(
              title: 'Nahlášen nesoulad',
              icon: Icons.warning_rounded,
              iconColor: context.uiColors.warning,
              trailing: UiIconButton.gradient(
                icon: Icons.info_outline,
                onPressed: () {},
              ),
            ),
            UiNotificationTile(
              title: 'Kontrola krabiček',
              description: 'Je potřeba provést pravidelnou kontrolu vratných krabiček.',
              icon: Icons.warning_rounded,
              trailing: UiIconButton.solid(
                icon: Icons.close,
                onPressed: () {},
              ),
              actions: [
                UiOutlineButton(
                  text: 'Později',
                  onPressed: () {},
                  size: UiButtonSize.medium(),
                ),
                UiPrimaryButton(
                  text: 'Zkontrolovat',
                  onPressed: () {},
                  size: UiButtonSize.medium(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BoxCounterTileComponents extends StatefulWidget {
  @override
  State<_BoxCounterTileComponents> createState() => _BoxCounterTileComponentsState();
}

class _BoxCounterTileComponentsState extends State<_BoxCounterTileComponents> {
  int _donationValue = 3;
  int _returnValue = 3;
  int _checkValue = 8;
  int _validationValue = 8;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            UiBoxCounterTile(
              title: 'REkrabička',
              subtitle: 'Celkem krabiček: 30',
              counterField: UiCounterField(
                label: 'Počet krabiček',
                value: _donationValue,
                minValue: 0,
                maxValue: 30,
                onChanged: (value) {
                  setState(() {
                    _donationValue = value;
                  });
                },
              ),
            ),
            UiBoxCounterTile(
              title: 'REkrabička',
              subtitle: 'Zadaný počet: 2',
              counterField: UiCounterField(
                label: 'Skutečný počet',
                value: _returnValue,
                minValue: 0,
                maxValue: 10,
                onChanged: (value) {
                  setState(() {
                    _returnValue = value;
                  });
                },
              ),
            ),
            UiBoxCounterTile(
              title: 'REkrabička',
              subtitle: 'Evidovaný počet: 8',
              counterField: UiCounterField(
                label: 'Skutečný počet',
                value: _checkValue,
                minValue: 0,
                maxValue: 20,
                onChanged: (value) {
                  setState(() {
                    _checkValue = value;
                  });
                },
              ),
            ),
            UiBoxCounterTile(
              title: 'REkrabička (disabled)',
              subtitle: 'Celkem krabiček: 30',
              counterField: UiCounterField(
                label: 'Počet krabiček',
                value: 3,
                enabled: false,
                onChanged: (value) {},
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                spacing: 8.0,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  UiBoxCounterTile(
                    title: 'REkrabička (max 100)',
                    subtitle: 'Evidovaný počet: 8',
                    counterField: UiCounterField(
                      label: 'Skutečný počet',
                      value: _validationValue,
                      onChanged: (value) {
                        setState(() {
                          _validationValue = value;
                        });
                      },
                      onValidation: (value) {
                        if (value > 100) {
                          return 'Maximum value is 100';
                        }
                        return null;
                      },
                    ),
                  ),
                  UiOutlineButton(
                    text: 'Validate',
                    onPressed: () {
                      _formKey.currentState?.validate();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonationStatusCardComponents extends StatelessWidget {
  const _DonationStatusCardComponents();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            UiDonationStatusCard(
              label: 'Darujete charitě',
              title: 'Most naděje, Praha 4',
              headerAction: UiTextButton(
                text: 'Změnit',
                icon: Icons.sync,
                onPressed: () {},
              ),
              statusSection: Text(
                'Dnes není pro tuto charitu den darování',
                style: context.textStyles.bodyMedium.copyWith(
                  color: context.uiColors.textSecondary,
                ),
              ),
            ),
            UiDonationStatusCard(
              label: 'Darujete charitě',
              title: 'Most naděje, Praha 4',
              headerAction: UiTextButton(
                text: 'Změnit',
                icon: Icons.sync,
                onPressed: () {},
              ),
              progressBar: UiProgressStepper(
                currentStep: 1,
                isCurrentStepActive: false,
                isProgressComplete: false,
                icons: const [
                  UiIconSpec.data(Icons.today_rounded),
                  UiIconSpec.svg(ImageAssets.iconDeliveryAccept),
                  UiIconSpec.data(Icons.food_bank_rounded),
                  UiIconSpec.svg(ImageAssets.iconDeliveryRun),
                  UiIconSpec.data(Icons.check_circle_rounded),
                ],
              ),
              statusSection: Text(
                'Dnes je den darování.',
                style: context.textStyles.bodyMedium.copyWith(
                  color: context.uiColors.textPrimary,
                ),
              ),
              actionInfo: UiDonationCountdownLabel(
                duration: const Duration(hours: 2, minutes: 39, seconds: 23),
                label: 'Zbývá pro potvrzení darování',
              ),
              actionButton: UiPrimaryButton(
                text: 'Darovat pokrmy',
                onPressed: () {},
              ),
            ),
            UiDonationStatusCard(
              label: 'Darujete charitě',
              title: 'Most naděje, Praha 4',
              headerAction: UiTextButton(
                text: 'Změnit',
                icon: Icons.sync,
                onPressed: () {},
              ),
              progressBar: UiProgressStepper(
                currentStep: 2,
                isCurrentStepActive: false,
                isProgressComplete: false,
                icons: const [
                  UiIconSpec.data(Icons.today_rounded),
                  UiIconSpec.svg(ImageAssets.iconDeliveryAccept),
                  UiIconSpec.data(Icons.food_bank_rounded),
                  UiIconSpec.svg(ImageAssets.iconDeliveryRun),
                  UiIconSpec.data(Icons.check_circle_rounded),
                ],
              ),
              statusSection: Text(
                'Přeprava potvrzena a kurýr je na cestě.',
                style: context.textStyles.bodyMedium.copyWith(
                  color: context.uiColors.textPrimary,
                ),
              ),
              actionInfo: UiDonationTimeRangeLabel(
                startTime: const TimeOfDay(hour: 14, minute: 0),
                endTime: const TimeOfDay(hour: 14, minute: 30),
                label: 'Čas vyzvednutí kurýrem',
              ),
              actionButton: UiOutlineButton(
                text: 'Detail daru',
                icon: Icons.receipt_long,
                onPressed: () {},
              ),
            ),
            UiDonationStatusCard(
              label: 'Darujete charitě',
              title: 'Most naděje, Praha 4',
              headerAction: UiTextButton(
                text: 'Změnit',
                icon: Icons.sync,
                onPressed: () {},
              ),
              progressBar: UiProgressStepper(
                currentStep: 5,
                isCurrentStepActive: true,
                isProgressComplete: false,
                icons: const [
                  UiIconSpec.data(Icons.today_rounded),
                  UiIconSpec.svg(ImageAssets.iconDeliveryAccept),
                  UiIconSpec.data(Icons.food_bank_rounded),
                  UiIconSpec.svg(ImageAssets.iconDeliveryRun),
                  UiIconSpec.data(Icons.check_circle_rounded),
                ],
              ),
              statusSection: Text(
                'Dar doručen do charity, čeká na přijetí daru.',
                style: context.textStyles.bodyMedium.copyWith(
                  color: context.uiColors.textPrimary,
                ),
              ),
              actionButton: UiOutlineButton(
                text: 'Detail daru',
                icon: Icons.receipt_long,
                onPressed: () {},
              ),
            ),
            UiDonationStatusCard(
              label: 'Darujete charitě',
              title: 'Most naděje, Praha 4',
              headerAction: UiTextButton(
                text: 'Změnit',
                icon: Icons.sync,
                onPressed: () {},
              ),
              progressBar: UiProgressStepper(
                currentStep: 5,
                isCurrentStepActive: true,
                isProgressComplete: true,
                icons: const [
                  UiIconSpec.data(Icons.today_rounded),
                  UiIconSpec.svg(ImageAssets.iconDeliveryAccept),
                  UiIconSpec.data(Icons.food_bank_rounded),
                  UiIconSpec.svg(ImageAssets.iconDeliveryRun),
                  UiIconSpec.data(Icons.check_circle_rounded),
                ],
              ),
              statusSection: Text.rich(
                style: context.textStyles.bodyMedium.copyWith(
                  color: context.uiColors.textPrimary,
                ),
                TextSpan(
                  children: [
                    TextSpan(text: 'Dnešní darování '),
                    TextSpan(
                      text: 'úspěšně dokončeno',
                      style: context.textStyles.bodyMedium.copyWith(
                        color: context.uiColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealTileComponents extends StatelessWidget {
  const _MealTileComponents();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            UiMealTile(
              title: 'Svíčková na smetaně',
              quantityLabel: '15 porcí',
              badges: [
                UiMealBadge(
                  icon: UiIconSpec.svg(ImageAssets.iconHot),
                  label: 'Teplý (68°C)',
                ),
                UiMealBadge(
                  icon: UiIconSpec.svg(ImageAssets.iconAllergens),
                  label: '1, 3, 9',
                ),
                UiMealBadge(
                  icon: UiIconSpec.svg(ImageAssets.iconCalendar),
                  label: '28.11.2024 16:32',
                ),
              ],
            ),
            UiMealTile(
              title: 'Houskový knedlík',
              quantityLabel: '8 porcí',
              badges: [
                UiMealBadge(
                  icon: UiIconSpec.svg(ImageAssets.iconCold),
                  label: 'Chlazený',
                ),
                UiMealBadge(
                  icon: UiIconSpec.svg(ImageAssets.iconAllergens),
                  label: '1, 3, 9, 12',
                ),
                UiMealBadge(
                  icon: UiIconSpec.svg(ImageAssets.iconCalendar),
                  label: '28.11.2024 16:32',
                ),
              ],
            ),
            UiMealTile(
              title: 'Šunková bageta',
              quantityLabel: '10 ks',
              badges: [
                UiMealBadge(
                  icon: UiIconSpec.svg(ImageAssets.iconPack),
                  label: 'Balený',
                ),
                UiMealBadge(
                  icon: UiIconSpec.svg(ImageAssets.iconAllergens),
                  label: 'Viz. obal',
                ),
                UiMealBadge(
                  icon: UiIconSpec.svg(ImageAssets.iconCalendar),
                  label: 'Viz. obal',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ListTileComponents extends StatelessWidget {
  const _ListTileComponents();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            UiListTile(
              title: 'Title',
              onPressed: () {},
            ),
            UiListTile(
              title: 'Title',
              end: UiGradientIcon(
                spec: UiIconSpec.data(Icons.edit),
                gradient: context.uiColors.primaryGradient,
                size: 24,
              ),
              onPressed: () {},
            ),
            UiListTile(
              title: 'Title',
              supportingText: 'Supporting text',
              onPressed: () {},
            ),
            UiListTile(
              title: 'Title',
              overline: 'Overline',
              supportingText: 'Supporting text',
              onPressed: () {},
            ),
            UiListTile(
              title: 'Title',
              supportingText: 'Supporting text',
              end: UiGradientIcon(
                spec: UiIconSpec.data(Icons.edit),
                gradient: context.uiColors.primaryGradient,
                size: 24,
              ),
              onPressed: () {},
            ),
            UiListTile(
              title: 'Title',
              end: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 16.0,
                children: [
                  Text(
                    '15 ks',
                    style: context.textStyles.labelLarge,
                  ),
                  UiGradientIcon(
                    spec: UiIconSpec.data(Icons.edit),
                    gradient: context.uiColors.primaryGradient,
                    size: 24,
                  ),
                ],
              ),
              onPressed: () {},
            ),
            UiListTile(
              title: 'Title',
              start: const Icon(Icons.phone_outlined, size: 24),
              end: UiGradientIcon(
                spec: UiIconSpec.data(Icons.chevron_right),
                gradient: context.uiColors.primaryGradient,
                size: 24,
              ),
              onPressed: () {},
            ),
            UiListTile(
              title: 'Title',
              supportingText: 'Supporting text',
              start: const Icon(Icons.phone_outlined, size: 24),
              end: UiGradientIcon(
                spec: UiIconSpec.data(Icons.chevron_right),
                gradient: context.uiColors.primaryGradient,
                size: 24,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactTileComponents extends StatelessWidget {
  const _ContactTileComponents();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            UiContactTile(
              name: 'Hana Novotná, pozice',
              phoneNumber: '+420 XXX XXX XXX',
              isPreferred: true,
            ),
            UiContactTile(
              name: 'Hana Novotná, pozice',
              phoneNumber: '+420 XXX XXX XXX',
            ),
            UiContactTile(
              name: 'Kontakt bez telefonu',
              phoneNumber: 'Telefonní číslo neuvedeno',
              showCallButton: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangePairTileComponents extends StatelessWidget {
  const _ChangePairTileComponents();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            UiChangePairTile(
              name: 'Jídelna U Ospalé pandy',
              activeLabel: 'Aktivní jídelna',
            ),
            UiChangePairTile(
              name: 'Jídelna ZŠ Ječná',
              onSelectPressed: () {},
            ),
            UiChangePairTile(
              name: 'Jídelna s upozorněním',
              onSelectPressed: () {},
              showIndicator: true,
            ),
          ],
        ),
      ),
    );
  }
}
