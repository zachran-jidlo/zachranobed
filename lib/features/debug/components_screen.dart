import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/app_bar.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_fill_icon_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_icon_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/progress/ui_progress_bar.dart';
import 'package:zachranobed/common/presentation/widget/progress/ui_progress_stepper.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/ui_chip.dart';
import 'package:zachranobed/common/presentation/widget/ui_nav_bar.dart';

@RoutePage()
class ComponentsScreen extends StatelessWidget {
  const ComponentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universal(
      appBar: const ZOAppBar(
        title: "Components screen",
      ),
      child: CustomScrollView(
        slivers: [
          _Header.h1("Buttons"),
          _Header.h2("Text buttons"),
          _TextButtonComponents(),
          _Header.h2("Primary buttons"),
          _PrimaryButtonComponents(),
          _Header.h2("Outline buttons"),
          _OutlineButtonComponents(),
          _Header.h2("Icon buttons"),
          _IconButtonComponents(),
          _Header.h1("Navigation"),
          _NavigationComponents(),
          _Header.h1("Progress"),
          _ProgressComponents(),
          _Header.h1("Chips"),
          _ChipComponents(),
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

  const _Header.h3(this.text) : size = _HeaderSize.h3;

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
        return context.textTheme.headlineLarge;
      case _HeaderSize.h2:
        return context.textTheme.headlineMedium;
      case _HeaderSize.h3:
        return context.textTheme.headlineSmall;
    }
  }
}

class _TextButtonComponents extends StatelessWidget {
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
          ],
        ),
      ),
    );
  }
}

class _NavigationComponents extends StatelessWidget implements TickerProvider  {

  static const List<UINavBarItem> items = [
    UINavBarItem(icon: Icons.home_rounded, label: 'Přehled'),
    UINavBarItem(icon: Icons.menu_book, label: 'Nápověda'),
    UINavBarItem(icon: Icons.bar_chart_rounded, label: 'Statistiky'),
    UINavBarItem(icon: Icons.notifications, label: 'Notifikace'),
  ];

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
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
              controller: TabController(length: items.length, vsync: this),
              items: items,
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
              'Current step: ${_currentStep + 1}' +
                  '\nCurrent step active: $_isCurrentStepActive' +
                  '\nProgress complete: $_isProgressComplete',
            ),
            UiProgressStepper(
              currentStep: _currentStep,
              isCurrentStepActive: _isCurrentStepActive,
              isProgressComplete: _isProgressComplete,
              icons: [
                Icons.today_rounded,
                Icons.food_bank_rounded,
                Icons.shopping_bag_rounded,
                Icons.moped_rounded,
                Icons.check_circle_rounded,
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
                  enabled: _currentStep > 0 || !_isCurrentStepActive,
                ),
              ],
            ),
            const SizedBox(width: 16.0),
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
          ],
        ),
      ),
    );
  }
}

class _ChipComponents extends StatelessWidget {
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
