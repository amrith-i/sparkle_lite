import '../../../../../core_import.dart';

class FetchHealthRecordsParams extends Equatable {
  final String userId;

  const FetchHealthRecordsParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
