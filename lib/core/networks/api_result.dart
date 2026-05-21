import '../../core_import.dart';

class ApiResult<T> extends Equatable {
  final T? data;
  final ApiFailure? failure;

  const ApiResult._({this.data, this.failure});

  bool get isSuccess => failure == null;

  factory ApiResult.success(T data) => ApiResult._(data: data);

  factory ApiResult.failure(ApiFailure failure) =>
      ApiResult._(failure: failure);

  @override
  List<Object?> get props => [data, failure];
}
