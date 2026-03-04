class ApiResponse<T> {
  final List<T> items;
  final int totalCount;
  final int pageIndex;
  final int pageSize;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  ApiResponse({
    required this.items,
    required this.totalCount,
    required this.pageIndex,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  static int _intFromJson(dynamic value, [int fallback = 0]) {
    if (value == null) return fallback;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? fallback;
  }

  static bool _boolFromJson(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    return value.toString().toLowerCase() == 'true';
  }

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    final rawItems = json['items'] ?? json['Items'];
    final list = rawItems is List ? rawItems : <dynamic>[];
    return ApiResponse<T>(
      items: list.map((item) => fromJsonT(item)).toList(),
      totalCount: _intFromJson(json['totalCount'] ?? json['TotalCount']),
      pageIndex: _intFromJson(json['pageIndex'] ?? json['PageIndex'], 1),
      pageSize: _intFromJson(json['pageSize'] ?? json['PageSize'], 10),
      totalPages: _intFromJson(json['totalPages'] ?? json['TotalPages'], 1),
      hasPreviousPage: _boolFromJson(json['hasPreviousPage'] ?? json['HasPreviousPage']),
      hasNextPage: _boolFromJson(json['hasNextPage'] ?? json['HasNextPage']),
    );
  }
}