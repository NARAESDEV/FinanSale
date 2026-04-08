import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  Future<UserModel> login(String email, String password) async {
    // Aquí podrías agregar lógica extra, como guardar el token localmente después
    return await _remoteDataSource.login(email, password);
  }
}
