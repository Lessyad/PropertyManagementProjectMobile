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
  final int _limit = 15;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isChangingPage = false;
  List<PropertyEntity> _properties = [];
  int _totalCount = 0;
  bool _paginationVisible = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPage(1);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final atBottom = _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 60;
    if (atBottom && !_paginationVisible && _properties.isNotEmpty) {
      setState(() => _paginationVisible = true);
    }
  }

  void _loadPage(int page) {
    setState(() {
      _isLoading = true;
      _currentPage = page;
      _properties = [];
    });

    context.read<HomeBloc>().add(
      FetchAllPropertiesByType(
        propertyType: widget.propertyType,
        location: '15',
        limit: _limit,
        offset: (page - 1) * _limit,
      ),
    );
  }

  void _goToPage(int page) {
    setState(() {
      _paginationVisible = false;
      _isChangingPage = true;
      _properties = [];
    });
    _loadPage(page);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  int get _totalPages => (_totalCount / _limit).ceil();

  List<int?> _getVisiblePages() {
    final total = _totalPages;
    final current = _currentPage;
    if (total <= 0) return [current];
    if (total <= 7) return List.generate(total, (i) => i + 1);
    if (current <= 4) return [1, 2, 3, 4, 5, null, total];
    if (current >= total - 3) {
      return [1, null, total - 4, total - 3, total - 2, total - 1, total];
    }
    return [1, null, current - 1, current, current + 1, null, total];
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
              listenWhen: (previous, current) =>
                  previous.allPropertiesState != current.allPropertiesState ||
                  previous.allProperties != current.allProperties,
              listener: (context, state) {
                if (state.allPropertiesState == RequestState.loaded) {
                  setState(() {
                    _isLoading = false;
                    _isChangingPage = false;
                    _properties = state.allProperties;
                    _totalCount = state.allPropertiesTotalCount;
                  });
                } else if (state.allPropertiesState == RequestState.error) {
                  setState(() => _isLoading = false);
                  CustomSnackBar.show(
                    context: context,
                    message: state.errorMessage,
                    type: SnackBarType.error,
                  );
                }
              },
              child: Column(
                children: [
                  Expanded(child: _buildContent()),
                  // Pagination : visible après scroll jusqu'au dernier item
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                          parent: animation, curve: Curves.easeOut)),
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: _paginationVisible && _properties.isNotEmpty
                        ? _buildPaginationBar()
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isChangingPage || (_isLoading && _properties.isEmpty)) {
      return CardShimmerList(
        scrollDirection: Axis.vertical,
        cardHeight: context.scale(282),
        cardWidth: context.screenWidth,
        numberOfCards: 5,
      );
    }

    if (_properties.isEmpty) {
      return EmptyScreen(
        alertText1: 'لم تجد العقار المناسب؟ ',
        alertText2:
            'تواصل مع مكتب إنماء للحصول على أفضل الخيارات. سنساعدك في العثور على العقار المناسب لك!',
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
      onRefresh: () async => _goToPage(1),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(context.scale(8)),
        itemCount: _properties.length,
        itemBuilder: (context, index) {
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

  Widget _buildPaginationBar() {
    final hasPrev = _currentPage > 1;
    final hasNext = _currentPage < _totalPages;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_totalCount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '$_totalCount résultat${_totalCount > 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ColorManager.grey2,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavArrow(
                icon: Icons.chevron_left_rounded,
                enabled: hasPrev,
                onTap: () => _goToPage(_currentPage - 1),
              ),
              const SizedBox(width: 6),
              ..._getVisiblePages().map((page) {
                if (page == null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: SizedBox(
                      width: 28,
                      child: Text(
                        '···',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: ColorManager.grey2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }
                final isActive = page == _currentPage;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: isActive ? null : () => _goToPage(page),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isActive
                            ? ColorManager.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isActive
                              ? ColorManager.primaryColor
                              : ColorManager.grey3,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$page',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color:
                              isActive ? Colors.white : ColorManager.grey,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 6),
              _buildNavArrow(
                icon: Icons.chevron_right_rounded,
                enabled: hasNext,
                onTap: () => _goToPage(_currentPage + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavArrow({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled ? ColorManager.primaryColor : ColorManager.greyShade,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 22,
          color: enabled ? Colors.white : ColorManager.grey2,
        ),
      ),
    );
  }
}
