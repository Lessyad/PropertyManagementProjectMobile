import 'package:enmaa/core/entites/amenity_entity.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/controller/add_new_real_estate_cubit.dart';
import 'package:flutter/material.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../core/components/button_app_component.dart';
import '../../../../core/components/selected_item_text_style.dart';

class SelectAmenities extends StatefulWidget {
  const SelectAmenities({super.key});

  @override
  _SelectAmenitiesState createState() => _SelectAmenitiesState();
}

class _SelectAmenitiesState extends State<SelectAmenities> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<AddNewRealEstateCubit, AddNewRealEstateState>(
          buildWhen: (previous, current) =>
          previous.getAmenitiesState != current.getAmenitiesState ||
              previous.selectedAmenities != current.selectedAmenities,
          builder: (context, state) {
            if(state.getAmenitiesState.isLoaded){
              List<AmenityEntity> amenities = state.currentAmenities;
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 4,
                ),
                itemCount: amenities.length,
                itemBuilder: (context, index) {
                  final isSelected = state.selectedAmenities
                      .contains(amenities[index].id.toString());
                  return ButtonAppComponent(
                    width: 173,
                    height: 40,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: ColorManager.whiteColor,
                      borderRadius: BorderRadius.circular(context.scale(20)),
                      border: Border.all(
                        color: isSelected
                            ? ColorManager.primaryColor
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    buttonContent: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.scale(12),
                          vertical: context.scale(8)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: context.scale(16),
                            height: context.scale(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? ColorManager.primaryColor
                                  : ColorManager.grey3,
                            ),
                            child: isSelected
                                ? Icon(Icons.check,
                                color: ColorManager.whiteColor,
                                size: context.scale(15))
                                : null,
                          ),
                          SizedBox(width: context.scale(8)),
                          Text(amenities[index].name,
                              style: currentTextStyle(isSelected)),
                        ],
                      ),
                    ),
                    onTap: () {
                      if (!isSelected) {
                        context
                            .read<AddNewRealEstateCubit>()
                            .selectAmenity(amenities[index].id.toString());
                      } else {
                        context
                            .read<AddNewRealEstateCubit>()
                            .unSelectAmenity(amenities[index].id.toString());
                      }
                    },
                  );
                },
              );
            }
            else if(state.getAmenitiesState.isError) {
              return Row(children:[ const Center(child: Text('errrror ')),
              InkWell(
                onTap: () {
                },
                child: const Icon(Icons.refresh),
              )
              ]);
            }
            else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }
}
