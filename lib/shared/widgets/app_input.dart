import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

/// Custom input field widget with consistent styling
class AppInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final bool isRequired;
  final AppInputSize size;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppInput({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.validator,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.isRequired = false,
    this.size = AppInputSize.medium,
    this.focusNode,
    this.autofocus = false,
  });

  const AppInput.email({
    super.key,
    this.label = 'Email',
    this.hint = 'Enter your email',
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.prefixIcon = const Icon(Icons.email_outlined),
    this.suffixIcon,
    this.isRequired = true,
    this.size = AppInputSize.medium,
    this.focusNode,
    this.autofocus = false,
  }) : obscureText = false,
       maxLines = 1,
       minLines = null,
       maxLength = null,
       keyboardType = TextInputType.emailAddress,
       textInputAction = TextInputAction.next,
       textCapitalization = TextCapitalization.none,
       inputFormatters = null,
       prefixText = null,
       suffixText = null;

  const AppInput.password({
    super.key,
    this.label = 'Password',
    this.hint = 'Enter your password',
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.prefixIcon = const Icon(Icons.lock_outline),
    this.suffixIcon,
    this.isRequired = true,
    this.size = AppInputSize.medium,
    this.focusNode,
    this.autofocus = false,
  }) : obscureText = true,
       maxLines = 1,
       minLines = null,
       maxLength = null,
       keyboardType = TextInputType.visiblePassword,
       textInputAction = TextInputAction.done,
       textCapitalization = TextCapitalization.none,
       inputFormatters = null,
       prefixText = null,
       suffixText = null;

  const AppInput.number({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.isRequired = false,
    this.size = AppInputSize.medium,
    this.focusNode,
    this.autofocus = false,
  }) : obscureText = false,
       maxLines = 1,
       minLines = null,
       maxLength = null,
       keyboardType = TextInputType.number,
       textInputAction = TextInputAction.done,
       textCapitalization = TextCapitalization.none,
       inputFormatters = null;

  const AppInput.decimal({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.isRequired = false,
    this.size = AppInputSize.medium,
    this.focusNode,
    this.autofocus = false,
  }) : obscureText = false,
       maxLines = 1,
       minLines = null,
       maxLength = null,
       keyboardType = const TextInputType.numberWithOptions(decimal: true),
       textInputAction = TextInputAction.done,
       textCapitalization = TextCapitalization.none,
       inputFormatters = null;

  const AppInput.multiline({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 4,
    this.minLines = 3,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.isRequired = false,
    this.size = AppInputSize.medium,
    this.focusNode,
    this.autofocus = false,
  }) : obscureText = false,
       keyboardType = TextInputType.multiline,
       textInputAction = TextInputAction.newline,
       textCapitalization = TextCapitalization.sentences,
       inputFormatters = null;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late bool _obscureText;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChanged);
    }
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputSize = _getInputSize();
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label!,
              style: AppTypography.labelMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              children: [
                if (widget.isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onEditingComplete: widget.onEditingComplete,
          onFieldSubmitted: widget.onFieldSubmitted,
          validator: widget.validator,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          inputFormatters: widget.inputFormatters,
          autofocus: widget.autofocus,
          style: _getTextStyle(),
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helperText,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            prefixText: widget.prefixText,
            suffixText: widget.suffixText,
            contentPadding: inputSize.padding,
            isDense: widget.size == AppInputSize.small,
            filled: true,
            fillColor: _getFillColor(context, hasError),
            border: _getBorder(context, hasError, false, false),
            enabledBorder: _getBorder(context, hasError, false, false),
            focusedBorder: _getBorder(context, hasError, true, false),
            errorBorder: _getBorder(context, hasError, false, true),
            focusedErrorBorder: _getBorder(context, hasError, true, true),
            disabledBorder: _getBorder(context, hasError, false, false),
          ),
        ),
        if (widget.helperText != null && widget.errorText == null) ...[
          const SizedBox(height: 4),
          Text(
            widget.helperText!,
            style: AppTypography.caption.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return widget.suffixIcon;
  }

  InputSize _getInputSize() {
    switch (widget.size) {
      case AppInputSize.small:
        return const InputSize(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );
      case AppInputSize.medium:
        return const InputSize(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        );
      case AppInputSize.large:
        return const InputSize(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case AppInputSize.small:
        return AppTypography.bodySmall;
      case AppInputSize.medium:
        return AppTypography.bodyMedium;
      case AppInputSize.large:
        return AppTypography.bodyLarge;
    }
  }

  Color _getFillColor(BuildContext context, bool hasError) {
    if (!widget.enabled) {
      return Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5);
    }
    if (hasError) {
      return Theme.of(context).colorScheme.errorContainer.withOpacity(0.1);
    }
    if (_hasFocus) {
      return Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1);
    }
    return Theme.of(context).colorScheme.surface;
  }

  OutlineInputBorder _getBorder(
    BuildContext context,
    bool hasError,
    bool isFocused,
    bool isError,
  ) {
    Color borderColor;
    double borderWidth = 1.0;

    if (isError || hasError) {
      borderColor = Theme.of(context).colorScheme.error;
      if (isFocused) borderWidth = 2.0;
    } else if (isFocused) {
      borderColor = Theme.of(context).colorScheme.primary;
      borderWidth = 2.0;
    } else if (!widget.enabled) {
      borderColor = Theme.of(context).colorScheme.outline.withOpacity(0.5);
    } else {
      borderColor = Theme.of(context).colorScheme.outline;
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }
}

enum AppInputSize {
  small,
  medium,
  large,
}

class InputSize {
  final EdgeInsetsGeometry padding;

  const InputSize({
    required this.padding,
  });
}
