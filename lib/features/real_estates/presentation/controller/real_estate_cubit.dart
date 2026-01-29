import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:enmaa/core/errors/failure.dart';
import 'package:enmaa/core/extensions/operation_type_property_extension.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/real_estates/domain/entities/property_details_entity.dart';
import 'package:enmaa/features/real_estates/domain/use_cases/get_property_details_use_case.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/constants/json_keys.dart';
import '../../domain/entities/base_property_entity.dart';
import '../../domain/use_cases/get_properties_use_case.dart';

part 'real_estate_state.dart';

class RealEstateCubit extends Cubit<RealEstateState> {
  final GetPropertiesUseCase _getPropertiesUseCase;
  final GetPropertyDetailsUseCase _getPropertyDetailsUseCase;

  RealEstateCubit(this._getPropertiesUseCase, this._getPropertyDetailsUseCase)
      : super(const RealEstateState());

  void clearPropertyList(PropertyOperationType operationType) {
    if (operationType == PropertyOperationType.forSale) {
      emit(state.copyWith(
        saleProperties: [],
        saleOffset: 0,
        hasMoreSaleProperties: true,
        saleTabLoaded: false,
      ));
    } else {
      emit(state.copyWith(
        rentProperties: [],
        rentOffset: 0,
        hasMoreRentProperties: true,
        rentTabLoaded: false,
      ));
    }
  }

  void removePropertyById(String propertyId) {
    final saleIndex = state.saleProperties.indexWhere(
          (property) => property.id.toString() == propertyId,
    );
    final updatedSaleProperties = List<PropertyEntity>.from(state.saleProperties);
    if (saleIndex != -1) {
      updatedSaleProperties.removeAt(saleIndex);
    }

    final rentIndex = state.rentProperties.indexWhere(
          (property) => property.id.toString() == propertyId,
    );
    final updatedRentProperties = List<PropertyEntity>.from(state.rentProperties);
    if (rentIndex != -1) {
      updatedRentProperties.removeAt(rentIndex);
    }
    emit(state.copyWith(
      saleProperties: updatedSaleProperties,
      rentProperties: updatedRentProperties,
    ));
  }

  Future<void> fetchProperties({
    Map<String, dynamic>? filters,
    PropertyOperationType operationType = PropertyOperationType.forSale,
    bool refresh = false,
  }) async {
    if (refresh) {
      if (operationType == PropertyOperationType.forSale) {
        emit(state.copyWith(
          getPropertiesSaleState: RequestState.loading,
          saleOffset: 0,
          hasMoreSaleProperties: true,
        ));
      } else {
        emit(state.copyWith(
          getPropertiesRentState: RequestState.loading,
          rentOffset: 0,
          hasMoreRentProperties: true,
        ));
      }
    } else {
      if (operationType == PropertyOperationType.forSale) {
        if (state.getPropertiesSaleState == RequestState.loading ||
            !state.hasMoreSaleProperties) {
          return;
        }
        emit(state.copyWith(getPropertiesSaleState: RequestState.loading));
      } else {
        if (state.getPropertiesRentState == RequestState.loading ||
            !state.hasMoreRentProperties) {
          return;
        }
        emit(state.copyWith(getPropertiesRentState: RequestState.loading));
      }
    }

    final int offset = operationType == PropertyOperationType.forSale
        ? state.saleOffset
        : state.rentOffset;

    final paginatedFilters = {
      ...?filters,
      JsonKeys.offset: offset,
      JsonKeys.limit: state.limit,
      JsonKeys.operation: operationType.isForSale ? 'for_sale' : 'for_rent',
    };

    final Either<Failure, List<PropertyEntity>> result =
    await _getPropertiesUseCase(filters: paginatedFilters);

    result.fold(
          (failure) {
        if (operationType == PropertyOperationType.forSale) {
          emit(state.copyWith(
            getPropertiesSaleState: RequestState.error,
            getPropertiesSaleError: failure.message,
          ));
        } else {
          emit(state.copyWith(
            getPropertiesRentState: RequestState.error,
            getPropertiesRentError: failure.message,
          ));
        }
      },
          (properties) {
        final bool hasMore = properties.length >= state.limit;

        if (operationType == PropertyOperationType.forSale) {
          final List<PropertyEntity> updatedSaleProperties = refresh
              ? properties
              : [...state.saleProperties, ...properties];

          emit(state.copyWith(
            getPropertiesSaleState: RequestState.loaded,
            saleProperties: updatedSaleProperties,
            saleOffset: offset + properties.length,
            hasMoreSaleProperties: hasMore,
            saleTabLoaded: true,
          ));
        } else {
          final List<PropertyEntity> updatedRentProperties = refresh
              ? properties
              : [...state.rentProperties, ...properties];

          emit(state.copyWith(
            getPropertiesRentState: RequestState.loaded,
            rentProperties: updatedRentProperties,
            rentOffset: offset + properties.length,
            hasMoreRentProperties: hasMore,
            rentTabLoaded: true,
          ));
        }
      },
    );
  }

  Future<void> fetchMapProperties({
    required double neLat,
    required double neLng,
    required double swLat,
    required double swLng,
    PropertyOperationType operationType = PropertyOperationType.forSale,
    Map<String, dynamic>? filters,
  }) async {
    emit(state.copyWith(getMapPropertiesState: RequestState.loading));

    final baseFilters = {
      'ne_lat': neLat,
      'ne_lng': neLng,
      'sw_lat': swLat,
      'sw_lng': swLng,
      JsonKeys.limit: 50,
      JsonKeys.operation: operationType.isForSale ? 'for_sale' : 'for_rent',
    };

    final mergedFilters = {
      ...baseFilters,
      ...?filters,
    };

    final Either<Failure, List<PropertyEntity>> result =
    await _getPropertiesUseCase(filters: mergedFilters);

    result.fold(
          (failure) {
        emit(state.copyWith(
          getMapPropertiesState: RequestState.error,
          getMapPropertiesError: failure.message,
        ));
      },
          (properties) {
        if (operationType == PropertyOperationType.forSale) {
          emit(state.copyWith(
            getMapPropertiesState: RequestState.loaded,
            mapProperties: properties,
            saleProperties: properties,
            saleOffset: properties.length,
            hasMoreSaleProperties: properties.length >= state.limit,
            saleTabLoaded: properties.isNotEmpty,
          ));
        } else {
          emit(state.copyWith(
            getMapPropertiesState: RequestState.loaded,
            mapProperties: properties,
            rentProperties: properties,
            rentOffset: properties.length,
            hasMoreRentProperties: properties.length >= state.limit,
            rentTabLoaded: properties.isNotEmpty,
          ));
        }
      },
    );
  }

  Future<void> fetchPropertyDetails(String propertyID) async {
    emit(state.copyWith(getPropertyDetailsState: RequestState.loading));

    final Either<Failure, BasePropertyDetailsEntity> result =
    await _getPropertyDetailsUseCase(propertyID);

    result.fold(
          (failure) => emit(state.copyWith(
        getPropertyDetailsState: RequestState.error,
        getPropertyDetailsError: failure.message,
      )),
          (properties) => emit(state.copyWith(
        getPropertyDetailsState: RequestState.loaded,
        propertyDetails: properties,
      )),
    );
  }

  void removePropertyFromWishList(String propertyID) {
    final BasePropertyDetailsEntity? propertyDetails = state.propertyDetails;

    if (propertyDetails != null) {
      final BasePropertyDetailsEntity updatedPropertyDetails =
      propertyDetails.copyWith(isInWishlist: false);

      emit(state.copyWith(propertyDetails: updatedPropertyDetails));
    }

    removeSelectedPropertyFromWishList(propertyID);
  }

  void addPropertyToWishList(String propertyID) {
    final BasePropertyDetailsEntity? propertyDetails = state.propertyDetails;

    if (propertyDetails != null) {
      final BasePropertyDetailsEntity updatedPropertyDetails =
      propertyDetails.copyWith(isInWishlist: true);

      emit(state.copyWith(propertyDetails: updatedPropertyDetails));
    }

    addSelectedPropertyToWishList(propertyID);
  }

  void removeSelectedPropertyFromWishList(String propertyID) {
    final List<PropertyEntity> saleProperties = state.saleProperties;
    final List<PropertyEntity> updatedSaleProperties = saleProperties
        .map((property) {
      if (property.id.toString() == propertyID) {
        return property.copyWith(isInWishlist: false);
      } else {
        return property;
      }
    })
        .toList();

    final List<PropertyEntity> rentProperties = state.rentProperties;
    final List<PropertyEntity> updatedRentProperties = rentProperties
        .map((property) {
      if (property.id.toString() == propertyID) {
        return property.copyWith(isInWishlist: false);
      } else {
        return property;
      }
    })
        .toList();

    emit(state.copyWith(
      saleProperties: updatedSaleProperties,
      rentProperties: updatedRentProperties,
    ));
  }

  void addSelectedPropertyToWishList(String propertyID) {
    final List<PropertyEntity> saleProperties = state.saleProperties;
    final List<PropertyEntity> updatedSaleProperties = saleProperties
        .map((property) {
      if (property.id.toString() == propertyID) {
        return property.copyWith(isInWishlist: true);
      } else {
        return property;
      }
    })
        .toList();

    final List<PropertyEntity> rentProperties = state.rentProperties;
    final List<PropertyEntity> updatedRentProperties = rentProperties
        .map((property) {
      if (property.id.toString() == propertyID) {
        return property.copyWith(isInWishlist: true);
      } else {
        return property;
      }
    })
        .toList();

    emit(state.copyWith(
      saleProperties: updatedSaleProperties,
      rentProperties: updatedRentProperties,
    ));
  }

  void loadMoreProperties(PropertyOperationType operationType,
      {Map<String, dynamic>? filters}) {
    fetchProperties(operationType: operationType, filters: filters);
  }

  void loadTabData(PropertyOperationType operationType,
      {Map<String, dynamic>? filters}) {
    if (operationType == PropertyOperationType.forSale && !state.saleTabLoaded) {
      fetchProperties(
          operationType: operationType, filters: filters, refresh: true);
    } else if (operationType == PropertyOperationType.forRent &&
        !state.rentTabLoaded) {
      fetchProperties(
          operationType: operationType, filters: filters, refresh: true);
    }
  }
}