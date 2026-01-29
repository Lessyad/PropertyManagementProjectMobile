import 'package:dartz/dartz.dart';
import '../../../../../../core/errors/failure.dart';
import '../entities/appointment_entity.dart';


abstract class BaseUserAppointmentsRepository {
  Future<Either<Failure, List<AppointmentEntity>>> getUserAppointments({
    Map<String, dynamic>? filters,
  });
  Future<Either<Failure, String>> cancelAppointment(
    String appointmentId,
  );
  Future<Either<Failure, void>> updateAppointment(
    Map<String , dynamic> data,
  );
}