import '../utils/enums.dart';

VillaType getVillaType(String type) {
  switch (type) {
    case "independent":
      return VillaType.standalone;
    case "town house":
      return VillaType.townHouse;
    case "twin house":
      return VillaType.twinHouse;
    default:
      return VillaType.standalone;
  }
}

ApartmentType getApartmentType(String type) {
  switch (type) {
    case "studio":
      return ApartmentType.studio;
    case "duplex":
      return ApartmentType.duplex;
    case "benth house":
      return ApartmentType.penthouse;
    default:
      return ApartmentType.studio;
  }
}

BuildingType getBuildingType(String type) {
  switch (type) {
    case "Mixed":
      return BuildingType.mixedUse;
    case "residential":
      return BuildingType.residential;
      case "commercial":
      return BuildingType.commercial;
    default:
      return BuildingType.residential;
  }
}

LandType getLandType(String type) {
  switch (type) {
    case "agriculture":
      return LandType.agricultural;
    case "industrial":
      return LandType.industrial;
    case "free":
      return LandType.freehold;
    default:
      return LandType.freehold;
  }
}

PropertyType getPropertyType(String type) {
  switch (type) {
    case "villa":
      return PropertyType.villa;
    case "apartment":
      return PropertyType.apartment;
    case "building":
      return PropertyType.building;
    case "land":
      return PropertyType.land;
    default:
      return PropertyType.villa;
  }
}

PaymentMethod getPaymentMethod(String type) {
  switch (type) {
    case "cash":
      return PaymentMethod.cash;
    case "wallet":
      return PaymentMethod.wallet;
    default:
      return PaymentMethod.cash;
  }
}

RequestStatus getStatus(String type) {
  switch (type) {
    case "active":
      return RequestStatus.active;
    case "completed":
      return RequestStatus.completed;
    case "cancelled":
      return RequestStatus.cancelled;
    default:
      return RequestStatus.active;
  }
}

BookingStatus getBookingStatus(String type) {
  switch (type) {
    case "reserved":
      return BookingStatus.reserved;
    case "available":
      return BookingStatus.available;
    default:
      return BookingStatus.reserved;
  }
}