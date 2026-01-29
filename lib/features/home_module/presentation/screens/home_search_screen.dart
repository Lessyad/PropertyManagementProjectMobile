import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/screens/error_app_screen.dart';
import 'package:enmaa/core/screens/property_empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/app_text_field.dart';
import '../../../../core/components/card_listing_shimmer.dart';
import '../../../../core/components/circular_icon_button.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../wish_list/favorite_imports.dart';
import '../components/real_state_card_component.dart';
import '../controller/home_bloc.dart';

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({super.key});

  @override
  _HomeSearchScreenState createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final initialQuery = context.read<HomeBloc>().state.searchQuery;
    _searchController.text = initialQuery;

    if(context.read<HomeBloc>().state.searchPropertiesState.isInitial) {
      context.read<HomeBloc>().add(SearchProperties(
            query: initialQuery,
          ));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      final query = value.trim();
      context.read<HomeBloc>().add(UpdateSearchQuery(query: query));
      if (query.isNotEmpty) {
        context.read<HomeBloc>().add(SearchProperties(
              query: query,
            ));
      } else {
        context.read<HomeBloc>().add(const SearchProperties(
              query: '',
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(context.scale(16)),
              bottomRight: Radius.circular(context.scale(16)),
            ),
            child: Container(
              height: context.scale(120),
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorManager.whiteColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scale(16),
                      vertical: context.scale(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularIconButton(
                          iconPath: AppAssets.backIcon,
                          containerSize: context.scale(40),
                          iconSize: context.scale(20),
                          backgroundColor: ColorManager.greyShade,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: context.scale(16)),
                        BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state) {
                            final showClearIcon =
                                _searchController.text.isNotEmpty;
                            return Expanded(
                              child: AppTextField(
                                padding: EdgeInsets.zero,
                                width: double.infinity,
                                backgroundColor: ColorManager.greyShade,
                                hintText: LocaleKeys.searchForProperty.tr(),
                                prefixIcon: Icon(Icons.search,
                                    color: ColorManager.blackColor),
                                suffixIcon: showClearIcon
                                    ? IconButton(
                                        icon: Icon(Icons.clear,
                                            color: ColorManager.blackColor),
                                        onPressed: () {
                                          _searchController.clear();
                                          context.read<HomeBloc>().add(
                                              UpdateSearchQuery(query: ''));
                                          context
                                              .read<HomeBloc>()
                                              .add(const SearchProperties(
                                                query: '',
                                              ));
                                        },
                                      )
                                    : null,
                                focusNode: _searchFocusNode,
                                controller: _searchController,
                                onChanged:
                                    _onSearchTextChanged, // Use onChanged
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state.searchPropertiesState.isLoading ||
                    state.searchPropertiesState.isInitial) {
                  return CardShimmerList(
                    scrollDirection: Axis.vertical,
                    cardHeight: context.scale(282),
                    cardWidth: context.screenWidth,
                    numberOfCards: 5,
                  );
                } else if (state.searchPropertiesState.isError) {
                  return ErrorAppScreen(
                    showBackButton: false,
                  );
                } else {
                  if (state.searchProperties.isEmpty) {
                    return EmptyScreen(
                      alertText1: 'لم يتم العثور على نتائج مطابقة',
                      alertText2:
                          'يرجى تعديل كلمات البحث للحصول على نتائج أدق.',
                      buttonText: 'العودة إلى الصفحة الرئيسية',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(context.scale(16)),
                    itemCount: state.searchProperties.length,
                    itemBuilder: (context, index) {
                      final property = state.searchProperties[index];
                      return RealStateCardComponent(
                        width: MediaQuery.of(context).size.width,
                        height: context.scale(290),
                        currentProperty: property,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
