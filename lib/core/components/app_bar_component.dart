import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/circular_icon_button.dart';
import 'package:enmaa/core/components/custom_bottom_sheet.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../configuration/managers/color_manager.dart';
import '../../configuration/routers/route_names.dart';
import '../../features/home_module/home_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import '../../features/home_module/presentation/controller/home_bloc.dart';
import '../screens/select_location_screen.dart';
import '../translation/locale_keys.dart';
import '../utils/enums.dart';
import 'need_to_login_component.dart';
import '../services/dio_service.dart';
import '../services/service_locator.dart';
import '../services/shared_preferences_service.dart';
import '../constants/api_constants.dart';

class AppBarComponent extends StatefulWidget {
  const AppBarComponent({
    super.key,
    required this.appBarTextMessage,
    this.showNotificationIcon = true,
    this.showLocationIcon = true,
    this.showBackIcon = false,
    this.centerText = false,
    this.homeBloc,
  });

  final String appBarTextMessage;
  final bool showNotificationIcon;
  final bool showLocationIcon;
  final bool showBackIcon;
  final bool centerText;
  final HomeBloc? homeBloc;

  @override
  State<AppBarComponent> createState() => _AppBarComponentState();
}

class _AppBarComponentState extends State<AppBarComponent> {
  String? userName;
  int unreadNotificationsCount = 0;

  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    _initPreferences();
    _fetchUnreadNotificationsCount();
  }

  Future<void> _initPreferences() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString('full_name');
    });
  }

  Future<void> _fetchUnreadNotificationsCount() async {
    // Vérifier si l'utilisateur est authentifié
    final accessToken = SharedPreferencesService().accessToken;
    if (accessToken.isEmpty) {
      print('❌ Utilisateur non authentifié - pas de récupération du count');
      return;
    }

    try {
      print('🔔 Début de récupération du count de notifications non lues...');
      final dioService = ServiceLocator.getIt<DioService>();
      final response = await dioService.get(
        url: '${ApiConstants.notifications}unread-count',
      );

      print('🔔 Réponse API: ${response.statusCode}');
      print('🔔 Data reçue: ${response.data}');

      if (response.statusCode == 200 && mounted) {
        final count = response.data['unreadCount'] ?? 0;
        print('✅ Count de notifications non lues: $count');
        setState(() {
          unreadNotificationsCount = count;
        });
      }
    } catch (e) {
      print(
          '❌ Erreur lors de la récupération du nombre de notifications non lues: $e');
    }
  }

  void _updateNotificationsCount() {
    // Rafraîchir le count après avoir visité l'écran des notifications
    _fetchUnreadNotificationsCount();
  }

  @override
  Widget build(BuildContext context) {
    // Force rebuild when locale changes so appBarTextMessage updates immediately
    context.locale;
    return Container(
      width: double.infinity,
      height: context.scale(110),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        boxShadow: [
          BoxShadow(
            color: ColorManager.blackColor.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(context.scale(16)),
          bottomRight: Radius.circular(context.scale(16)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: context.scale(20)),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.showBackIcon && widget.centerText)
            Padding(
              padding: EdgeInsets.all(context.scale(16)),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CircularIconButton(
                  containerSize: context.scale(32),
                  iconPath: AppAssets.backIcon,
                  backgroundColor: ColorManager.greyShade,
                  iconColor: ColorManager.navyColor,
                ),
              ),
            )
          else if (widget.centerText)
            SizedBox(width: context.scale(64)),
          if (widget.centerText)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!widget.showBackIcon) const SizedBox(width: 32),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: context.scale(16)),
                    child: Text(
                      widget.appBarTextMessage,
                      style: getBoldStyle(color: ColorManager.navyColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          else if (userName != null)
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.scale(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${LocaleKeys.hello.tr()} ${userName}،', // "أهلا"
                      style: getBoldStyle(color: ColorManager.navyColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          if (userName == null)
            Visibility(
              visible: !widget.centerText,
              child: Expanded(
                child: Padding(
                  padding: EdgeInsets.all(context.scale(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        LocaleKeys.welcome.tr(), // "مرحباً بك،"
                        style: getBoldStyle(color: ColorManager.navyColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushReplacementNamed(
                                  RoutersNames.authenticationFlow);
                        },
                        child: Text(
                          LocaleKeys.createAccountForFeatures
                              .tr(), // "أنشئ حساباً لتحصل علي المميزات"
                          style: getUnderlineRegularStyle(
                              color: ColorManager.navyColor,
                              fontSize: FontSize.s14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (widget.showLocationIcon)
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: context.scale(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (isAuth) {
                        _showLocationPickerBottomSheet(
                            context, widget.homeBloc!);
                      } else {
                        LoginBottomSheet.show();
                      }
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final String location = state.selectedCityName.isEmpty
                            ? LocaleKeys.location.tr() // "الموقع"
                            : state.selectedCityName;
                        final textPainter = TextPainter(
                          text: TextSpan(
                            text: location,
                            style: getRegularStyle(
                              color: ColorManager.primaryColor,
                              fontSize: FontSize.s10,
                            ),
                          ),
                          maxLines: 1,
                          textDirection: material.TextDirection.rtl,
                        )..layout();

                        final textWidth = textPainter.width;
                        final containerWidth = textWidth.clamp(
                            context.scale(80), context.scale(120));

                        return Container(
                          height: context.scale(32),
                          width: containerWidth.toDouble(),
                          decoration: BoxDecoration(
                            color: ColorManager.greyShade,
                            borderRadius:
                                BorderRadius.circular(context.scale(16)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    location,
                                    overflow: TextOverflow.ellipsis,
                                    style: getRegularStyle(
                                      color: ColorManager.navyColor,
                                      fontSize: FontSize.s10,
                                    ),
                                  ),
                                ),
                                SizedBox(width: context.scale(8)),
                                SvgPicture.asset(
                                  AppAssets.locationIcon,
                                  width: context.scale(16),
                                  height: context.scale(16),
                                  colorFilter: ColorFilter.mode(
                                      ColorManager.navyColor, BlendMode.srcIn),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          if (widget.showNotificationIcon)
            BlocListener<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state.getNotificationsState == RequestState.loaded) {
                  _fetchUnreadNotificationsCount();
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
                child: InkWell(
                  onTap: () {
                    if (isAuth) {
                      final accessToken =
                          SharedPreferencesService().accessToken;
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(RoutersNames.notificationsScreen,
                              arguments: unreadNotificationsCount)
                          .then((_) {
                        _updateNotificationsCount();
                      });
                    } else {
                      // Afficher LoginBottomSheet pour se connecter
                      LoginBottomSheet.show();
                    }
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircularIconButton(
                        containerSize: context.scale(32),
                        iconPath: AppAssets.notificationIcon,
                        backgroundColor: ColorManager.greyShade,
                        iconColor: ColorManager.navyColor,
                      ),
                      if (unreadNotificationsCount > 0)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.scale(5),
                              vertical: context.scale(2),
                            ),
                            constraints: BoxConstraints(
                              minWidth: context.scale(20),
                              minHeight: context.scale(20),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.circular(context.scale(12)),
                              border: Border.all(
                                color: ColorManager.whiteColor,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                unreadNotificationsCount > 99
                                    ? '99+'
                                    : unreadNotificationsCount.toString(),
                                style: TextStyle(
                                  color: ColorManager.whiteColor,
                                  fontSize: context.scale(10),
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            )
          else if (widget.centerText)
            SizedBox(width: context.scale(64)),
        ],
      ),
      ),
    );
  }
}

void _showLocationPickerBottomSheet(BuildContext context, HomeBloc homeBloc) {
  final rootContext = Navigator.of(context, rootNavigator: true).context;

  showModalBottomSheet(
    context: rootContext,
    backgroundColor: ColorManager.greyShade,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (context) {
      return BlocProvider.value(
        value: homeBloc,
        child: CustomBottomSheet(
          widget: SelectLocationScreen(),
          headerText: LocaleKeys.selectLocation.tr(),
        ),
      );
    },
  );
}
