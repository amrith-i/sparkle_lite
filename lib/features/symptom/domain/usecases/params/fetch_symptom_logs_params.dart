import '../../../../../core_import.dart';

class FetchSymptomLogsParams extends Equatable {
  final String userId;

  const FetchSymptomLogsParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
