import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/features/wallet/presentation/controller/wallet_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/app_bar_component.dart';
import '../../../../core/components/shimmer_component.dart';
import '../../../home_module/home_imports.dart';
import '../../domain/entities/wallet_data_entity.dart';


class WalletDataContainer extends StatelessWidget {
  const WalletDataContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: context.scale(186),
      decoration: BoxDecoration(
        color: ColorManager.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            if(state.getWalletDataState.isLoaded){
              final WalletDataEntity walletData = state.walletDataEntity! ;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text(
                    'رصيدك الحالي',
                    style: getBoldStyle(color: ColorManager.whiteColor , fontSize: FontSize.s16),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        walletData.totalBalance,
                        style: getBoldStyle(color: ColorManager.whiteColor , fontSize: FontSize.s32),),
                      SizedBox(
                        width: context.scale(8),
                      ),
                      Text(
                        'جنية ',
                        style: getBoldStyle(color: ColorManager.whiteColor , fontSize: FontSize.s20),),
                    ],
                  ),
                  SizedBox(
                    height: context.scale(20),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'الرصيد الجاري',
                                style: getSemiBoldStyle(color: ColorManager.whiteColor , fontSize: FontSize.s12),),
                              SizedBox(
                                width: context.scale(8),
                              ),
                              Text(
                                '${walletData.currentBalance} جنية  ',
                                style: getBoldStyle(color: ColorManager.whiteColor , fontSize: FontSize.s12),),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'الرصيد المعلق',
                                style: getSemiBoldStyle(color: ColorManager.whiteColor , fontSize: FontSize.s12),),
                              SizedBox(
                                width: context.scale(8),
                              ),
                              Text(
                                '${walletData.pendingBalance} جنية ',
                                style: getBoldStyle(color: ColorManager.whiteColor , fontSize: FontSize.s12),),
                            ],
                          ),


                        ],
                      ),
                      InkWell(
                        onTap: (){
                          print('charge wallet');
                          Navigator.of(context, rootNavigator: true).pushNamed(RoutersNames.chargeWalletScreen, arguments: context.read<WalletCubit>());
                        },
                        child: Container(
                          width: context.scale(136),
                          height: context.scale(42),
                          decoration: BoxDecoration(
                            color: ColorManager.whiteColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgImageComponent(iconPath: AppAssets.chargeWallerIcon),
                              SizedBox(
                                width: context.scale(8),
                              ),
                              Text('شحن المحفظة' ,
                                style: getBoldStyle(color: ColorManager.primaryColor , fontSize: FontSize.s14),)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),

                ],
              );
            }
            else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text(
                    'رصيدك الحالي',
                    style: getBoldStyle(color: ColorManager.whiteColor , fontSize: FontSize.s16),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ShimmerComponent(height: context.scale(13), width: context.scale(100)),
                      SizedBox(
                        width: context.scale(8),
                      ),
                      Text(
                        'جنية ',
                        style: getBoldStyle(color: ColorManager.whiteColor , fontSize: FontSize.s20),),
                    ],
                  ),
                  SizedBox(
                    height: context.scale(20),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'الرصيد الجاري',
                                style: getSemiBoldStyle(color: ColorManager.whiteColor , fontSize: FontSize.s12),),
                              SizedBox(
                                width: context.scale(8),
                              ),
                              ShimmerComponent(height: context.scale(13), width: context.scale(70)),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'الرصيد المعلق',
                                style: getSemiBoldStyle(color: ColorManager.whiteColor , fontSize: FontSize.s12),),
                              SizedBox(
                                width: context.scale(8),
                              ),
                              ShimmerComponent(height: context.scale(13), width: context.scale(70)),
                            ],
                          ),


                        ],
                      ),
                      Container(
                        width: context.scale(136),
                        height: context.scale(42),
                        decoration: BoxDecoration(
                          color: ColorManager.whiteColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgImageComponent(iconPath: AppAssets.chargeWallerIcon),
                            SizedBox(
                              width: context.scale(8),
                            ),
                            Text('شحن المحفظة' ,
                              style: getBoldStyle(color: ColorManager.primaryColor , fontSize: FontSize.s14),)
                          ],
                        ),
                      )
                    ],
                  ),

                ],
              );
            }
          },
        ),
      ),
    ) ;
  }
}
