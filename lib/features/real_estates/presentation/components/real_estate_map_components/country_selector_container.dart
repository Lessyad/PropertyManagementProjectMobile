import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CountrySelectorContainer extends StatefulWidget {
  final String selectedCountry;
  final Function(String) onCountrySelected;

  const CountrySelectorContainer({
    super.key,
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  @override
  State<CountrySelectorContainer> createState() => _CountrySelectorContainerState();
}

class _CountrySelectorContainerState extends State<CountrySelectorContainer> {
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _countries = [
    {'name': 'Egypt', 'flag': 'assets/flags/egypt_flag.png'},
    {'name': 'Saudi Arabia', 'flag': 'assets/flags/saudi_arabia_flag.png'},
    {'name': 'Mauritania', 'flag': 'assets/flags/mauritania_flag.png'},
    {'name': 'Morocco', 'flag': 'assets/flags/morocco_flag.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: context.scale(40),
      height: _isExpanded
          ? (_countries.length * 45.0) + 80
          : context.scale(60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _isExpanded
          ? _buildExpandedView()
          : _buildCollapsedView(),
    );
  }

  Widget _buildCollapsedView() {
    return InkWell(
      onTap: () => setState(() => _isExpanded = true),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              _countries.firstWhere(
                    (country) => country['name'] == widget.selectedCountry,
                orElse: () => _countries[0],
              )['flag'],
              width: 26,
              height: 26,
            ),
            const SizedBox(height: 2),
            const Icon(Icons.arrow_drop_down_sharp, size: 16, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedView() {
    return Column(
      children: [
        // Current selected flag
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Image.asset(
            _countries.firstWhere(
                  (country) => country['name'] == widget.selectedCountry,
              orElse: () => _countries[0],
            )['flag'],
            width: 26,
            height: 26,
          ),
        ),

        // Divider
        const Divider(height: 1, thickness: 1),

         SizedBox(
          height: _countries.length * 45.0,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _countries.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildFlagItem(_countries[index]);
            },
          ),
        ),

         InkWell(
          onTap: () => setState(() => _isExpanded = false),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(Icons.arrow_drop_up, size: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildFlagItem(Map<String, dynamic> country) {
    final bool isSelected = country['name'] == widget.selectedCountry;

    return InkWell(
      onTap: () {
        widget.onCountrySelected(country['name']);
        setState(() => _isExpanded = false);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.withOpacity(0.1) : Colors.transparent,
        ),
        child: Center(
          child: Image.asset(
            country['flag'],
            width: 26,
            height: 26,
          ),
        ),
      ),
    );
  }
}