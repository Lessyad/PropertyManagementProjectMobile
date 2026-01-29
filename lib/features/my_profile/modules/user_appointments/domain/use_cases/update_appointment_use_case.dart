import 'package:dartz/dartz.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/domain/entities/appointment_entity.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/domain/repository/base_user_appointments_repository.dart';
import '../../../../../../core/errors/failure.dart';

class UpdateAppointmentUseCase {
  final BaseUserAppointmentsRepository _baseUserAppointmentsRepository;

  UpdateAppointmentUseCase(this._baseUserAppointmentsRepository);

  Future<Either<Failure, void>> call(
    Map<String, dynamic> data,
  ) async {
    return await _baseUserAppointmentsRepository.updateAppointment(data);
  }
}