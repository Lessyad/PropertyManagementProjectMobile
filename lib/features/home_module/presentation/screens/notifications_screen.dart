import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/services/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import '../../../../core/components/app_bar_component.dart';
import '../../../../core/screens/error_app_screen.dart';
import '../../../../core/screens/property_empty_screen.dart';
import '../../../wish_list/favorite_imports.dart';
import '../../domain/entities/notification_entity.dart';
import '../components/notification_component.dart';
import '../controller/home_bloc.dart';
import '../../../../core/services/dio_service.dart';
import '../../../../core/constants/api_constants.dart';
import '../../data/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, required this.numberOfNotifications});
  final int numberOfNotifications;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationEntity> notifications = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final dioService = ServiceLocator.getIt<DioService>();
      final response = await dioService.get(url: ApiConstants.notifications);
      
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = response.data['results'] ?? [];
        List<NotificationModel> loadedNotifications = jsonResponse.map((notification) {
          return NotificationModel.fromJson(notification);
        }).toList();

        setState(() {
          notifications = loadedNotifications;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = LocaleKeys.notificationErrorLoading.tr();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
          errorMessage = '${LocaleKeys.notificationErrorLoading.tr()}: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _markNotificationAsRead(String notificationId) async {
    print('🔔 Tentative de marquage de la notification $notificationId comme lue');
    
    // Trouver l'index de la notification
    final index = notifications.indexWhere((n) => n.id == notificationId);
    
    if (index == -1) {
      print('❌ Notification non trouvée');
      return;
    }
    
    final notification = notifications[index];
    
    // Ne pas marquer si déjà lue
    if (notification.isRead) {
      print('⏭️ Notification déjà lue, skip');
      return;
    }
    
    try {
      final dioService = ServiceLocator.getIt<DioService>();
      final url = '${ApiConstants.notifications}$notificationId/mark-as-read';
      
      print('📡 Appel API: POST $url');
      final response = await dioService.post(url: url);
      print('✅ Réponse API: ${response.statusCode}');
      
      // Mettre à jour localement l'état de la notification
      setState(() {
        notifications[index] = NotificationModel(
          id: notification.id,
          title: notification.title,
          message: notification.message,
          isRead: true,
          createdAt: notification.createdAt,
        );
        print('🔄 Notification mise à jour localement');
      });

      // Mettre à jour le compteur de notifications dans le HomeBloc
      final homeBloc = ServiceLocator.getIt<HomeBloc>();
      homeBloc.add(GetNotifications());
      print('🔄 HomeBloc mis à jour');
    } catch (e) {
      print('❌ Erreur lors du marquage de la notification comme lue: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: Column(
        children: [
          AppBarComponent(
            appBarTextMessage: LocaleKeys.notificationsScreenTitle.tr(),
            homeBloc: ServiceLocator.getIt<HomeBloc>(),
            showNotificationIcon: false,
            showLocationIcon: false,
            centerText: true,
            showBackIcon: true,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadNotifications,
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return ErrorAppScreen(
        showActionButton: false,
        showBackButton: false,
        backgroundColor: Colors.grey.shade100,
      );
    }

    if (notifications.isEmpty) {
      return _buildEmptyNotifications();
    }

    return _buildNotificationsList(notifications);
  }

  Widget _buildEmptyNotifications() {
    return EmptyScreen(
      alertText1: LocaleKeys.notificationsScreenNoNotifications.tr(),
      alertText2: LocaleKeys.notificationsScreenExploreOffers.tr(),
    );
  }

  Widget _buildNotificationsList(List<NotificationEntity> notifications) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final notification = notifications[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: GestureDetector(
            onTap: () {
              print('🔔 Clic détecté sur notification: ${notification.id}');
              _markNotificationAsRead(notification.id);
            },
            behavior: HitTestBehavior.opaque,
            child: NotificationComponent(
              notification: notification,
              isRead: notification.isRead,
              onTap: null, // Géré directement ici
            ),
          ),
        );
      },
    );
  }
}