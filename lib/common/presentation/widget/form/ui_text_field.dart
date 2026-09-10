import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A custom outlined text field widget.
class UiTextField extends StatefulWidget {
  // Layout constants
  static const double _borderRadius = 4.0;
  static const double _iconSize = 24.0;
  static const double _iconContainerSize = 48.0;
  static const double _minHeight = 56.0;
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 16.0;

  /// The controller for the text field.
  final TextEditingController? controller;

  /// The label text displayed above the text field.
  final String? labelText;

  /// The hint text displayed when the text field is empty.
  final String? hintText;

  /// The supporting text displayed below the text field.
  final String? supportingText;

  /// The error text displayed below the text field. When set, the text field
  /// will be in error state.
  final String? errorText;

  /// The leading icon displayed at the start of the text field.
  final IconData? leadingIcon;

  /// The trailing icon displayed at the end of the text field.
  final IconData? trailingIcon;

  /// The callback function triggered when the trailing icon is pressed.
  final VoidCallback? onTrailingIconPressed;

  /// Whether the text field is enabled or not. By default text field is enabled.
  final bool enabled;

  /// Whether the text is obscured. By default text is not obscured.
  final bool obscureText;

  /// The type of keyboard to use for editing the text.
  final TextInputType? keyboardType;

  /// The callback function triggered when the text changes.
  final ValueChanged<String>? onChanged;

  /// The focus node for the text field.
  final FocusNode? focusNode;

  /// The validation function for form validation.
  final String? Function(String?)? onValidation;

  /// The list of input formatters for restricting input.
  final List<TextInputFormatter>? textInputFormatters;

  /// The initial value for the text field.
  final String? initialValue;

  /// Whether the text field is read-only. By default text field is editable.
  final bool readOnly;

  /// Whether to disable autocorrect. By default autocorrect is enabled.
  final bool disableAutocorrect;

  /// The maximum number of lines for the text field.
  final int? maxLines;

  /// The minimum number of lines for the text field.
  final int? minLines;

  /// The action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// The callback function triggered when the field is submitted.
  final ValueChanged<String>? onFieldSubmitted;

  /// The text capitalization behavior.
  final TextCapitalization textCapitalization;

  /// The behavior of the floating label.
  final FloatingLabelBehavior? floatingLabelBehavior;

  /// A stable accessibility identifier for the input, used by UI tests.
  final String? semanticsIdentifier;

  /// Creates a [UiTextField] widget.
  const UiTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.supportingText,
    this.errorText,
    this.leadingIcon,
    this.trailingIcon,
    this.onTrailingIconPressed,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.focusNode,
    this.onValidation,
    this.textInputFormatters,
    this.initialValue,
    this.readOnly = false,
    this.disableAutocorrect = false,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.floatingLabelBehavior,
    this.semanticsIdentifier,
  }) : assert(
          controller == null || initialValue == null,
          'Cannot provide both controller and initialValue',
        );

  @override
  State<UiTextField> createState() => _UiTextFieldState();
}

class _UiTextFieldState extends State<UiTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  String? _validationError;

  bool get _hasError => (widget.errorText?.isNotEmpty ?? false) || (_validationError?.isNotEmpty ?? false);

  String? get _supportingText {
    if (_validationError?.isNotEmpty ?? false) {
      return _validationError;
    }
    if (widget.errorText?.isNotEmpty ?? false) {
      return widget.errorText;
    }
    return widget.supportingText;
  }

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(UiTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChange);
      if (oldWidget.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTextField(context),
        if (_supportingText case final supportingText?) _buildSupportingText(context, supportingText),
      ],
    );
  }

  String? _wrapValidator(String? value) {
    final error = widget.onValidation?.call(value);

    // The addPostFrameCallback is required because the validator is called during the build phase. Calling setState
    // directly during build would cause:
    // "setState() or markNeedsBuild() called during build" error.
    //
    // By deferring setState to the next frame, we avoid this issue while still updating the _validationError state
    // for the supporting text display.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _validationError != error) {
        setState(() {
          _validationError = error;
        });
      }
    });
    return error;
  }

  OutlineInputBorder _buildBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(UiTextField._borderRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget _buildTextField(BuildContext context) {
    final semanticsIdentifier = widget.semanticsIdentifier;
    final errorColor = context.uiColors.error;
    final inactiveColor = context.uiColors.inactive;
    final borderColor = _hasError ? errorColor : inactiveColor;
    final borderWidth = _hasError ? 2.0 : 1.0;
    final leadingIcon = widget.leadingIcon;
    final trailingIcon = widget.trailingIcon;

    final field = TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      validator: widget.onValidation != null ? _wrapValidator : null,
      inputFormatters: widget.textInputFormatters,
      initialValue: widget.initialValue,
      readOnly: widget.readOnly,
      autocorrect: !widget.disableAutocorrect,
      spellCheckConfiguration: widget.disableAutocorrect ? const SpellCheckConfiguration.disabled() : null,
      enableSuggestions: !widget.disableAutocorrect,
      onTapOutside: (event) => _focusNode.unfocus(),
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      textCapitalization: widget.textCapitalization,
      cursorColor: context.uiColors.textPrimary,
      style: context.textStyles.bodyMedium.copyWith(
        color: widget.enabled ? context.uiColors.textPrimary : context.uiColors.inactive,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        filled: true,
        fillColor: context.uiColors.surfaceGray,
        labelStyle: context.textStyles.bodyMedium.copyWith(
          color: _labelColor(context),
        ),
        floatingLabelStyle: context.textStyles.bodySmall.copyWith(
          color: _labelColor(context),
        ),
        hintStyle: context.textStyles.bodyMedium.copyWith(
          color: context.uiColors.textSecondary,
        ),
        // Hide default error text - we display it in supporting text
        errorStyle: const TextStyle(height: 0, fontSize: 0),
        errorMaxLines: 1,
        prefixIcon: leadingIcon != null ? _buildIcon(context, leadingIcon) : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: UiTextField._iconContainerSize,
          minHeight: UiTextField._iconContainerSize,
        ),
        suffixIcon: trailingIcon != null
            ? SizedBox(
                width: UiTextField._iconContainerSize,
                height: UiTextField._iconContainerSize,
                child: IconButton(
                  onPressed: widget.enabled ? widget.onTrailingIconPressed : null,
                  icon: Icon(
                    trailingIcon,
                    size: UiTextField._iconSize,
                    color: _hasError ? context.uiColors.error : _iconColor(context),
                  ),
                ),
              )
            : null,
        floatingLabelBehavior: widget.floatingLabelBehavior,
        suffixIconConstraints: const BoxConstraints(
          minWidth: UiTextField._iconContainerSize,
          minHeight: UiTextField._iconContainerSize,
        ),
        constraints: const BoxConstraints(minHeight: UiTextField._minHeight),
        contentPadding: EdgeInsets.only(
          left: UiTextField._horizontalPadding,
          right: UiTextField._horizontalPadding,
          top: UiTextField._verticalPadding,
          bottom: UiTextField._verticalPadding,
        ),
        border: _buildBorder(borderColor, borderWidth),
        enabledBorder: _buildBorder(borderColor, borderWidth),
        focusedBorder: _buildBorder(borderColor, borderWidth),
        errorBorder: _buildBorder(errorColor, 2.0),
        focusedErrorBorder: _buildBorder(errorColor, 2.0),
        disabledBorder: _buildBorder(inactiveColor, 1.0),
      ),
    );

    if (semanticsIdentifier == null) {
      return field;
    }
    return Semantics(identifier: semanticsIdentifier, child: field);
  }

  Widget _buildSupportingText(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        text,
        style: context.textStyles.bodySmall.copyWith(
          color: _hasError ? context.uiColors.error : context.uiColors.textSecondary,
        ),
      ),
    );
  }

  Color _labelColor(BuildContext context) {
    if (!widget.enabled) {
      return context.uiColors.inactive;
    }
    if (_hasError) {
      return context.uiColors.error;
    }
    if (_isFocused) {
      return context.uiColors.textPrimary;
    }
    return context.uiColors.textSecondary;
  }

  Color _iconColor(BuildContext context) {
    if (!widget.enabled) {
      return context.uiColors.inactive;
    }
    return context.uiColors.textSecondary;
  }

  Widget _buildIcon(BuildContext context, IconData icon, {Color? color}) {
    return SizedBox(
      width: UiTextField._iconContainerSize,
      height: UiTextField._iconContainerSize,
      child: Icon(
        icon,
        size: UiTextField._iconSize,
        color: color ?? _iconColor(context),
      ),
    );
  }
}
