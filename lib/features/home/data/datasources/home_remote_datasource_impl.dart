import '../../../../core_import.dart';

@LazySingleton(as: HomeRemoteDatasource)
class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final Dio dio;

  HomeRemoteDatasourceImpl(this.dio);
}
