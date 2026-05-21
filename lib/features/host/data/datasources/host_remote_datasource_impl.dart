import '../../../../core_import.dart';

@LazySingleton(as: HostRemoteDatasource)
class HostRemoteDatasourceImpl implements HostRemoteDatasource {
  final Dio dio;

  HostRemoteDatasourceImpl(this.dio);
}
