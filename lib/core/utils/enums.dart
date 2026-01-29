enum RequestState { initial, loading, loaded, error }

enum Language { ar, en , fr }

/// Enum for property operation type
enum PropertyOperationType { forSale, forRent }

enum VehicleFuelType
{
  ESSENCE,
  DIESEL,
  ELECTRONIQUE,
  HYBRIDE
}
/// Enum for property type
enum PropertyType { apartment, villa , building, land }

/// Enum for apartment types
enum ApartmentType { studio, duplex, penthouse }

/// Enum for villa types
enum VillaType {
  standalone,
  twinHouse,
  townHouse
}
/// Enum for Building types
enum BuildingType {
  residential, // سكنية
  commercial,  // تجارية
  mixedUse,    // مختلطة
}

/// Enum for Land types
enum LandType {
  freehold,    // حر
  agricultural, // زراعي
  industrial,  // صناعي
}

/// Enum for Furnishing Status
enum FurnishingStatus {
  furnished,
  notFurnished,
}

/// enum for land licence status
enum LandLicenseStatus {
  licensed,
  notLicensed,
}

enum PaymentMethod {
  cash,
  wallet,
}

enum RequestStatus {
  completed,
  cancelled,
  active
}

enum BookingStatus {
  reserved,
  available,
}

enum AppointmentStatus {
  completed,
  cancelled,
  coming ,
}

enum BuyerType {
  iAmBuyer,
  anotherBuyer,
}


enum TransactionType {
  payment,
  refund,
  withdrawal ,
  walletRecharge
}

enum TransactionPurpose {
  propertyDeal,
  viewingRequest,

}