import '../../../../core_import.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl extends BaseRepository implements HomeRepository {
  final HomeRemoteDatasource remote;

  HomeRepositoryImpl(super.dio, this.remote);
}
