import 'package:dartz/dartz.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/domain/entities/appointment_entity.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/domain/repository/base_user_appointments_repository.dart';
import '../../../../../../core/errors/failure.dart';

class CancelAppointmentUseCase {
  final BaseUserAppointmentsRepository _baseUserAppointmentsRepository;

  CancelAppointmentUseCase(this._baseUserAppointmentsRepository);

  Future<Either<Failure, String>> call(
   String appointmentId,
  ) async {
    return await _baseUserAppointmentsRepository.cancelAppointment(appointmentId);
  }
}