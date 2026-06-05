import '../../domain/entities/base_property_entity.dart';

class PagedPropertyResponse {
  final List<PropertyEntity> items;
  final int totalCount;

  const PagedPropertyResponse({
    required this.items,
    required this.totalCount,
  });
}
