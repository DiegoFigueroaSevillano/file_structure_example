
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/entity/Product.dart';
import 'package:teslo_shop/features/products/domain/repository/products_repository.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_repository_provider.dart';

class ProductsState {

  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const[],
  });

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) {
    return ProductsState(
      isLastPage: isLastPage ?? this.isLastPage,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
    );
  }
}

class ProductsNotifier extends StateNotifier<ProductsState> {

  final ProductsRepository productRepository;

  ProductsNotifier({
    required this.productRepository
  }) : super(ProductsState()) {
    loadNextPage();
  }

  Future<bool> createOrUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final product = await productRepository.createUpdateProduct(productLike);
      final isProductInList = state.products.any((element) => element.id == product.id);
      if (!isProductInList){
        state = state.copyWith(
          products: [...state.products, product]
        );
        return true;
      } else {
        state = state.copyWith(
          products: state.products.map((e) => (e.id == product.id) ? product : e).toList()
        );
        return true;
      }
    } catch (e) {
      throw Exception();
    }
  }

  Future loadNextPage() async {

    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(
      isLoading: true
    );

    final products = await productRepository.getProductsByPage(limit: state.limit, offset: state.offset);
    if (products.isEmpty){
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...products]
    );
  }


}

final ProductsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {

  final productsRepository = ref.watch(ProductsRepositoryProvider);

  return ProductsNotifier(productRepository: productsRepository);

});
