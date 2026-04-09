import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/web_page_utils.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_card.dart';
import 'package:zachranobed/features/forceupdate/domain/usecase/check_web_soft_update_should_be_shown_usecase.dart';

/// Wraps [child] and overlays a dismissible soft-update card in the bottom-right corner when a newer
/// (but non-mandatory) web version is available.
class SoftUpdateWebBanner extends StatefulWidget {
  final Widget child;

  const SoftUpdateWebBanner({super.key, required this.child});

  @override
  State<SoftUpdateWebBanner> createState() => _SoftUpdateWebBannerState();
}

class _SoftUpdateWebBannerState extends State<SoftUpdateWebBanner> {
  late final CheckWebSoftUpdateShouldBeShownUseCase _checkWebSoftUpdate;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _checkWebSoftUpdate = GetIt.I<CheckWebSoftUpdateShouldBeShownUseCase>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  Future<void> _check() async {
    try {
      final shouldShow = await _checkWebSoftUpdate.invoke();
      if (shouldShow && mounted) {
        setState(() => _visible = true);
      }
    } catch (_) {
      // Fail silently — banner is optional, errors must not affect the app.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_visible)
          Positioned(
            right: 16,
            bottom: 16,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: UiCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 16,
                  children: [
                    Text(
                      context.l10n.softUpdateWebBannerMessage,
                      style: context.textStyles.titleMedium,
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        UiTextButton(
                          size: UiButtonSize.tiny(),
                          text: context.l10n.softUpdateWebDismissAction,
                          onPressed: () => setState(() => _visible = false),
                        ),
                        UiPrimaryButton(
                          size: UiButtonSize.tiny(),
                          text: context.l10n.softUpdateWebReloadAction,
                          onPressed: reloadWebPageToHome,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
