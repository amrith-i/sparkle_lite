import 'package:daily_finance_manager/core_import.dart';

class AppFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? hint;
  final String? label;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLength;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onPrefixPressed;
  final VoidCallback? onSuffixPressed;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final bool showBorder;
  final VoidCallback? onTap;
  final double? borderRadius;
  final bool readOnly;
  final Color? fillColor;
  final Color? focusedBorderColor;
  final Color? borderColor;
  final EdgeInsets? contentPadding;

  const AppFormField({
    super.key,
    required this.controller,
    this.hint,
    this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onPrefixPressed,
    this.onSuffixPressed,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.showBorder = true,
    this.onTap,
    this.borderRadius,
    this.readOnly = false,
    this.fillColor = Colors.white,
    this.focusedBorderColor,
    this.borderColor,
    this.contentPadding,
  });

  @override
  State<AppFormField> createState() => _AppFormFieldState();
}

class _AppFormFieldState extends State<AppFormField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = widget.borderColor ?? AppColors.border;
    final effectiveFocusedColor =
        widget.focusedBorderColor ?? AppColors.primaryBlue;

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      maxLength: widget.maxLength,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      focusNode: _focusNode,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      style: AppTextStyles.inputText(context),
      cursorColor: AppColors.primaryBlue,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.fillColor,
        hintText: widget.hint,
        hintStyle: AppTextStyles.inputHint(context),
        labelText: widget.label,
        labelStyle: AppTextStyles.inputLabel(context),
        floatingLabelStyle: TextStyle(
          color: _isFocused ? effectiveFocusedColor : null,
        ),
        prefixIcon: widget.prefixIcon != null
            ? GestureDetector(
                onTap: widget.onPrefixPressed,
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: context.w(mobile: 16),
                    right: context.w(mobile: 8),
                  ),
                  child: widget.prefixIcon,
                ),
              )
            : null,
        suffixIcon: widget.suffixIcon != null
            ? GestureDetector(
                onTap: widget.onSuffixPressed,
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: EdgeInsets.only(right: context.w(mobile: 16)),
                  child: widget.suffixIcon,
                ),
              )
            : null,
        border: widget.showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? context.r(mobile: 12),
                ),
                borderSide: BorderSide(color: effectiveBorderColor),
              )
            : InputBorder.none,
        enabledBorder: widget.showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? context.r(mobile: 12),
                ),
                borderSide: BorderSide(color: effectiveBorderColor),
              )
            : InputBorder.none,
        focusedBorder: widget.showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? context.r(mobile: 12),
                ),
                borderSide: BorderSide(
                  color: effectiveFocusedColor,
                  width: context.w(mobile: 2),
                ),
              )
            : InputBorder.none,
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(
              horizontal: context.w(mobile: 16),
              vertical: context.h(mobile: 16),
            ),
      ),
    );
  }
}
