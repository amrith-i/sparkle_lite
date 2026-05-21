import '../../core_import.dart';

abstract class BaseRepository {
  final Dio dio;

  BaseRepository(this.dio);

  Future<ApiResult<T>> safeApiCall<T>(Future<T> Function() request) async {
    try {
      final T response = await request();
      return ApiResult.success(response);
    } on ApiValidationException catch (e, stack) {
      ErrorHandler.log(e, stack);
      return ApiResult.failure(ApiFailure(message: e.toString(), rawError: e));
    } on DioException catch (e, stack) {
      ErrorHandler.log(e, stack);
      final ApiFailure failure = e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure(
              message: e.message ?? 'Unexpected error',
              statusCode: e.response?.statusCode,
              rawError: e,
            );

      return ApiResult.failure(failure);
    } catch (e, stack) {
      ErrorHandler.log(e, stack);
      return ApiResult.failure(
        ApiFailure(message: ErrorHandler.message(e), rawError: e),
      );
    }
  }

  // Future<ApiResult<T>> safeApiCall<T>(Future<T> Function() request) async {
  //   try {
  //     print('✅ API CALL STARTED');
  //     final T response = await request();
  //     print('✅ API CALL SUCCESS: $response');
  //     return ApiResult.success(response);
  //   } on ApiValidationException catch (e, stack) {
  //     print('🛑 ApiValidationException: $e');
  //     print(stack);
  //     return ApiResult.failure(ApiFailure(message: e.toString(), rawError: e));
  //   } on DioException catch (e, stack) {
  //     print('🛑 DioException: ${e.message}');
  //     print('🛑 Status: ${e.response?.statusCode}');
  //     print(stack);
  //     return ApiResult.failure(
  //       ApiFailure(
  //         message: e.message ?? 'Unexpected error',
  //         statusCode: e.response?.statusCode,
  //         rawError: e,
  //       ),
  //     );
  //   } catch (e, stack) {
  //     print('🔥 CATCH-ALL HIT');
  //     print('🔥 ERROR TYPE: ${e.runtimeType}');
  //     print('🔥 ERROR VALUE: $e');
  //     print(stack);

  //     return ApiResult.failure(
  //       ApiFailure(message: ErrorHandler.message(e), rawError: e),
  //     );
  //   }
  // }
}
