
import 'package:dio/dio.dart';
import 'package:teslo_shop/config/const/enviroment.dart';
import 'package:teslo_shop/features/auth/domain/datasources/auth_datasource.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/infraestructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/infraestructure/mappers/user_mapper.dart';

class AuthDataSourceImplementation extends AuthDataSource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Enviroment.apiUrl,
    )
  );

  @override
  Future<User> checkAuthStatus(String token) async{
    try {
      final response = await dio.get('/auth/check-status',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
      final user = USerMapper.userJsonToEntity(response.data);
      return user;
    } catch (e){
      throw CustomError('error', 401);
    }
  }

  @override
  Future<User> login(String email, String password) async{
    try {
      final response = await dio.post('/auth/login', data: {
        'email' : email,
        'password' : password
      });

      final user = USerMapper.userJsonToEntity(response.data);
      return user;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout) throw ConnectionTimeout();
      if (e.response?.statusCode == 401) throw WrongCredentials();
      throw CustomError('Something wrong happend', 1);
    } catch (e) {
      throw CustomError('Something wrong happend', 1);
    }
  }

  @override
  Future<User> register(String email, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }

}