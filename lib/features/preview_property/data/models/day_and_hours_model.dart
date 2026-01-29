import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/features/preview_property/domain/entities/day_and_hours_entity.dart';

class DayAndHoursModel extends DayAndHoursEntity {
  const DayAndHoursModel({
    required super.currentDay,
    required super.hours,
    required super.startHour,
    required super.endHour,
  });

  factory DayAndHoursModel.fromJson(Map<String, dynamic> json) {
    final startHour = json['start_hour'] ?? '09:00';
    final endHour = json['end_hour'] ?? '19:00';

    final busyHours = (json['busy_hours'] as List<dynamic>).map((e) => e.toString()).toList();

    final availableHours = generateAvailableHours(startHour, endHour, busyHours);

    return DayAndHoursModel(
      currentDay: json['date'] as String,
      hours: availableHours,
      startHour: startHour,
      endHour: endHour,
    );
  }

  static List<String> generateAvailableHours(String startHour, String endHour, List<String> busyHours) {
    final availableHours = <String>[];
    final startTime = int.parse(startHour.split(':')[0]);
    final endTime = int.parse(endHour.split(':')[0]);

    final busyHourSet = busyHours.map((time) {
      return int.parse(time.split(':')[0]);
    }).toSet();

    for (int hour = startTime; hour < endTime; hour++) {
      if (!busyHourSet.contains(hour)) {
        availableHours.add("${hour.toString().padLeft(2, '0')}:00");
      }
    }

    return availableHours;
  }

  static List<DayAndHoursModel> generateAvailableHoursFor60Days(List<Map<String, dynamic>> busyDays) {
    final today = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd' , 'en');
    final availableDays = <DayAndHoursModel>[];

    for (int i = 0; i < 60; i++) {
      final currentDate = today.add(Duration(days: i));
      final formattedDate = dateFormat.format(currentDate);

      final busyDayData = busyDays.firstWhere(
              (day) => day['date'] == formattedDate,
          orElse: () => {
            'date': formattedDate,
            'start_hour': '09:00',
            'end_hour': '19:00',
            'busy_hours': []
          }
      );

      final model = DayAndHoursModel.fromJson(busyDayData);
      availableDays.add(model);
    }

    return availableDays;
  }
}
