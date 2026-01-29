import 'package:dartz/dartz.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/data/data_source/user_appointments_remote_data_source.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/domain/entities/appointment_entity.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/domain/repository/base_user_appointments_repository.dart';
import 'package:enmaa/features/my_profile/modules/user_properties_module/data/data_source/user_properties_remote_data_source.dart';
import 'package:enmaa/features/my_profile/modules/user_properties_module/domain/repository/base_user_properties_repository.dart';
import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/services/handle_api_request_service.dart';


class UserAppointmentsRepository extends BaseUserAppointmentsRepository {
  final BaseUserAppointmentsRemoteData baseUserAppointmentsRemoteData;

  UserAppointmentsRepository({required this.baseUserAppointmentsRemoteData});


  @override
  Future<Either<Failure, List<AppointmentEntity>>> getUserAppointments({Map<String, dynamic>? filters}) async{
    return HandleRequestService.handleApiCall<List<AppointmentEntity>>(() async {
      final result = await baseUserAppointmentsRemoteData.getUserAppointments(filters: filters);
      return result;
    });
  }

  @override
  Future<Either<Failure, String>> cancelAppointment(String appointmentId) async{

    return HandleRequestService.handleApiCall<String>(() async {
      final result = await baseUserAppointmentsRemoteData.cancelAppointment(appointmentId);
      return result;
    });
  }

  @override
  Future<Either<Failure, void>> updateAppointment(Map<String, dynamic> data) async{
   return HandleRequestService.handleApiCall<void>(() async {
      final result = await baseUserAppointmentsRemoteData.updateAppointment(data);
      return result;
    });
  }


}