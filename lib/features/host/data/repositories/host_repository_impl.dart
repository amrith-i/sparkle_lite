import '../../../../core_import.dart';

@LazySingleton(as: HostRepository)
class HostRepositoryImpl extends BaseRepository implements HostRepository {
  final HostRemoteDatasource remote;

  HostRepositoryImpl(super.dio, this.remote);
}
