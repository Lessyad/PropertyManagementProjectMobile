import 'package:easy_localization/easy_localization.dart';

import '../translation/locale_keys.dart';
import '../utils/enums.dart';

extension StatusExtension on RequestStatus {
  bool get isActive => this == RequestStatus.active;
  bool get isCompleted => this == RequestStatus.completed;
  bool get isCancelled => this == RequestStatus.cancelled;

  String get toName {
    switch (this) {
      case RequestStatus.completed:
        return LocaleKeys.completed.tr();
      case RequestStatus.cancelled:
        return LocaleKeys.cancelled.tr();
      case RequestStatus.active:
        return LocaleKeys.active.tr();
    }
  }

  String   toJson( ) {
    switch (this) {
      case RequestStatus.completed:
        return 'completed';
      case RequestStatus.cancelled:
        return 'cancelled';
      case RequestStatus.active:
        return 'pending';
    }
}
}
