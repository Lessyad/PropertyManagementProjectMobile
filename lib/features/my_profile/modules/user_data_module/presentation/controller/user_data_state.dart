part of 'user_data_cubit.dart';

class UserDataState extends Equatable {
  const UserDataState({
    this.getUserDataState = RequestState.initial,
    this.updateUserDataState = RequestState.initial,
    this.userDataEntity,
    this.getUserDataErrorMessage = '',
    this.updateUserDataErrorMessage = '',
  });

  final RequestState getUserDataState;
  final UserDataEntity? userDataEntity;
  final String getUserDataErrorMessage;

  final RequestState updateUserDataState;
  final String updateUserDataErrorMessage;

  UserDataState copyWith({
    RequestState? getUserDataState,
    UserDataEntity? userDataEntity,
    String? getUserDataErrorMessage,
    RequestState? updateUserDataState,
    String? updateUserDataErrorMessage,
  }) {
    return UserDataState(
      getUserDataState: getUserDataState ?? this.getUserDataState,
      userDataEntity: userDataEntity ?? this.userDataEntity,
      getUserDataErrorMessage:
          getUserDataErrorMessage ?? this.getUserDataErrorMessage,
      updateUserDataState: updateUserDataState ?? this.updateUserDataState,
      updateUserDataErrorMessage:
          updateUserDataErrorMessage ?? this.updateUserDataErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        getUserDataState,
        userDataEntity,
        getUserDataErrorMessage,
        updateUserDataErrorMessage,
        updateUserDataState,
      ];
}
