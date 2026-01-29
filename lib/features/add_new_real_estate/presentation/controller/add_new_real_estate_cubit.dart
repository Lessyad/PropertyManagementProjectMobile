import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/core/constants/local_keys.dart';
import 'package:enmaa/core/entites/amenity_entity.dart';
import 'package:enmaa/core/entites/image_entity.dart';
import 'package:enmaa/core/extensions/furnished_status_extension.dart';
import 'package:enmaa/core/extensions/land_license_status_extension.dart';
import 'package:enmaa/core/extensions/operation_type_property_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/apartment_type_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/building_type_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/land_type_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/villa_type_extension.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/services/convert_string_to_enum.dart';
import 'package:enmaa/core/services/select_location_service/presentation/controller/select_location_service_cubit.dart';
import 'package:enmaa/core/services/service_locator.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/apartment_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/building_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/land_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/villa_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/domain/use_cases/add_new_apartment_use_case.dart';
import 'package:enmaa/features/add_new_real_estate/domain/use_cases/add_new_building_use_case.dart';
import 'package:enmaa/features/add_new_real_estate/domain/use_cases/add_new_land_use_case.dart';
import 'package:enmaa/features/add_new_real_estate/domain/use_cases/get_property_amenities_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/components/property_form_controller.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/models/image_model.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/utils/enums.dart';
import '../../../home_module/home_imports.dart';
import '../../../real_estates/data/models/apartment_details_model.dart';
import '../../../real_estates/data/models/building_drtails_model.dart';
import '../../../real_estates/data/models/land_details_model.dart';
import '../../../real_estates/data/models/villa_details_model.dart';
import '../../../real_estates/domain/entities/property_details_entity.dart';
import '../../../real_estates/domain/use_cases/get_property_details_use_case.dart';
import '../../data/models/property_request_model.dart';
import '../../domain/use_cases/add_villa_use_case.dart';
import '../../domain/use_cases/update_apartment_use_case.dart';
import '../../domain/use_cases/update_building_use_case.dart';
import '../../domain/use_cases/update_land_use_case.dart';
import '../../domain/use_cases/update_villa_use_case.dart';

part 'add_new_real_estate_state.dart';

class AddNewRealEstateCubit extends Cubit<AddNewRealEstateState> {
  AddNewRealEstateCubit(
      this._addNewApartmentUseCase,
      this._addVillaUseCase,
      this._addNewBuildingUseCase,
      this._addNewLandUseCase,
      this._getPropertyAmenitiesUseCase,
      this._getPropertyDetailsUseCase,
      this._updateApartmentUseCase,
      this._updateVillaUseCase,
      this._updateBuildingUseCase,
      this._updateLandUseCase,
      ) : super(const AddNewRealEstateState());

  final PropertyFormController formController = PropertyFormController();
  final formKey = GlobalKey<FormState>();
  final priceForm = GlobalKey<FormState>();
  final locationForm = GlobalKey<FormState>();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController rentDurationController = TextEditingController();

  final AddNewApartmentUseCase _addNewApartmentUseCase;
  final AddVillaUseCase _addVillaUseCase;
  final AddNewBuildingUseCase _addNewBuildingUseCase;
  final AddNewLandUseCase _addNewLandUseCase;
  final GetPropertyAmenitiesUseCase _getPropertyAmenitiesUseCase;
  final GetPropertyDetailsUseCase _getPropertyDetailsUseCase;
  final UpdateApartmentUseCase _updateApartmentUseCase;
  final UpdateVillaUseCase _updateVillaUseCase;
  final UpdateBuildingUseCase _updateBuildingUseCase;
  final UpdateLandUseCase _updateLandUseCase;

  Future<void> selectImages() async {
    emit(state.copyWith(selectImagesState: RequestState.loading));

    final ImagePickerHelper imagePickerHelper = ImagePickerHelper();
    final result = await imagePickerHelper.pickImages(maxImages: 5 - state.selectedImages.length);

    result.fold(
          (failure) {
        emit(state.copyWith(selectImagesState: RequestState.loaded));
      },
          (xFiles) async {
        if (xFiles.isEmpty) {
          emit(state.copyWith(selectImagesState: RequestState.loaded, validateImages: true));
          return;
        }
        final processedFiles = await imagePickerHelper.processImagesWithResiliency(xFiles);
        emit(state.copyWith(
          selectImagesState: RequestState.loaded,
          validateImages: true,
          selectedImages: [...state.selectedImages, ...processedFiles],
        ));
      },
    );
  }

  void removeImage(int index) {
    emit(state.copyWith(selectImagesState: RequestState.loading));
    final List<File> newImages = List.from(state.selectedImages)..removeAt(index);
    emit(state.copyWith(selectedImages: newImages, selectImagesState: RequestState.loaded));
  }

  bool validateImages() {
    if (state.selectedImages.isEmpty) {
      emit(state.copyWith(validateImages: false));
    } else {
      emit(state.copyWith(validateImages: true));
    }
    return state.selectedImages.isNotEmpty;
  }

  void changePropertyOperationType(PropertyOperationType propertyOperationType) {
    emit(state.copyWith(currentPropertyOperationType: propertyOperationType));
  }

  void changeSelectedLocation(LatLng location) {
    emit(state.copyWith(selectedLocation: location));
  }

  void changePropertyType(PropertyType propertyType) {
    if(!state.getPropertyDetailsState.isInitial) return ;
    getAmenities(propertyType.toJsonId.toString());
    emit(state.copyWith(currentPropertyType: propertyType));
  }

  void changeApartmentType(ApartmentType apartmentType) {
    emit(state.copyWith(currentApartmentType: apartmentType));
  }

  void changeVillaType(VillaType villaType) {
    emit(state.copyWith(currentVillaType: villaType));
  }

  void changeBuildingType(BuildingType buildingType) {
    emit(state.copyWith(currentBuildingType: buildingType));
  }

  void changeLandType(LandType landType) {
    emit(state.copyWith(currentLandType: landType));
  }

  void changeAvailabilityForRenewal() {
    emit(state.copyWith(availableForRenewal: !state.availableForRenewal));
  }

  void changeFurnishingStatus(FurnishingStatus furnishingStatus) {
    emit(state.copyWith(currentFurnishingStatus: furnishingStatus));
  }

  void changeLandLicence(LandLicenseStatus landLicenseStatus) {
    emit(state.copyWith(landLicenseStatus: landLicenseStatus));
  }

  void changeSelectedCity(String cityId, String cityName) {
    emit(state.copyWith(selectedCityId: cityId, selectedCityName: cityName));
  }

  void changePaymentMethod(PaymentMethod paymentMethod) {
    emit(state.copyWith(currentPaymentMethod: paymentMethod));
  }

  Future<void> fetchPropertyDetailsAndPopulateIt(String propertyID) async {
    emit(state.copyWith(getPropertyDetailsState: RequestState.loading));

    final Either<Failure, BasePropertyDetailsEntity> result = await _getPropertyDetailsUseCase(propertyID);

    result.fold(
          (failure) => emit(state.copyWith(
        getPropertyDetailsState: RequestState.error,
        getPropertyDetailsError: failure.message,
      )),
          (property) async {
        await populateStateWithPropertyDetails(property);

        String propertyTypeId;
        if (property is VillaDetailsModel) {
          propertyTypeId = PropertyType.villa.toJsonId.toString();
        } else if (property is ApartmentDetailsModel) {
          propertyTypeId = PropertyType.apartment.toJsonId.toString();
        } else if (property is BuildingDetailsModel) {
          propertyTypeId = PropertyType.building.toJsonId.toString();
        } else if (property is LandDetailsModel) {
          propertyTypeId = PropertyType.land.toJsonId.toString();
        } else {
          propertyTypeId = PropertyType.apartment.toJsonId.toString();
        }

        await getAmenities(propertyTypeId).then((_) {
          for (var amenity in property.amenities) {
            selectAmenity(amenity.id.toString());
          }
        });

        emit(state.copyWith(
          getPropertyDetailsState: RequestState.loaded,
          propertyDetailsEntity: property,
        ));
      },
    );
  }

  Future<List<File>> _downloadImages(List<ImageEntity> imageModels) async {
    final dio = Dio();
    final tempDir = await getTemporaryDirectory();
    final List<File> localFiles = [];

    for (var img in imageModels) {
      if (img.image.startsWith('http')) {
        try {
          final fileName = 'downloaded_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final filePath = '${tempDir.path}/$fileName';

          await dio.download(
            img.image,
            filePath,
            options: Options(responseType: ResponseType.bytes),
          );

          final file = File(filePath);
          if (await file.exists()) {
            localFiles.add(file);
          }
        } catch (e) {
          CustomSnackBar.show(message: e.toString());
        }
      } else {
        localFiles.add(File(img.image));
      }
    }

    return localFiles;
  }
  Future<void> populateStateWithPropertyDetails(BasePropertyDetailsEntity propertyDetails) async {
    addressController.text = propertyDetails.title;
    descriptionController.text = propertyDetails.description;
    priceController.text = propertyDetails.price;

    final operationType = propertyDetails.operation == PropertyOperationType.forSale.toRequest
        ? PropertyOperationType.forSale
        : PropertyOperationType.forRent;

    if (operationType == PropertyOperationType.forRent) {
      rentController.text = propertyDetails.price;
      rentDurationController.text = propertyDetails.monthlyRentPeriod ?? '';
    }

    final latLng = LatLng(
      double.parse(propertyDetails.latitude.toString()),
      double.parse(propertyDetails.longitude.toString()),
    );

    final localImages = await _downloadImages(propertyDetails.images);

    if (propertyDetails is ApartmentDetailsModel) {
      final apartment = propertyDetails;
      formController.getController(LocalKeys.apartmentAreaController).text = apartment.area.toString();
      formController.getController(LocalKeys.apartmentFloorsController).text = apartment.floor.toString();
      formController.getController(LocalKeys.apartmentRoomsController).text = apartment.rooms.toString();
      formController.getController(LocalKeys.apartmentBathRoomsController).text = apartment.bathrooms.toString();

      emit(state.copyWith(
        currentPropertyType: PropertyType.apartment,

        currentApartmentType: getApartmentType(apartment.propertySubType),
        currentFurnishingStatus: apartment.isFurnished ? FurnishingStatus.furnished : FurnishingStatus.notFurnished,
        availableForRenewal: apartment.rentIsRenewable,
      ));
    } else if (propertyDetails is VillaDetailsModel) {
      final villa = propertyDetails;
      formController.getController(LocalKeys.villaAreaController).text = villa.area.toString();
      formController.getController(LocalKeys.villaFloorsController).text = villa.numberOfFloors.toString();
      formController.getController(LocalKeys.villaRoomsController).text = villa.rooms.toString();
      formController.getController(LocalKeys.villaBathRoomsController).text = villa.bathrooms.toString();

      emit(state.copyWith(
        currentPropertyType: PropertyType.villa,
        currentVillaType: getVillaType(villa.propertySubType),
        currentFurnishingStatus: villa.isFurnished ? FurnishingStatus.furnished : FurnishingStatus.notFurnished,
        availableForRenewal: villa.rentIsRenewable,
      ));
    } else if (propertyDetails is BuildingDetailsModel) {
      final building = propertyDetails;
      formController.getController(LocalKeys.buildingAreaController).text = building.area.toString();
      formController.getController(LocalKeys.buildingFloorsController).text = building.numberOfFloors.toString();
      formController.getController(LocalKeys.buildingApartmentsPerFloorController).text = building.numberOfApartmentsPerFloor.toString();

      emit(state.copyWith(
        currentPropertyType: PropertyType.building,
        currentBuildingType: getBuildingType(building.propertySubType),
        availableForRenewal: building.rentIsRenewable,
      ));
    } else if (propertyDetails is LandDetailsModel) {
      final land = propertyDetails;
      formController.getController(LocalKeys.landAreaController).text = land.area.toString();

      emit(state.copyWith(
        currentPropertyType: PropertyType.land,
        currentLandType:  getLandType(land.propertySubType),
        landLicenseStatus: land.isLicensed ? LandLicenseStatus.licensed : LandLicenseStatus.notLicensed,
        availableForRenewal: land.rentIsRenewable,
      ));
    }




    

    emit(state.copyWith(
      currentPropertyOperationType: operationType,
      selectedLocation: latLng,
      selectedImages: localImages,
      validateImages: localImages.isNotEmpty,
    ));
  }

  Future<List<PropertyImage>> _processImages() async {
    return await Future.wait(
      state.selectedImages.asMap().entries.map((entry) async {
        final index = entry.key;
        final img = entry.value;
        return PropertyImage(filePath: img.path, isMain: index == 0);
      }),
    );
  }

  Map<String, dynamic> _extractCommonFields({required String areaControllerKey , required SelectLocationServiceCubit locationServiceCubit}) {
    final String title = addressController.text.trim();
    final String description = descriptionController.text.trim();
    final double price = double.tryParse(priceController.text.trim()) ?? 0;
    final String area = formController.getController(areaControllerKey).text.trim();
    String city = locationServiceCubit.state.selectedCity!.id.toString();
    String latitude = state.selectedLocation!.latitude.toString();
    String longitude = state.selectedLocation!.longitude.toString();

    final List<String> amenities = state.selectedAmenities;

    return {
      'title': title,
      'description': description,
      'price': state.currentPropertyOperationType.isForSale ? price : double.tryParse(rentController.text.trim()) ?? 0,
      'area': area,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'amenities': amenities,
    };
  }



  Future<ApartmentRequestModel> _getApartmentRequestModel(SelectLocationServiceCubit locationServiceCubit) async {
    final common = _extractCommonFields(areaControllerKey: LocalKeys.apartmentAreaController, locationServiceCubit: locationServiceCubit);
    final bool isFurnitured = state.currentFurnishingStatus.isFurnished;
    final String floor = formController.getController(LocalKeys.apartmentFloorsController).text.trim();
    final String rooms = formController.getController(LocalKeys.apartmentRoomsController).text.trim();
    final String bathrooms = formController.getController(LocalKeys.apartmentBathRoomsController).text.trim();
    final List<PropertyImage> images = await _processImages();

    return ApartmentRequestModel(
      propertySubType: state.currentApartmentType.toId.toString(),
      title: common['title'],
      description: common['description'],
      price: common['price'],
      area: common['area'],
      latitude: common['latitude'],
      longitude: common['longitude'],
      city: common['city'],
      amenities: common['amenities'],
      isFurnitured: isFurnitured,
      floor: floor,
      rooms: rooms,
      bathrooms: bathrooms,
      images: images,
      currentPropertyOperationType: state.currentPropertyOperationType.toRequest,
      monthlyRentPeriod: state.currentPropertyOperationType.isForSale? null :  state.currentPropertyOperationType.isForRent? int.parse(rentDurationController.text) : 0 ,
      isRenewable: state.currentPropertyOperationType.isForSale? null : state.availableForRenewal,
    );
  }

  Future<VillaRequestModel> _getVillaRequestModel(SelectLocationServiceCubit locationServiceCubit) async {
    final common = _extractCommonFields(areaControllerKey: LocalKeys.villaAreaController , locationServiceCubit: locationServiceCubit);
    final bool isFurnitured = state.currentFurnishingStatus.isFurnished;
    final String numberOfFloors = formController.getController(LocalKeys.villaFloorsController).text.trim();
    final String rooms = formController.getController(LocalKeys.villaRoomsController).text.trim();
    final String bathrooms = formController.getController(LocalKeys.villaBathRoomsController).text.trim();
    final List<PropertyImage> images = await _processImages();
    final String villaSubType = state.currentVillaType.toId.toString();

    return VillaRequestModel(
      propertySubType: villaSubType,
      currentPropertyOperationType: state.currentPropertyOperationType.toRequest,
      title: common['title'],
      description: common['description'],
      price: common['price'],
      images: images,
      city: common['city'],
      latitude: common['latitude'],
      longitude: common['longitude'],
      amenities: common['amenities'],
      area: common['area'],
      isFurnitured: isFurnitured,
      numberOfFloors: int.parse(numberOfFloors),
      rooms: int.parse(rooms),
      bathrooms: int.parse(bathrooms),
      monthlyRentPeriod: state.currentPropertyOperationType.isForSale? null :  state.currentPropertyOperationType.isForRent? int.parse(rentDurationController.text) : 0 ,
      isRenewable: state.currentPropertyOperationType.isForSale? null : state.availableForRenewal,
    );
  }

  Future<BuildingRequestModel> _getBuildingRequestModel(SelectLocationServiceCubit locationServiceCubit) async {
    final common = _extractCommonFields(areaControllerKey: LocalKeys.buildingAreaController, locationServiceCubit: locationServiceCubit);
    final String numberOfFloorsStr = formController.getController(LocalKeys.buildingFloorsController).text.trim();
    final String numberOfApartmentsStr = formController.getController(LocalKeys.buildingApartmentsPerFloorController).text.trim();
    final List<PropertyImage> images = await _processImages();

    return BuildingRequestModel(
      currentPropertyOperationType: state.currentPropertyOperationType.toRequest,
      title: common['title'],
      description: common['description'],
      price: common['price'],
      images: images,
      city: common['city'],
      latitude: common['latitude'],
      longitude: common['longitude'],
      amenities: common['amenities'],
      area: common['area'],
      numberOfFloors: int.parse(numberOfFloorsStr),
      numberOfApartments: int.parse(numberOfApartmentsStr),
      monthlyRentPeriod: state.currentPropertyOperationType.isForSale? null :  state.currentPropertyOperationType.isForRent? int.parse(rentDurationController.text) : 0 ,
      isRenewable: state.currentPropertyOperationType.isForSale? null : state.availableForRenewal,
      propertySubType: state.currentBuildingType.toId.toString(),
    );
  }

  Future<LandRequestModel> _getLandRequestModel(SelectLocationServiceCubit locationServiceCubit) async {
    final common = _extractCommonFields(areaControllerKey: LocalKeys.landAreaController, locationServiceCubit: locationServiceCubit);
    final List<PropertyImage> images = await _processImages();
    final bool isLicensed = state.landLicenseStatus.isLicensed;

    return LandRequestModel(
      currentPropertyOperationType: state.currentPropertyOperationType.toRequest,
      title: common['title'],
      description: common['description'],
      price: common['price'],
      images: images,
      city: common['city'],
      latitude: common['latitude'],
      longitude: common['longitude'],
      amenities: common['amenities'],
      area: common['area'],
      isLicensed: isLicensed,
      monthlyRentPeriod: state.currentPropertyOperationType.isForSale? null :  state.currentPropertyOperationType.isForRent? int.parse(rentDurationController.text) : 0 ,
      isRenewable: state.currentPropertyOperationType.isForSale? null : state.availableForRenewal,
      propertySubType: state.currentLandType.toId.toString(),
    );
  }

  void addNewApartment(SelectLocationServiceCubit locationServiceCubit) async {
    emit(state.copyWith(addNewApartmentState: RequestState.loading));
    final ApartmentRequestModel requestModel = await _getApartmentRequestModel(locationServiceCubit);
    final Either<Failure, void> result = await _addNewApartmentUseCase(requestModel);

    result.fold(
          (failure) => emit(state.copyWith(
        addNewApartmentState: RequestState.error,
        addNewApartmentErrorMessage: failure.message,
      )),
          (_) => emit(state.copyWith(addNewApartmentState: RequestState.loaded)),
    );
  }

  void addNewVilla(SelectLocationServiceCubit locationServiceCubit) async {
    emit(state.copyWith(addNewApartmentState: RequestState.loading));
    final VillaRequestModel requestModel = await _getVillaRequestModel(locationServiceCubit);
    final Either<Failure, void> result = await _addVillaUseCase(requestModel);

    result.fold(
          (failure) => emit(state.copyWith(
        addNewApartmentState: RequestState.error,
        addNewApartmentErrorMessage: failure.message,
      )),
          (_) => emit(state.copyWith(addNewApartmentState: RequestState.loaded)),
    );
  }

  void addNewBuilding(SelectLocationServiceCubit locationServiceCubit) async {
    emit(state.copyWith(addNewApartmentState: RequestState.loading));
    final BuildingRequestModel requestModel = await _getBuildingRequestModel(locationServiceCubit);
    final Either<Failure, void> result = await _addNewBuildingUseCase(requestModel);

    result.fold(
          (failure) => emit(state.copyWith(
        addNewApartmentState: RequestState.error,
        addNewApartmentErrorMessage: failure.message,
      )),
          (_) => emit(state.copyWith(addNewApartmentState: RequestState.loaded)),
    );
  }

  void addNewLand(SelectLocationServiceCubit locationServiceCubit) async {
    emit(state.copyWith(addNewApartmentState: RequestState.loading));
    final LandRequestModel requestModel = await _getLandRequestModel(locationServiceCubit);
    final Either<Failure, void> result = await _addNewLandUseCase(requestModel);

    result.fold(
          (failure) => emit(state.copyWith(
        addNewApartmentState: RequestState.error,
        addNewApartmentErrorMessage: failure.message,
      )),
          (_) => emit(state.copyWith(addNewApartmentState: RequestState.loaded)),
    );
  }

  Future<void> updateApartment({
    required String apartmentId,
    bool replaceImages = false,
    String? mainImageId,
    required SelectLocationServiceCubit locationServiceCubit,
  }) async {
    emit(state.copyWith(updateApartmentState: RequestState.loading));

    final original = state.propertyDetailsEntity as ApartmentDetailsModel;
    final current = await _getApartmentRequestModel(locationServiceCubit);

    final updatedFields = <String, dynamic>{};

    // Compare and update fields
    if (original.title != current.title) updatedFields['title'] = current.title;
    if (original.description != current.description) updatedFields['description'] = current.description;
    if (current.price.toInt() != double.parse(original.price).toInt()) updatedFields['price'] = current.price;
    if (original.area.toString() != current.area) updatedFields['area'] = current.area;
    if (locationServiceCubit.state.selectedCity!.name != original.city) updatedFields['city'] = current.city;
    if (original.latitude.toString() != current.latitude) updatedFields['latitude'] = current.latitude;
    if (original.longitude.toString() != current.longitude) updatedFields['longitude'] = current.longitude;
    if (original.floor.toString() != current.floor) updatedFields['floor'] = current.floor;
    if (original.rooms.toString() != current.rooms) updatedFields['rooms'] = current.rooms;
    if (original.bathrooms.toString() != current.bathrooms) updatedFields['bathrooms'] = current.bathrooms;
    if (current.propertySubType != getApartmentType(original.propertySubType).toId.toString()) updatedFields['property_sub_type'] = current.propertySubType;
    if (original.operation != current.currentPropertyOperationType) updatedFields['operation'] = current.currentPropertyOperationType;
    if (original.isFurnished != current.isFurnitured) updatedFields['is_furnitured'] = current.isFurnitured;

    // Handle amenities
    final originalAmenities = original.amenities.map((a) => a.id.toString()).toList()..sort();
    final currentAmenities = current.amenities.toList()..sort();

    bool isAmenitiesChanged = originalAmenities.length != currentAmenities.length;
    if (!isAmenitiesChanged) {
      for (var i = 0; i < originalAmenities.length; i++) {
        if (originalAmenities[i] != currentAmenities[i]) {
          isAmenitiesChanged = true;
          break;
        }
      }
    }

    if (isAmenitiesChanged) {
      updatedFields['amenities'] = current.amenities;
    }

    if (state.currentPropertyOperationType.isForRent) {
      if (original.monthlyRentPeriod != current.monthlyRentPeriod.toString()) {
        updatedFields['monthly_rent_period'] = current.monthlyRentPeriod;
      }
      if (original.rentIsRenewable != current.isRenewable) {
        updatedFields['is_renewable'] = current.isRenewable;
      }
    }

    if (state.selectedImages.isNotEmpty) {
      updatedFields['images'] = await _processImages();
      updatedFields['replace_images'] = 'true';
    }

    final result = await _updateApartmentUseCase(apartmentId: apartmentId, updatedFields: updatedFields);

    result.fold(
          (failure) => emit(state.copyWith(
        updateApartmentState: RequestState.error,
        updateApartmentErrorMessage: failure.message,
      )),
          (updatedApartment) => emit(state.copyWith(
        updateApartmentState: RequestState.loaded,
      )),
    );
  }

  Future<void> updateVilla({
    required String villaId,
    bool replaceImages = false,
    String? mainImageId,
    required SelectLocationServiceCubit locationServiceCubit,
  }) async {
    emit(state.copyWith(updateVillaState: RequestState.loading));

    final original = state.propertyDetailsEntity as VillaDetailsModel;
    final current = await _getVillaRequestModel(locationServiceCubit);

    final updatedFields = <String, dynamic>{};

    // Compare and update fields
    if (original.title != current.title) updatedFields['title'] = current.title;
    if (original.description != current.description) updatedFields['description'] = current.description;
    if (current.price.toInt() != double.parse(original.price).toInt()) updatedFields['price'] = current.price;
    if (original.area.toString() != current.area) updatedFields['area'] = current.area;
    if (locationServiceCubit.state.selectedCity!.name != original.city) updatedFields['city'] = current.city;
    if (original.latitude.toString() != current.latitude) updatedFields['latitude'] = current.latitude;
    if (original.longitude.toString() != current.longitude) updatedFields['longitude'] = current.longitude;
    if (original.numberOfFloors.toString() != current.numberOfFloors.toString()) updatedFields['number_of_floors'] = current.numberOfFloors;
    if (original.rooms.toString() != current.rooms.toString()) updatedFields['rooms'] = current.rooms;
    if (original.bathrooms.toString() != current.bathrooms.toString()) updatedFields['bathrooms'] = current.bathrooms;
    if (current.propertySubType != getVillaType(original.propertySubType).toId.toString()) updatedFields['property_sub_type'] = current.propertySubType;
    if (original.operation != current.currentPropertyOperationType) updatedFields['operation'] = current.currentPropertyOperationType;
    if (original.isFurnished != current.isFurnitured) updatedFields['is_furnitured'] = current.isFurnitured;

    // Handle amenities
    final originalAmenities = original.amenities.map((a) => a.id.toString()).toList()..sort();
    final currentAmenities = current.amenities.toList()..sort();

    bool isAmenitiesChanged = originalAmenities.length != currentAmenities.length;
    if (!isAmenitiesChanged) {
      for (var i = 0; i < originalAmenities.length; i++) {
        if (originalAmenities[i] != currentAmenities[i]) {
          isAmenitiesChanged = true;
          break;
        }
      }
    }

    if (isAmenitiesChanged) {
      updatedFields['amenities'] = current.amenities;
    }

    // Handle rent-specific fields
    if (state.currentPropertyOperationType.isForRent) {
      if (original.monthlyRentPeriod != current.monthlyRentPeriod.toString()) {
        updatedFields['monthly_rent_period'] = current.monthlyRentPeriod;
      }
      if (original.rentIsRenewable != current.isRenewable) {
        updatedFields['is_renewable'] = current.isRenewable;
      }
    }

    // Handle images
    if (state.selectedImages.isNotEmpty) {
      updatedFields['images'] = await _processImages();
      updatedFields['replace_images'] = 'true';
    }

    // Call the use case
    final result = await _updateVillaUseCase(villaId: villaId, updatedFields: updatedFields);

    result.fold(
          (failure) => emit(state.copyWith(
        updateVillaState: RequestState.error,
        updateVillaErrorMessage: failure.message,
      )),
          (updatedVilla) => emit(state.copyWith(
        updateVillaState: RequestState.loaded,
      )),
    );
  }

  Future<void> updateBuilding({
    required String buildingId,
    bool replaceImages = false,
    String? mainImageId,
    required SelectLocationServiceCubit locationServiceCubit,
  }) async {
    emit(state.copyWith(updateBuildingState: RequestState.loading));

    final original = state.propertyDetailsEntity as BuildingDetailsModel;
    final current = await _getBuildingRequestModel(locationServiceCubit);

    final updatedFields = <String, dynamic>{};

    // Compare and update fields
    if (original.title != current.title) updatedFields['title'] = current.title;
    if (original.description != current.description) updatedFields['description'] = current.description;
    if (current.price.toInt() != double.parse(original.price).toInt()) updatedFields['price'] = current.price;
    if (original.area.toString() != current.area) updatedFields['area'] = current.area;
    if (locationServiceCubit.state.selectedCity!.name != original.city) updatedFields['city'] = current.city;
    if (original.latitude.toString() != current.latitude) updatedFields['latitude'] = current.latitude;
    if (original.longitude.toString() != current.longitude) updatedFields['longitude'] = current.longitude;
    if (original.numberOfFloors.toString() != current.numberOfFloors.toString()) updatedFields['number_of_floors'] = current.numberOfFloors;
    if (original.numberOfApartmentsPerFloor.toString() != current.numberOfApartments.toString()) updatedFields['number_of_apartments'] = current.numberOfApartments;
    if (current.propertySubType != getBuildingType(original.propertySubType).toId.toString()) updatedFields['property_sub_type'] = current.propertySubType;
    if (original.operation != current.currentPropertyOperationType) updatedFields['operation'] = current.currentPropertyOperationType;

    // Handle amenities
    final originalAmenities = original.amenities.map((a) => a.id.toString()).toList()..sort();
    final currentAmenities = current.amenities.toList()..sort();

    bool isAmenitiesChanged = originalAmenities.length != currentAmenities.length;
    if (!isAmenitiesChanged) {
      for (var i = 0; i < originalAmenities.length; i++) {
        if (originalAmenities[i] != currentAmenities[i]) {
          isAmenitiesChanged = true;
          break;
        }
      }
    }

    if (isAmenitiesChanged) {
      updatedFields['amenities'] = current.amenities;
    }

    // Handle rent-specific fields
    if (state.currentPropertyOperationType.isForRent) {
      if (original.monthlyRentPeriod != current.monthlyRentPeriod.toString()) {
        updatedFields['monthly_rent_period'] = current.monthlyRentPeriod;
      }
      if (original.rentIsRenewable != current.isRenewable) {
        updatedFields['is_renewable'] = current.isRenewable;
      }
    }

    // Handle images
    if (state.selectedImages.isNotEmpty) {
      updatedFields['images'] = await _processImages();
      updatedFields['replace_images'] = 'true';
    }

    // Call the use case
    final result = await _updateBuildingUseCase(buildingId: buildingId, updatedFields: updatedFields);

    result.fold(
          (failure) => emit(state.copyWith(
        updateBuildingState: RequestState.error,
        updateBuildingErrorMessage: failure.message,
      )),
          (updatedBuilding) => emit(state.copyWith(
        updateBuildingState: RequestState.loaded,
      )),
    );
  }

  Future<void> updateLand({
    required String landId,
    required SelectLocationServiceCubit locationServiceCubit,
  }) async {
    emit(state.copyWith(updateLandState: RequestState.loading));

    final original = state.propertyDetailsEntity as LandDetailsModel;

    final current = await _getLandRequestModel(locationServiceCubit);

    final updatedFields = <String, dynamic>{};

    if (original.title != current.title) updatedFields['title'] = current.title;
    if (original.description != current.description) updatedFields['description'] = current.description;
    if (current.price.toInt() != double.parse(original.price).toInt()) updatedFields['price'] = current.price;
    if (original.area.toString() != current.area) updatedFields['area'] = current.area;
    if (locationServiceCubit.state.selectedCity!.name != original.city) updatedFields['city'] = current.city;
    if (original.latitude.toString() != current.latitude) updatedFields['latitude'] = current.latitude;
    if (original.longitude.toString() != current.longitude) updatedFields['longitude'] = current.longitude;
    if (original.isLicensed != current.isLicensed) updatedFields['is_licensed'] = current.isLicensed;
    if (current.propertySubType != getLandType(original.propertySubType).toId.toString()) updatedFields['property_sub_type'] = current.propertySubType;
    if (original.operation != current.currentPropertyOperationType) updatedFields['operation'] = current.currentPropertyOperationType;


    final originalAmenities = original.amenities.map((a) => a.id.toString()).toList()..sort();
    final currentAmenities = current.amenities.toList()..sort();

    bool isAmenitiesChanged = false;

    if (originalAmenities.length != currentAmenities.length) {
      isAmenitiesChanged = true;
    } else {
      for (var i = 0; i < originalAmenities.length; i++) {
        if (originalAmenities[i] != currentAmenities[i]) {
          isAmenitiesChanged = true;
          break;
        }
      }
    }

    if (isAmenitiesChanged) {
      updatedFields['amenities'] = current.amenities;
    }

    if (state.currentPropertyOperationType.isForRent) {
      if (original.monthlyRentPeriod != current.monthlyRentPeriod.toString()) {
        updatedFields['monthly_rent_period'] = current.monthlyRentPeriod;
      }
      if (original.rentIsRenewable != current.isRenewable) {
        updatedFields['is_renewable'] = current.isRenewable;
      }
    }


    if (state.selectedImages.isNotEmpty) {
      updatedFields['images'] = await _processImages();
      updatedFields['replace_images'] = 'true';
    }



    final result = await _updateLandUseCase(landId: landId, updatedFields: updatedFields);

    result.fold(
          (failure) => emit(state.copyWith(
        updateLandState: RequestState.error,
        updateLandErrorMessage: failure.message,
      )),
          (updatedLand) => emit(state.copyWith(
        updateLandState: RequestState.loaded,
      )),
    );
  }


  Future<void> getAmenities(String propertyType) async {
    emit(state.copyWith(getAmenitiesState: RequestState.loading));
    final Either<Failure, List<AmenityEntity>> result = await _getPropertyAmenitiesUseCase(propertyType);

    result.fold(
          (failure) => emit(state.copyWith(getAmenitiesState: RequestState.error)),
          (amenities) {
        emit(state.copyWith(
          getAmenitiesState: RequestState.loaded,
          currentAmenities: amenities,
        ));
      },
    );
  }

  void selectAmenity(String amenityId) {
    final updatedSelectedAmenities = List<String>.from(state.selectedAmenities);
    if (!updatedSelectedAmenities.contains(amenityId)) {
      updatedSelectedAmenities.add(amenityId);
      emit(state.copyWith(selectedAmenities: updatedSelectedAmenities));
    }
  }

  void unSelectAmenity(String amenityId) {
    final updatedSelectedAmenities = List<String>.from(state.selectedAmenities);
    if (updatedSelectedAmenities.contains(amenityId)) {
      updatedSelectedAmenities.remove(amenityId);
      emit(state.copyWith(selectedAmenities: updatedSelectedAmenities));
    }
  }

  @override
  Future<void> close() {
    formController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    rentController.dispose();
    rentDurationController.dispose();
    return super.close();
  }
}