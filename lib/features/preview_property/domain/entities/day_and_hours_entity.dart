import 'package:equatable/equatable.dart';

class DayAndHoursEntity extends Equatable {

  final String currentDay, startHour , endHour;
  final List<String> hours;

   const DayAndHoursEntity({
    required this.currentDay,
    required this.hours,
    required this.startHour,
    required this.endHour,

  });

  @override
  List<Object?> get props => [currentDay, hours , startHour , endHour];
}