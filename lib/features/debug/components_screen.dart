import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:zachranobed/common/presentation/widget/ui_food_box_tile.dart';
import 'package:zachranobed/common/presentation/widget/ui_nav_bar.dart';
import 'package:zachranobed/common/presentation/widget/ui_text_field.dart';

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
          const _Header.h1("Progress"),
          _ProgressComponents(),
          const _Header.h1("Chips"),
          const _ChipComponents(),
          const _Header.h1("Text fields"),
          _TextFieldComponents(),
          const _Header.h1("Food box tiles"),
          const _FoodBoxTileComponents(),
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
  static const List<UINavBarItem> items = [
    UINavBarItem(icon: Icons.home_rounded, label: 'Přehled'),
    UINavBarItem(icon: Icons.menu_book, label: 'Nápověda'),
    UINavBarItem(icon: Icons.bar_chart_rounded, label: 'Statistiky'),
    UINavBarItem(icon: Icons.notifications, label: 'Notifikace'),
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
                UiFoodBoxTileStat(value: 8, label: 'Na cestě'),
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
                UiFoodBoxTileStat(value: 8, label: 'Na cestě'),
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
                UiFoodBoxTileStat(value: 8, label: 'Na cestě'),
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
                UiFoodBoxTileStat(value: 8, label: 'Na cestě'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
