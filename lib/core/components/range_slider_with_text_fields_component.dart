import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'app_text_field.dart';

class RangeSliderWithFields extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double initialMinValue;
  final double initialMaxValue;
  final String unit;
  final void Function(double, double)? onRangeChanged;

  const RangeSliderWithFields({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialMinValue,
    required this.initialMaxValue,
    this.unit = '',
    this.onRangeChanged,
  });

  @override
  _RangeSliderWithFieldsState createState() => _RangeSliderWithFieldsState();
}

class _RangeSliderWithFieldsState extends State<RangeSliderWithFields> {
  late RangeValues _currentRangeValues;
  late TextEditingController _minController;
  late TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = RangeValues(
      widget.initialMinValue,
      widget.initialMaxValue,
    );
    _minController = TextEditingController(
      text: '${_currentRangeValues.start.toStringAsFixed(1)} ${widget.unit}',
    );
    _maxController = TextEditingController(
      text: '${_currentRangeValues.end.toStringAsFixed(1)} ${widget.unit}',
    );
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _updateSliderFromTextField() {
    double minValue = double.tryParse(_minController.text.split(' ')[0]) ?? widget.minValue;
    double maxValue = double.tryParse(_maxController.text.split(' ')[0]) ?? widget.maxValue;

    if (minValue > widget.maxValue) {
      minValue = widget.maxValue;
      _minController.text = '${widget.maxValue.toStringAsFixed(1)} ${widget.unit}';
    }

    if (maxValue > widget.maxValue) {
      maxValue = widget.maxValue;
      _maxController.text = '${widget.maxValue.toStringAsFixed(1)} ${widget.unit}';
    }

    minValue = minValue.clamp(widget.minValue, widget.maxValue);
    maxValue = maxValue.clamp(widget.minValue, widget.maxValue);

    if (minValue > maxValue) {
      minValue = maxValue;
      _minController.text = '${minValue.toStringAsFixed(1)} ${widget.unit}';
    }

    setState(() {
      _currentRangeValues = RangeValues(minValue, maxValue);
    });

    widget.onRangeChanged?.call(minValue, maxValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 1,
            thumbColor: ColorManager.primaryColor,
            activeTrackColor: ColorManager.primaryColor,
            inactiveTrackColor: Color(0xFFD6D6D6),
          ),
          child: RangeSlider(
            values: _currentRangeValues,
            min: widget.minValue,
            max: widget.maxValue,
            divisions: ((widget.maxValue - widget.minValue) * 10).toInt(),
            labels: RangeLabels(
              _currentRangeValues.start.toStringAsFixed(1),
              _currentRangeValues.end.toStringAsFixed(1),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
                _minController.text = '${values.start.toStringAsFixed(1)} ${widget.unit}';
                _maxController.text = '${values.end.toStringAsFixed(1)} ${widget.unit}';
              });

              widget.onRangeChanged?.call(values.start, values.end);
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                height: context.scale(40),
                width: context.scale(163),
                hintText: 'القيمة الدنيا',
                keyboardType: TextInputType.number,
                controller: _minController,
                backgroundColor: Colors.white,
                borderRadius: 20,
                padding: EdgeInsets.zero,
                onChanged: (value) {
                  _updateSliderFromTextField();
                },
              ),
            ),
            SizedBox(width: context.scale(16)),
            Expanded(
              child: AppTextField(
                height: context.scale(40),
                width: context.scale(163),
                hintText: 'القيمة القصوى',
                keyboardType: TextInputType.number,
                controller: _maxController,
                backgroundColor: Colors.white,
                borderRadius: 20,
                padding: EdgeInsets.zero,
                onChanged: (value) {
                  _updateSliderFromTextField();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
