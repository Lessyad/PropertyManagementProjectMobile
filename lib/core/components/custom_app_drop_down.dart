import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final Widget Function(T)? itemBuilder;
  final String Function(T)? itemToString;
  final Widget? icon;
  final InputDecoration? decoration;
  final Color? dropdownColor;
  final double? menuMaxHeight;
  final TextStyle? style;
  final double height;
  final Widget? hint;
  final Function(bool)? onMenuStateChange;


  const CustomDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.itemBuilder,
    this.itemToString,
    this.icon,
    this.decoration,
    this.dropdownColor,
    this.menuMaxHeight,
    this.style,
    this.height = 40,
    this.hint,
    this.onMenuStateChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            isExpanded: true,

            value: value,
            onChanged: onChanged,
            hint: hint,
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: itemBuilder != null
                    ? itemBuilder!(item)
                    : Text(
                  itemToString != null
                      ? itemToString!(item)
                      : item.toString(),
                  style: style,
                ),
              );
            }).toList(),
            onMenuStateChange: onMenuStateChange,
            buttonStyleData: ButtonStyleData(
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: decoration != null
                  ? BoxDecoration(
                color: decoration?.fillColor,
                borderRadius: BorderRadius.circular(24),
              )
                  : null,
            ),

            dropdownStyleData: DropdownStyleData(
              maxHeight: menuMaxHeight ?? 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: dropdownColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}