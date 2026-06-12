import 'package:flutter/material.dart';
import '../../configuration/managers/color_manager.dart';

/// Champ de sélection avec bottom-sheet recherchable.
/// Usage :
///   SearchableSelectField<Country>(
///     label: 'Pays',
///     selectedValue: _selectedCountry,
///     items: _countries,
///     displayValue: (c) => c.name,
///     onChanged: (c) => setState(() => _selectedCountry = c),
///   )
class SearchableSelectField<T> extends StatelessWidget {
  final String label;
  final T? selectedValue;
  final String Function(T) displayValue;
  final List<T> items;
  final void Function(T?) onChanged;
  final bool isLoading;
  final bool isDisabled;
  final IconData prefixIcon;
  final String? searchHint;
  final String? modalTitle;

  const SearchableSelectField({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.displayValue,
    required this.items,
    required this.onChanged,
    this.isLoading = false,
    this.isDisabled = false,
    this.prefixIcon = Icons.list,
    this.searchHint,
    this.modalTitle,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValue = selectedValue != null;
    final bool tappable = !isLoading && !isDisabled && items.isNotEmpty;
    final Color activeColor = ColorManager.primaryColor;
    final Color mutedColor = ColorManager.grey;
    final Color borderColor = hasValue
        ? activeColor
        : isDisabled
            ? ColorManager.grey3
            : ColorManager.grey3;

    return GestureDetector(
      onTap: tappable ? () => _open(context) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 52,
        decoration: BoxDecoration(
          color: isDisabled ? const Color(0xFFF5F5F5) : ColorManager.greyShade,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasValue ? activeColor : borderColor,
            width: hasValue ? 1.8 : 1.5,
          ),
          boxShadow: hasValue
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(
              prefixIcon,
              size: 18,
              color: hasValue ? activeColor : isDisabled ? ColorManager.grey3 : mutedColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: isLoading
                  ? Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: activeColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Chargement...',
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      hasValue ? displayValue(selectedValue as T) : label,
                      style: TextStyle(
                        color: hasValue
                            ? ColorManager.blackColor
                            : isDisabled
                                ? ColorManager.grey3
                                : mutedColor,
                        fontSize: 14,
                        fontWeight: hasValue ? FontWeight.w500 : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            if (hasValue && !isDisabled)
              GestureDetector(
                onTap: () => onChanged(null),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: ColorManager.grey3.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 14, color: mutedColor),
                ),
              )
            else
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: isDisabled ? ColorManager.grey3 : mutedColor,
              ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _SearchableSheet<T>(
        title: modalTitle ?? label,
        items: items,
        selectedValue: selectedValue,
        displayValue: displayValue,
        searchHint: searchHint ?? 'Rechercher...',
        onSelect: (item) {
          onChanged(item);
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ─── Bottom-sheet interne ─────────────────────────────────────────────────────

class _SearchableSheet<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final T? selectedValue;
  final String Function(T) displayValue;
  final String searchHint;
  final void Function(T) onSelect;

  const _SearchableSheet({
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.displayValue,
    required this.searchHint,
    required this.onSelect,
  });

  @override
  State<_SearchableSheet<T>> createState() => _SearchableSheetState<T>();
}

class _SearchableSheetState<T> extends State<_SearchableSheet<T>> {
  final TextEditingController _search = TextEditingController();
  late List<T> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _search.addListener(_filter);
  }

  void _filter() {
    final q = _search.text.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.items
          : widget.items
              .where((i) => widget.displayValue(i).toLowerCase().contains(q))
              .toList();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double maxH = MediaQuery.of(context).size.height * 0.82;
    final double kb = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(maxHeight: maxH + kb),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE1E7),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // ── Titre + bouton fermer ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.blackColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded, color: ColorManager.grey, size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // ── Barre de recherche ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _search,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                hintStyle: TextStyle(color: ColorManager.grey, fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded, color: ColorManager.primaryColor, size: 20),
                suffixIcon: _search.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear_rounded, size: 18, color: ColorManager.grey),
                        onPressed: _search.clear,
                        padding: EdgeInsets.zero,
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF4F6FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ColorManager.primaryColor, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              style: TextStyle(color: ColorManager.blackColor, fontSize: 14),
            ),
          ),

          // ── Compteur ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} résultat${_filtered.length > 1 ? 's' : ''}',
                  style: TextStyle(fontSize: 12, color: ColorManager.grey),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey[100]),

          // ── Liste ──
          Flexible(
            child: _filtered.isEmpty
                ? _emptyState()
                : ListView.separated(
                    padding: EdgeInsets.only(bottom: 20 + kb),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey[100]),
                    itemBuilder: (context, i) {
                      final item = _filtered[i];
                      final bool selected = _isSelected(item);
                      return InkWell(
                        onTap: () => widget.onSelect(item),
                        child: Container(
                          color: selected
                              ? ColorManager.primaryColor.withOpacity(0.06)
                              : Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.displayValue(item),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: selected
                                        ? ColorManager.primaryColor
                                        : ColorManager.blackColor,
                                  ),
                                ),
                              ),
                              if (selected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: ColorManager.primaryColor,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  bool _isSelected(T item) {
    if (widget.selectedValue == null) return false;
    // Comparaison par displayValue si égalité référentielle échoue
    return widget.selectedValue == item ||
        widget.displayValue(widget.selectedValue as T) ==
            widget.displayValue(item);
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 52, color: ColorManager.grey3),
          const SizedBox(height: 12),
          Text(
            'Aucun résultat',
            style: TextStyle(
              color: ColorManager.grey,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Essayez un autre terme',
            style: TextStyle(color: ColorManager.grey3, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
