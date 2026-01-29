import 'package:easy_localization/easy_localization.dart';
import '../translation/locale_keys.dart';
import '../utils/enums.dart';

extension AppointmentStatusExtension on AppointmentStatus {
  bool get isCompleted => this == AppointmentStatus.completed;
  bool get isCancelled => this == AppointmentStatus.cancelled;
  bool get isComing => this == AppointmentStatus.coming;

  String get toName {
    switch (this) {
      case AppointmentStatus.completed:
        return LocaleKeys.completed.tr();
      case AppointmentStatus.cancelled:
        return LocaleKeys.cancelled.tr();
      case AppointmentStatus.coming:
        return LocaleKeys.coming.tr();
    }
  }

  String toJson() {
    switch (this) {
      case AppointmentStatus.completed:
        return 'completed';
      case AppointmentStatus.cancelled:
        return 'cancelled';
      case AppointmentStatus.coming:
        return 'pending';
    }
  }

  static AppointmentStatus fromJson(String status) {
    switch (status) {
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'pending':
        return AppointmentStatus.coming;
      default:
        throw ArgumentError('Invalid status: $status');
    }
  }
}
