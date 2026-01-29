part of 'preview_property_cubit.dart';

class PreviewPropertyState extends Equatable {
  const PreviewPropertyState({
    this.showPreviewDate = false,
    this.selectedDate,
     this.selectedTime,
    this.availableHours = const [],
    this.getAvailableHoursState = RequestState.initial,
    this.addNewPreviewTimeState = RequestState.initial,
    this.getAvailableHoursErrorMessage = '',
    this.currentAvailableHours = const [],

    this.getInspectionAmountErrorMessage = '' ,
    this.getInspectionAmountState = RequestState.initial,
    this.inspectionAmount = '',

    this.currentPaymentMethod = 'PayPal',
    this.bankilyPassCode = '',
    this.addNewPreviewTimeErrorMessage = '',
  });

  final bool showPreviewDate;
  final DateTime? selectedDate;

   final String? selectedTime;

  final RequestState getAvailableHoursState;
  final List<DayAndHoursEntity> availableHours;
  final String getAvailableHoursErrorMessage;

  final List<String> currentAvailableHours;

  final RequestState getInspectionAmountState;
  final String getInspectionAmountErrorMessage;
  final String inspectionAmount;


  final String currentPaymentMethod ;
  final String bankilyPassCode ;

  final RequestState addNewPreviewTimeState ;
  final String addNewPreviewTimeErrorMessage ;
  PreviewPropertyState copyWith({
    bool? showPreviewDate,
    DateTime? selectedDate,
    bool? showPreviewTime,
    String? selectedTime,
    bool? makeSelectedTimeNull,
    RequestState? getAvailableHoursState,
    List<DayAndHoursEntity>? availableHours,
    String? getAvailableHoursErrorMessage,
    List<String>? currentAvailableHours,

    RequestState? getInspectionAmountState,
    String? getInspectionAmountErrorMessage,
    String? inspectionAmount,

    String? currentPaymentMethod,
    String? bankilyPassCode,

    RequestState? addNewPreviewTimeState,
    String? addNewPreviewTimeErrorMessage,
  }) {
    return PreviewPropertyState(
      showPreviewDate: showPreviewDate ?? this.showPreviewDate,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: makeSelectedTimeNull == true ? null : selectedTime ?? this.selectedTime, // Reset to null if makeSelectedTimeNull is true
      getAvailableHoursState: getAvailableHoursState ?? this.getAvailableHoursState,
      availableHours: availableHours ?? this.availableHours,
      getAvailableHoursErrorMessage: getAvailableHoursErrorMessage ?? this.getAvailableHoursErrorMessage,
      currentAvailableHours: currentAvailableHours ?? this.currentAvailableHours,

      getInspectionAmountState: getInspectionAmountState ?? this.getInspectionAmountState,
      getInspectionAmountErrorMessage: getInspectionAmountErrorMessage ?? this.getInspectionAmountErrorMessage,
      inspectionAmount: inspectionAmount ?? this.inspectionAmount,

      currentPaymentMethod: currentPaymentMethod ?? this.currentPaymentMethod,
      bankilyPassCode: bankilyPassCode ?? this.bankilyPassCode,
      addNewPreviewTimeErrorMessage: addNewPreviewTimeErrorMessage ?? this.addNewPreviewTimeErrorMessage,

      addNewPreviewTimeState: addNewPreviewTimeState ?? this.addNewPreviewTimeState,
    );
  }

  @override
  List<Object?> get props => [
    showPreviewDate,
    selectedDate,
     selectedTime,
    getAvailableHoursState,
    availableHours,
    getAvailableHoursErrorMessage,
    currentAvailableHours,
    currentPaymentMethod,
    bankilyPassCode,
    getInspectionAmountState,
    getInspectionAmountErrorMessage,
    inspectionAmount,
    addNewPreviewTimeState,
    addNewPreviewTimeErrorMessage,

  ];
}