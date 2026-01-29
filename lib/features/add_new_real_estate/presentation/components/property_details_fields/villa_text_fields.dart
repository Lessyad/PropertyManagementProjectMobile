import 'package:easy_localization/easy_localization.dart'; // Ajouter cette importation
import '../../../../../core/components/app_text_field.dart';
import '../../../../../core/components/generic_form_fields.dart';
import '../../../../../core/components/property_form_controller.dart';
import '../../../../../core/components/svg_image_component.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/local_keys.dart';
import '../../../../../core/translation/locale_keys.dart'; // Changer l'importation
import '../../../../home_module/home_imports.dart';
import '../form_widget_component.dart';
import '../property_fields.dart';
import '../../../../../core/utils/form_validator.dart';

class VillaTextFields implements PropertyFields {
  const VillaTextFields({this.fromFilter = false});
  final bool fromFilter;

  @override
  List<Widget> getFields(BuildContext context, PropertyFormController controller) {
    return [
      if(!fromFilter)
        GenericFormField(
          label: LocaleKeys.area.tr(), // ← Internationalisé
          hintText: LocaleKeys.enterAreaInSquareMeters.tr(), // ← Internationalisé
          keyboardType: TextInputType.number,
          iconPath: AppAssets.areaIcon,
          controller: controller.getController(LocalKeys.villaAreaController), // ← Utiliser LocaleKeys
          validator: (value) => FormValidator.validatePositiveNumber(
              value,
              fieldName: LocaleKeys.area.tr() // ← Internationalisé
          ),
        ),
      GenericFormField(
        label: LocaleKeys.numberOfFloors.tr(), // ← Internationalisé
        hintText: LocaleKeys.specifyNumberOfFloors.tr(), // ← Internationalisé
        keyboardType: TextInputType.number,
        iconPath: AppAssets.landIcon,
        controller: controller.getController(LocalKeys.villaFloorsController), // ← Utiliser LocaleKeys
        validator: (value) => FormValidator.validatePositiveNumber(
            value,
            fieldName: LocaleKeys.numberOfFloors.tr() // ← Internationalisé
        ),
      ),
      GenericFormField(
        label: LocaleKeys.numberOfRooms.tr(), // ← Internationalisé
        hintText: LocaleKeys.specifyNumberOfRooms.tr(), // ← Internationalisé
        keyboardType: TextInputType.number,
        iconPath: AppAssets.bedIcon,
        controller: controller.getController(LocalKeys.villaRoomsController), // ← Utiliser LocaleKeys
        validator: (value) => FormValidator.validatePositiveNumber(
            value,
            fieldName: LocaleKeys.numberOfRooms.tr() // ← Internationalisé
        ),
      ),
      GenericFormField(
        label: LocaleKeys.numberOfBathrooms.tr(), // ← Internationalisé
        hintText: LocaleKeys.specifyNumberOfBathrooms.tr(), // ← Internationalisé
        keyboardType: TextInputType.number,
        iconPath: AppAssets.bedIcon,
        controller: controller.getController(LocalKeys.villaBathRoomsController), // ← Utiliser LocaleKeys
        validator: (value) => FormValidator.validatePositiveNumber(
            value,
            fieldName: LocaleKeys.numberOfBathrooms.tr() // ← Internationalisé
        ),
      ),
    ];
  }
}