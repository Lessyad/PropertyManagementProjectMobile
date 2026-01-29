import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/services/service_locator.dart';
import 'package:enmaa/features/add_new_real_estate/add_new_real_estate_DI.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/controller/add_new_real_estate_cubit.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/screens/add_new_real_estate_main_information_screen.dart';
import 'package:enmaa/features/book_property/book_property_DI.dart';
import 'package:enmaa/features/book_property/presentation/controller/book_property_cubit.dart';
import 'package:enmaa/features/book_property/presentation/screens/sale_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:enmaa/core/components/app_bar_component.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../core/components/loading_overlay_component.dart';
import '../components/book_property_buttons.dart';
import 'buyer_data_screen.dart';
import 'complete_the_purchase_screen.dart';

class BookPropertyMainScreen extends StatefulWidget {
  const BookPropertyMainScreen({
    super.key, 
    required this.propertyId,
    this.operation, // 🆕 Paramètre optionnel
    this.monthlyRentPeriod, // 🆕 Paramètre optionnel
  });

  final String propertyId;
  final String? operation; // 🆕 "for_rent" ou "for_sale"
  final String? monthlyRentPeriod; // 🆕 nombre de mois

  @override
  _BookPropertyMainScreenState createState() => _BookPropertyMainScreenState();
}

class _BookPropertyMainScreenState extends State<BookPropertyMainScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        BookPropertyDi().setup();
        return BookPropertyCubit(
          ServiceLocator.getIt(),
          ServiceLocator.getIt(),
          operation: widget.operation, // 🆕 Passer au cubit
          monthlyRentPeriod: widget.monthlyRentPeriod, // 🆕 Passer au cubit
        )..getPropertySaleDetails(widget.propertyId);
      },
      child: Scaffold(
        backgroundColor: ColorManager.greyShade,
        body: BlocBuilder<BookPropertyCubit, BookPropertyState>(
          buildWhen: (previous, current) =>
          previous.bookPropertyState != current.bookPropertyState,
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    AppBarComponent(
                      appBarTextMessage: LocaleKeys.bookProperty.tr(),
                      showNotificationIcon: false,
                      showLocationIcon: false,
                      showBackIcon: true,
                      centerText: true,
                    ),
                    _buildPageIndicator(),
                    Expanded(
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        children: [
                          SaleDetailsScreen(),
                          BuyerDataScreen(),
                          CompleteThePurchaseScreen()
                        ],
                      ),
                    ),
                    BookPropertyButtons(
                      pageController: _pageController,
                      currentPage: _currentPage,
                      propertyID: widget.propertyId,
                      animationTime: const Duration(milliseconds: 500),
                    ),
                  ],
                ),
                if (state.bookPropertyState.isLoading)
                  LoadingOverlayComponent(
                    opacity: 0,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  var animationTime = const Duration(milliseconds: 500);

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          bool isActive = index <= _currentPage;
          return Column(
              children: [
          Text(
          index == 0
          ? LocaleKeys.saleDetails.tr()
              : index == 1
          ? LocaleKeys.buyerData.tr()
              : LocaleKeys.completePayment.tr(),
          style: getBoldStyle(
          color: isActive
          ? ColorManager.primaryColor
              : ColorManager.blackColor,
          fontSize: FontSize.s11,
          ),
          ),
          SizedBox(height: context.scale(8)),
          AnimatedContainer(
          duration: animationTime,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: context.scale(115.33),
          height: context.scale(4),
          decoration: BoxDecoration(
          color:
          isActive ? ColorManager.primaryColor : Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(2.0),
          ),
          ),
          ],
          );
        }),
      ),
    );
  }
}