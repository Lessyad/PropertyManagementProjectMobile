import '../home_module/home_imports.dart';
import 'app_services.dart';

class MainServicesScreen extends StatelessWidget {
  final String serviceName;

  const MainServicesScreen({super.key, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return getCategoryScreen(context, serviceName);
  }

  Widget getCategoryScreen(BuildContext context, String categoryText) {
    final screenBuilder = appServiceScreens[categoryText];
    return screenBuilder!(context);

  }
}