import 'vehicle_entity.dart';

class PagedVehicles {
  final List<VehicleEntity> items;
  final int totalCount;
  final int totalPages;
  final int pageIndex;
  final int pageSize;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PagedVehicles({
    required this.items,
    required this.totalCount,
    required this.totalPages,
    required this.pageIndex,
    required this.pageSize,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });
}
