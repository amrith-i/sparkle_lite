import '../../../../../core_import.dart';

class FetchHomeParams extends Equatable {
  final String userId;

  const FetchHomeParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
