import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/app_bar.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';

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
          _Header.h1("Primary buttons"),
          _PrimaryButtonComponents(),
          _Header.h1("Outline buttons"),
          _OutlineButtonComponents(),
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
