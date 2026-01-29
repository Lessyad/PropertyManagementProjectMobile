import 'package:enmaa/core/screens/property_empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/core/components/app_bar_component.dart';
import 'package:enmaa/core/components/card_listing_shimmer.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/features/home_module/presentation/components/real_state_card_component.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../home_module/presentation/controller/home_bloc.dart';
import '../../../real_estates/domain/entities/base_property_entity.dart';

class SeeAllScreen extends StatefulWidget {
  const SeeAllScreen({
    super.key,
    required this.appBarTextMessage,
    required this.propertyType,
  });

  final String appBarTextMessage;
  final PropertyType propertyType;

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentOffset = 0;
  final int _limit = 15;
  bool _isLoading = false;
  bool _hasReachedMax = false;
  List<PropertyEntity> _properties = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProperties();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          !_hasReachedMax) {
        _loadMoreProperties();
      }
    });
  }

  void _loadProperties() {
    setState(() {
      _isLoading = true;
      _currentOffset = 0;
      _hasReachedMax = false;
      _properties = [];
    });

    ///todo : change location to be dynamic
    context.read<HomeBloc>().add(
      FetchAllPropertiesByType(
        propertyType: widget.propertyType,
        location: '15',
        limit: _limit,
        offset: _currentOffset,
      ),
    );
  }

  void _loadMoreProperties() {
    if (_isLoading || _hasReachedMax) return;

    setState(() {
      _isLoading = true;
      _currentOffset += _limit;
    });

    ///todo : change location to be dynamic

    context.read<HomeBloc>().add(
      FetchAllPropertiesByType(
        propertyType: widget.propertyType,
        location: '15',
        limit: _limit,  
        offset: _currentOffset,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: Column(
        children: [
          AppBarComponent(
            appBarTextMessage: widget.appBarTextMessage,
            centerText: true,
            showLocationIcon: false,
            showBackIcon: true,
            showNotificationIcon: false,
            homeBloc: context.read<HomeBloc>(),
          ),
          Expanded(
            child: BlocListener<HomeBloc, HomeState>(
              listenWhen: (previous, current) {
                return previous.allPropertiesState != current.allPropertiesState ||
                    previous.allProperties != current.allProperties;
              },
              listener: (context, state) {
                if (state.allPropertiesState == RequestState.loaded) {
                  setState(() {
                    _isLoading = false;

                    if (_currentOffset == 0) {
                      _properties = state.allProperties;
                    } else {
                      _properties = [..._properties, ...state.allProperties];
                    }

                    _hasReachedMax = state.allProperties.length < _limit;
                  });
                } else if (state.allPropertiesState == RequestState.error) {
                  setState(() {
                    _isLoading = false;
                  });

                  CustomSnackBar.show(
                    context: context,
                    message: state.errorMessage,
                    type: SnackBarType.error,
                  );
                }
              },
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _properties.isEmpty) {
      return CardShimmerList(
        scrollDirection: Axis.vertical,
        cardHeight: context.scale(282),
        cardWidth: context.screenWidth,
        numberOfCards: 5,
      );
    } else if (_properties.isEmpty) {
      return EmptyScreen(
        alertText1: 'لم تجد العقار المناسب؟ ',
        alertText2: 'تواصل مع مكتب إنماء للحصول على أفضل الخيارات. سنساعدك في العثور على العقار المناسب لك!',
        buttonText: 'تواصل معنا',
        onTap: () async {
          final Uri url = Uri.parse('https://github.com/AmrAbdElHamed26');

          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            CustomSnackBar.show(
              message: 'حدث خطأ أثناء فتح الرابط',
              type: SnackBarType.error,
            );
          }
        },
      );

    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadProperties();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(context.scale(8)),
        itemCount: _properties.length + (_hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == _properties.length) {
            return CardListingShimmer(
              width: context.screenWidth,
              height: context.scale(282),
            );
          }

          final property = _properties[index];
          return Padding(
            padding: EdgeInsets.only(bottom: context.scale(8)),
            child: RealStateCardComponent(
              width: context.screenWidth,
              height: context.scale(290),
              currentProperty: property,
            ),
          );
        },
      ),
    );
  }
}