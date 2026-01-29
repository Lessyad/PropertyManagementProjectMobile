class Country {
  final int id;
  final String name;
  final String? code;

  Country({
    required this.id,
    required this.name,
    this.code,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }
}

class City {
  final int id;
  final String name;
  final int stateId;
  final String? stateName;

  City({
    required this.id,
    required this.name,
    required this.stateId,
    this.stateName,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      stateId: json['stateId'] ?? 0,
      stateName: json['stateName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'stateId': stateId,
      'stateName': stateName,
    };
  }
}

class Area {
  final int id;
  final String name;
  final int cityId;
  final String? cityName;

  Area({
    required this.id,
    required this.name,
    required this.cityId,
    this.cityName,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      cityId: json['cityId'] ?? 0,
      cityName: json['cityName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cityId': cityId,
      'cityName': cityName,
    };
  }
}

