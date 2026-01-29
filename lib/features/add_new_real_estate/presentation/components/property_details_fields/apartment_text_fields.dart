import 'package:easy_localization/easy_localization.dart'; // Ajouter cette importation
import '../../../../../core/components/generic_form_fields.dart';
import '../../../../../core/components/property_form_controller.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/local_keys.dart';
import '../../../../../core/translation/locale_keys.dart'; // Changer l'importation
import '../../../../../core/utils/form_validator.dart';
import '../../../../home_module/home_imports.dart';
import '../property_fields.dart';

class ApartmentTextFields implements PropertyFields {
  ApartmentTextFields({
    this.fromFilter = false,
  });
  final bool fromFilter;

  @override
  List<Widget> getFields(
      BuildContext context, PropertyFormController controller) {
    return [
    if(!fromFilter)
      GenericFormField(
        label: LocaleKeys.area.tr(), // ← Internationalisé
        hintText: LocaleKeys.enterAreaInSquareMeters.tr(), // ← Internationalisé
        keyboardType: TextInputType.number,
        iconPath: AppAssets.areaIcon,
        controller: controller.getController(LocalKeys.apartmentAreaController), // ← Utiliser LocaleKeys
        validator: (value) =>
            FormValidator.validatePositiveNumber(value, fieldName: LocaleKeys.area.tr()), // ← Internationalisé
      ),
    GenericFormField(
    label: LocaleKeys.floor.tr(), // ← Internationalisé
    hintText: LocaleKeys.enterFloorNumber.tr(), // ← Internationalisé
    keyboardType: TextInputType.number,
    iconPath: AppAssets.landIcon,
    controller: controller.getController(LocalKeys.apartmentFloorsController), // ← Utiliser LocaleKeys
    validator: (value) =>
    FormValidator.validatePositiveNumber(value, fieldName: LocaleKeys.floors.tr()), // ← Internationalisé
    ),
      GenericFormField(
        label: LocaleKeys.numberOfRooms.tr(), // ← Internationalisé
        hintText: LocaleKeys.specifyNumberOfRooms.tr(), // ← Internationalisé
        keyboardType: TextInputType.number,
        iconPath: AppAssets.bedIcon,
        controller: controller.getController(LocalKeys.apartmentRoomsController), // ← Utiliser LocaleKeys
        validator: (value) =>
            FormValidator.validatePositiveNumber(value, fieldName: LocaleKeys.numberOfRooms.tr()), // ← Internationalisé
      ),
      GenericFormField(
        label: LocaleKeys.numberOfBathrooms.tr(), // ← Internationalisé
        hintText: LocaleKeys.specifyNumberOfBathrooms.tr(), // ← Internationalisé
        keyboardType: TextInputType.number,
        iconPath: AppAssets.bedIcon,
        controller: controller.getController(LocalKeys.apartmentBathRoomsController), // ← Utiliser LocaleKeys
        validator: (value) => FormValidator.validatePositiveNumber(
            value,
            fieldName: LocaleKeys.numberOfBathrooms.tr() // ← Internationalisé
        ),
      ),
    ];
  }
}