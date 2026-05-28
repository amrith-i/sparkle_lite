import '../../../../../core_import.dart';

class FetchSymptomLogsForInsightParams extends Equatable {
  final String userId;

  const FetchSymptomLogsForInsightParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
