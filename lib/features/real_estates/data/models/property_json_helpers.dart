String readString(dynamic value) {
  final text = value?.toString().trim() ?? '';
  return text.toLowerCase() == 'null' ? '' : text;
}

String readLocalizedName(dynamic json) {
  if (json is! Map) {
    return '';
  }

  return readString(
    json['name'] ??
        json['nameFr'] ??
        json['name_fr'] ??
        json['NameFr'] ??
        json['nameAr'] ??
        json['name_ar'] ??
        json['NameAr'] ??
        json['nameEn'] ??
        json['name_en'] ??
        json['NameEn'],
  );
}
