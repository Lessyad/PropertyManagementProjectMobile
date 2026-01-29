import 'package:dartz/dartz.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/domain/entities/appointment_entity.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/domain/repository/base_user_appointments_repository.dart';
import '../../../../../../core/errors/failure.dart';

class GetUserAppointmentsUseCase {
  final BaseUserAppointmentsRepository _baseUserAppointmentsRepository;

  GetUserAppointmentsUseCase(this._baseUserAppointmentsRepository);

  Future<Either<Failure, List<AppointmentEntity>>> call({
    Map<String, dynamic>? filters,
  }) async {
    return await _baseUserAppointmentsRepository.getUserAppointments(filters: filters);
  }
}