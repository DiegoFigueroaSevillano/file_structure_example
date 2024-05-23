import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/domain/repository/products_repository.dart';
import 'package:teslo_shop/features/products/infraestructure/datasources%20/products_datasource_impl.dart';
import 'package:teslo_shop/features/products/infraestructure/repository/products_repository_impl.dart';

final ProductsRepositoryProvider = Provider<ProductsRepository>((ref) {

  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final productsRepository = ProductsRepositoryImpl(dataSource: ProductsDatasourceImpl(accessToken: accessToken));

  return productsRepository;
});
