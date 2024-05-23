
import 'package:dio/dio.dart';
import 'package:teslo_shop/config/const/enviroment.dart';
import 'package:teslo_shop/features/products/domain/datasource/products_datasource.dart';
import 'package:teslo_shop/features/products/domain/entity/Product.dart';
import 'package:teslo_shop/features/products/infraestructure/errors/product_errors.dart';
import 'package:teslo_shop/features/products/infraestructure/mappers/products_mapper.dart';

class ProductsDatasourceImpl implements ProductsDataSource{

  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({
    required this.accessToken
  }) : dio = Dio(
    BaseOptions(
      baseUrl: Enviroment.apiUrl,
      headers: {
        'Authorization': 'Bearer $accessToken'
      }
    )
  );

  Future<String> _uploadFile(String path) async {
    try {
      final fileName = path.split('/').last;
      final FormData data = FormData.fromMap({'file' : MultipartFile.fromFileSync(path, filename: fileName)});
      final response = await dio.post('/files/product', data: data);
      return response.data['image'];
    } catch(e) {
      throw Exception();
    }
  }

  Future<List<String>> _uploadPhotos(List<String> photos) async {

    final photosToUpload = photos.where((element) => element.contains('/')).toList();
    final ignorePhotos = photos.where((element) => !element.contains('/')).toList();

    final List<Future<String>> uploadImageLogic = photosToUpload.map(_uploadFile).toList();
    final newImages = await Future.wait(uploadImageLogic);


    return [...ignorePhotos, ...newImages];

  }


  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async{
    try{

      final String? productId = productLike['id'];
      final String method = (productId == null) ? 'POST':'PATCH';
      final String url = (productId == null) ? '/products':'/products/$productId';
      productLike.remove('id');
      productLike['images'] = await _uploadPhotos(productLike['images']);

      final response = await dio.request(url, data: productLike, options: Options(method: method));

      final product = ProductMapper.jsonToEntity(response.data);
      return product;

    }catch(e){
      throw Exception();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioError catch(e){
      if (e.response!.statusCode == 404) throw ProductNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) async {
    final response = await dio.get<List>('/products', queryParameters: {
      'limit' : limit,
      'offset' : offset
    });
    final List<Product> products = [];
    for (final product in response.data ?? []){
      products.add(ProductMapper.jsonToEntity(product));
    }

    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }

}