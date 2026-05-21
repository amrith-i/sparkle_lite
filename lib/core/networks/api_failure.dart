import 'package:daily_finance_manager/core_import.dart';

class ApiFailure extends Equatable {
  final String message;
  final int? statusCode;
  final dynamic rawError;

  const ApiFailure({required this.message, this.statusCode, this.rawError});

  String get userMessage => message;

  @override
  List<Object?> get props => [message, statusCode, rawError];
}
