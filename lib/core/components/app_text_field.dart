import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final double borderRadius;
  final Function(String)? onChanged;
  final Function()? onTap;
  final int? maxLines;
  final String? Function(String?)? validator;
  final TextDirection? textDirection;
  final String ? initialValue;
  final  FocusNode? focusNode;
  final bool editable;
  final List<TextInputFormatter>? inputFormatters;
  const AppTextField({
    super.key,
    this.width = double.infinity,
    this.height = 44,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    required this.hintText,
    this.inputFormatters ,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.textStyle,
    this.backgroundColor = Colors.white,
    this.borderRadius = 20,
    this.onChanged,
    this.onTap,
    this.maxLines,
    this.validator,
    this.textDirection,
    this.initialValue,
    this.editable = true,
    this.focusNode ,
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Directionality(
            textDirection:
            widget.textDirection ?? (isArabic ? TextDirection.rtl : TextDirection.ltr),
            child: TextFormField(
              initialValue: widget.initialValue,
              controller: widget.controller,
              inputFormatters: widget.inputFormatters,
              focusNode: widget.focusNode,
              enabled: widget.editable,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
                setState(() {
                  String trimmedValue = value.trim();
                  _hasError = trimmedValue.isNotEmpty && widget.validator != null && widget.validator!(trimmedValue) != null;
                });
              },
              onTap: widget.onTap,
              maxLines: widget.maxLines ?? 1,
              textAlign: (widget.textDirection == TextDirection.rtl ||
                  (widget.textDirection == null && isArabic))
                  ? TextAlign.right
                  : TextAlign.left,
              validator: (value) {
                final validationMessage = widget.validator?.call(value);
                setState(() {
                  _hasError = validationMessage != null;
                });
                return validationMessage;
              },
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: widget.textStyle ??
                    const TextStyle(
                      color: Color(0xFF707070),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                prefixIcon: widget.prefixIcon,
                suffixIcon: _hasError
                    ? const Icon(Icons.error_outline, color: Colors.red)
                    : widget.suffixIcon,
                filled: true,
                fillColor: widget.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: _hasError
                      ? const BorderSide(color: Colors.red, width: 1)
                      : BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: _hasError
                      ? const BorderSide(color: Colors.red, width: 1)
                      : BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
