import 'package:finansale/features/auth/data/models/user_model.dart';
import 'package:finansale/features/rh/data/datasources/rh_remote_data_source.dart';
import 'package:finansale/features/rh/data/models/subtipo_solicitud_model.dart';
import 'package:finansale/features/rh/data/models/tipo_solicitud_model.dart';

import '../../domain/repositories/rh_repository.dart';

class RhRepositoryImpl implements RhRepository {
  final RhRemoteDataSource remoteDataSource;

  RhRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TipoSolicitudModel>> getTiposSolicitud(UserModel user) async {
    return await remoteDataSource.getTiposSolicitud(user);
  }

  @override
  Future<List<SubtipoSolicitudModel>> getSubtiposPorTipo(
    UserModel user,
    int idTipoSolicitud,
  ) async {
    // AHORA SÍ PASAMOS AMBOS PARÁMETROS CORRECTAMENTE
    return await remoteDataSource.getSubtiposPorTipo(user, idTipoSolicitud);
  }
}
