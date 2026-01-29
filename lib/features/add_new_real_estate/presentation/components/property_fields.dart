import '../../../../core/components/property_form_controller.dart';
import '../../../home_module/home_imports.dart';

abstract class PropertyFields {
  List<Widget> getFields(BuildContext context, PropertyFormController controller);
}