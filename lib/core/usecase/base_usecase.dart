import '../../core_import.dart';

abstract class BaseUseCase<T, Params> {
  Future<ApiResult<T>> call(Params params);
}

class NoParams {}
