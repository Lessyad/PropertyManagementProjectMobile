import '../services/shared_preferences_service.dart';

/// Résout le nom localisé (fr/ar/en) renvoyé par le backend pour les entités
/// géographiques (Pays, Ville, Zone, État) et les catégories/marques de véhicules,
/// qui exposent désormais `nameFr` / `nameAr` / `nameEn` au lieu d'un `name` unique.
///
/// Même ordre de repli que `I18nService.getLocalizedName` côté web (FRONTEND) :
/// langue active -> français -> autres langues disponibles.
///
/// La langue active est lue depuis `SharedPreferencesService().language`, la
/// source de vérité utilisée par l'app pour la langue sélectionnée (voir
/// `main.dart` / `language_bottom_sheet_component.dart`) — `Intl.getCurrentLocale()`
/// n'est jamais mis à jour par easy_localization et ne doit pas être utilisé ici.
String resolveLocalizedName({
  required String? nameFr,
  String? nameAr,
  String? nameEn,
}) {
  bool has(String? v) => v != null && v.trim().isNotEmpty;

  final String lang = SharedPreferencesService().language;

  if (lang == 'ar') {
    return has(nameAr) ? nameAr! : has(nameFr) ? nameFr! : (nameEn ?? '');
  }
  if (lang == 'en') {
    return has(nameEn) ? nameEn! : has(nameFr) ? nameFr! : (nameAr ?? '');
  }
  return has(nameFr) ? nameFr! : has(nameEn) ? nameEn! : (nameAr ?? '');
}
