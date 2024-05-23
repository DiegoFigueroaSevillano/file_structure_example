
import 'package:teslo_shop/features/auth/domain/datasources/auth_datasource.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/domain/repositories/auth_repositorie.dart';
import 'package:teslo_shop/features/auth/infraestructure/datasources/auth_datasource_implementation.dart';

class AuthRepositoryImplementation extends AuthRepository {

  final AuthDataSource dataSource;

  AuthRepositoryImplementation({AuthDataSource? dataSource}) : dataSource = dataSource ?? AuthDataSourceImplementation();



  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<User> register(String email, String password) {
    return dataSource.register(email, password);
  }

}