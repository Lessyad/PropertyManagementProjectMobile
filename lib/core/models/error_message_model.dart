import 'package:equatable/equatable.dart';

class ErrorMessageModel extends Equatable {
  final int? status;
  final String message;

  const ErrorMessageModel({this.status, required this.message});

  @override
  List<Object> get props => [message];

  factory ErrorMessageModel.fromJson(Map<String, dynamic> map) =>
      ErrorMessageModel(
        status: map['status'] ?? 500,
        message: map['message'] ?? 'Unexpected Error',
      );
}