import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/bio_metric_service.dart';
import '../../domain/use_cases/login_using_local_authentication.dart';
import 'biometric_event.dart';
import 'biometric_state.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  final LoginUsingLocalAuthentication loginUsingLocalAuthentication;
  final BiometricService bioMetricService;

  BiometricBloc(this.loginUsingLocalAuthentication, this.bioMetricService)
      : super(BiometricInitial()) {
    on<AuthenticateWithBiometrics>(_onAuthenticate);
  }

  Future<void> _onAuthenticate(
      AuthenticateWithBiometrics event, Emitter<BiometricState> emit) async {
    emit(BiometricLoading());

    try {
      final hasRealSecurity = await bioMetricService.hasAnyRealSecurity();

      if (!hasRealSecurity) {
        emit(BiometricSuccess());
        return;
      }

      final canCheckBiometrics = await bioMetricService.isBiometricAvailable();

      if (canCheckBiometrics) {
        final result = await loginUsingLocalAuthentication();
        result.fold(
              (failure) {
            emit(BiometricFailure());
          },
              (isAuthenticated) {
            if (isAuthenticated) {
              emit(BiometricSuccess());
            } else {
              emit(BiometricFailure());
            }
          },
        );
      } else {
        final result = await bioMetricService.authenticateWithBiometrics();
        if (result) {
          emit(BiometricSuccess());
        } else {
          emit(BiometricFailure());
        }
      }
    } catch (e) {
      emit(BiometricFailure());
    }
  }
}