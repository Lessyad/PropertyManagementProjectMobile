class NumberParser {
  /// Parse a decimal string that might contain comma as decimal separator
  /// and convert it to a double value
  static double parseDecimalString(String value) {
    if (value.isEmpty) return 0.0;
    
    // Replace comma with dot for proper decimal parsing
    String normalizedValue = value.replaceAll(',', '.');
    
    // Remove any spaces
    normalizedValue = normalizedValue.replaceAll(' ', '');
    
    return double.tryParse(normalizedValue) ?? 0.0;
  }
  
  /// Format a double value to string with proper decimal formatting
  static String formatDecimal(double value, {int decimalPlaces = 2}) {
    return value.toStringAsFixed(decimalPlaces);
  }
}
