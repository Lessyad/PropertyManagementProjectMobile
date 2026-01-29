   import 'package:enmaa/features/real_estates/domain/entities/property_details_entity.dart';

import '../../../../core/entites/amenity_entity.dart';
import '../../../../core/entites/image_entity.dart';

   class LandDetailsEntity extends BasePropertyDetailsEntity {
     final bool isLicensed;
     final String usageType;

     const LandDetailsEntity({
       required super.id,
       required super.title,
       required super.operation,
       required super.price,
       required super.area,
       required super.propertySubType,
       required super.status,
       required super.images,
       required super.amenities,
       required super.description,
       required super.latitude,
       required super.longitude,
       required super.city,
       required super.state,
       required super.country,
       required super.isInWishlist,
       required super.rentIsRenewable,
       required super.monthlyRentPeriod,
       required this.isLicensed,
       required this.usageType, required super.officePhoneNumber, required super.isOwner,
     });

     @override
     List<Object?> get props => [
       ...super.props,
       isLicensed,
       usageType,
     ];

     LandDetailsEntity copyWith({
       int? id,
       String? title,
       String? operation,
       String? price,
       double? area,
       String? propertySubType,
       String? status,
       List<ImageEntity>? images,
       List<AmenityEntity>? amenities,
       String? description,
       double? latitude,
       double? longitude,
       String? city,
       String? state,
       String? country,
       bool? isInWishlist,
       String? monthlyRentPeriod,
       bool? rentIsRenewable,
       bool? isOwner,
       bool? isLicensed,
       String? usageType,
       String?officePhoneNumber ,

     }) {
       return LandDetailsEntity(
         id: id ?? this.id,
         title: title ?? this.title,
         operation: operation ?? this.operation,
         price: price ?? this.price,
         area: area ?? this.area,
         propertySubType: propertySubType ?? this.propertySubType,
         status: status ?? this.status,
         images: images ?? this.images,
         amenities: amenities ?? this.amenities,
         description: description ?? this.description,
         latitude: latitude ?? this.latitude,
         longitude: longitude ?? this.longitude,
         city: city ?? this.city,
         state: state ?? this.state,
         country: country ?? this.country,
         isInWishlist: isInWishlist ?? this.isInWishlist,
         monthlyRentPeriod: monthlyRentPeriod ?? this.monthlyRentPeriod,
         rentIsRenewable: rentIsRenewable ?? this.rentIsRenewable,
         isLicensed: isLicensed ?? this.isLicensed,
         usageType: usageType ?? this.usageType,
          officePhoneNumber: officePhoneNumber ?? this.officePhoneNumber,
         isOwner: isOwner ?? this.isOwner,
       );
     }
   }
