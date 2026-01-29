import 'package:animate_do/animate_do.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/operation_type_property_extension.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/components/property_details_fields/apartment_text_fields.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/controller/add_new_real_estate_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';

import '../../../../core/utils/enums.dart';
import '../../../home_module/home_imports.dart';
import '../components/form_widget_component.dart';
import '../components/numbered_text_header_component.dart';
import '../components/properties_sub_type/apartment_sub_types_component.dart';
import '../components/properties_sub_type/building_sub_types_component.dart';
import '../components/properties_sub_type/land_sub_types_component.dart';
import '../components/properties_sub_type/villa_sub_types_component.dart';
import '../components/property_details_fields/building_text_fields.dart';
import '../components/property_details_fields/land_text_fields.dart';
import '../components/property_details_fields/villa_text_fields.dart';
import '../components/property_fields.dart';
import '../../../../core/components/reusable_type_selector_component.dart';

class AddNewRealEstateMainInformationScreen extends StatelessWidget {
  const AddNewRealEstateMainInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddNewRealEstateCubit addNewRealEstateCubit =
    context.read<AddNewRealEstateCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NumberedTextHeaderComponent(
            number: '1',
            text: tr(LocaleKeys.mainInformation),
          ),
          SizedBox(height: context.scale(20)),
          FormWidgetComponent(
            label: LocaleKeys.operationType.tr(),
            content: BlocBuilder<AddNewRealEstateCubit, AddNewRealEstateState>(
              buildWhen: (previous, current) =>
              previous.currentPropertyOperationType !=
                  current.currentPropertyOperationType,
              builder: (context, state) {
                return TypeSelectorComponent<PropertyOperationType>(
                  selectorWidth: 171,
                  values: PropertyOperationType.values,
                  currentType: state.currentPropertyOperationType,
                  onTap: (type) =>
                      addNewRealEstateCubit.changePropertyOperationType(type),
                  getIcon: (type) {
                    switch (type) {
                      case PropertyOperationType.forSale:
                        return AppAssets.forSellIcon;
                      case PropertyOperationType.forRent:
                        return AppAssets.rentIcon;

                    }
                  } ,
                  getLabel: (type) => type.isForSale ? LocaleKeys.forSale.tr() : LocaleKeys.forRent.tr(),
                );
              },
            ),
          ),
          FormWidgetComponent(
            label: LocaleKeys.category.tr(),
            content: BlocBuilder<AddNewRealEstateCubit, AddNewRealEstateState>(
              buildWhen: (previous, current) =>
              previous.currentPropertyType != current.currentPropertyType,
              builder: (context, state) {
                return TypeSelectorComponent<PropertyType>(
                  selectorWidth: 82,
                  values: PropertyType.values,
                  currentType: state.currentPropertyType,
                  onTap: (type) {
                      addNewRealEstateCubit.changePropertyType(type);
                  },
                  getIcon: (type) {
                    switch (type) {
                      case PropertyType.apartment:
                        return AppAssets.apartmentIcon;
                      case PropertyType.villa:
                        return AppAssets.villaIcon;
                      case PropertyType.building:
                        return AppAssets.residentialBuildingIcon;
                      case PropertyType.land:
                        return AppAssets.landIcon;

                    }
                  },
                  getLabel: (type) {
                    switch (type) {
                      case PropertyType.apartment:
                        return LocaleKeys.apartment.tr();;
                      case PropertyType.villa:
                        return LocaleKeys.villa.tr();
                      case PropertyType.building:
                        return LocaleKeys.building.tr();
                      case PropertyType.land:
                        return LocaleKeys.land.tr();

                    }
                  },
                );
              },
            ),
          ),

          /// sub type of property
          BlocBuilder<AddNewRealEstateCubit, AddNewRealEstateState>(
            buildWhen: (previous, current) =>
            previous.currentPropertyType != current.currentPropertyType,
            builder: (context, state) {
              var currentPropertyType = state.currentPropertyType;
              late Widget formWidget;

              switch (currentPropertyType) {
                case PropertyType.apartment:
                  formWidget = FormWidgetComponent(
                    label: LocaleKeys.propertyType.tr(),
                    content: ApartmentSubTypesComponent(),
                  );
                  break;
                case PropertyType.villa:
                  formWidget = FormWidgetComponent(
                    label: LocaleKeys.type.tr(),
                    content: VillaSubTypesComponent(),
                  );
                  break;
                case PropertyType.building:
                  formWidget = FormWidgetComponent(
                    label: LocaleKeys.type.tr(),
                    content: BuildingSubTypesComponent(),
                  );
                  break;
                case PropertyType.land:
                  formWidget = FormWidgetComponent(
                    label: LocaleKeys.type.tr(),
                    content: LandSubTypesComponent(),
                  );
                  break;
              }

              return formWidget;
            },
          ),

          /// fields for every type
          BlocBuilder<AddNewRealEstateCubit, AddNewRealEstateState>(
            buildWhen: (previous, current) =>
            previous.currentPropertyType != current.currentPropertyType,
            builder: (context, state) {
              var currentPropertyType = state.currentPropertyType;
              late PropertyFields propertyFields;

              switch (currentPropertyType) {
                case PropertyType.apartment:
                  propertyFields = ApartmentTextFields();
                  break;
                case PropertyType.villa:
                  propertyFields = VillaTextFields();
                  break;
                case PropertyType.land:
                  propertyFields = LandTextFields();
                  break;
                case PropertyType.building:
                  propertyFields = BuildingTextFields();
                  break;
              }

              return Form(
                key: addNewRealEstateCubit.formKey,

                child: ZoomIn(
                  duration: Duration(milliseconds: 500),
                  key: ValueKey(currentPropertyType),
                  child: Column(
                    children: [
                      ...propertyFields.getFields(
                          context, addNewRealEstateCubit.formController),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}