
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/const/enviroment.dart';
import 'package:teslo_shop/features/products/domain/entity/Product.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_provider.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/price.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/slug.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/stock.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/tittle.dart';

class ProductFormState {

  final bool isFormValid;
  final String? id;
  final Tittle title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock stock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false,
    this.id,
    this.title = const Tittle.dirty(''),
    this.slug = const Slug.dirty(''),
    this.price = const Price.dirty(0),
    this.sizes = const [],
    this.gender = 'men',
    this.stock = const Stock.dirty(0),
    this.description = '',
    this.tags = '',
    this.images = const [],
  });

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Tittle? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? stock,
    String? description,
    String? tags,
    List<String>? images,
  }) {
    return ProductFormState(
      isFormValid: isFormValid ?? this.isFormValid,
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      sizes: sizes ?? this.sizes,
      gender: gender ?? this.gender,
      stock: stock ?? this.stock,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      images: images ?? this.images,
    );
  }
}

class ProductFormNotifier extends StateNotifier<ProductFormState> {

  final Future<bool> Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({
    this.onSubmitCallback,
    required Product product,
  }) : super(ProductFormState(
    id: product.id ,
    title: Tittle.dirty(product.title),
    slug: Slug.dirty(product.slug),
    price: Price.dirty(product.price),
    sizes: product.sizes,
    gender: product.gender,
    stock: Stock.dirty(product.stock),
    description: product.description,
    tags: product.tags.join(', '),
    images: product.images,
  ));
  
  void onTitleChanged(String value){
    state = state.copyWith(
      title: Tittle.dirty(value),
      isFormValid: Formz.validate([
        Tittle.dirty(value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.stock.value)
      ])
    );
  }

  void onSlugCHanged(String value){
    state = state.copyWith(
        slug: Slug.dirty(value),
        isFormValid: Formz.validate([
          Tittle.dirty(state.title.value),
          Slug.dirty(value),
          Price.dirty(state.price.value),
          Stock.dirty(state.stock.value)
        ])
    );
  }

  void onPriceChanged(double value){
    state = state.copyWith(
        price: Price.dirty(value),
        isFormValid: Formz.validate([
          Tittle.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(value),
          Stock.dirty(state.stock.value)
        ])
    );
  }

  void onStockChanged(int value){
    state = state.copyWith(
        stock: Stock.dirty(value),
        isFormValid: Formz.validate([
          Tittle.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(value)
        ])
    );
  }

  void onSizeChanged(List<String> sizes){
    state = state.copyWith(
      sizes: sizes
    );
  }

  void updateProductImage(String path){
    state = state.copyWith(
      images: [...state.images, path]
    );
  }

  void onGenderChanged(String gender){
    state = state.copyWith(
      gender: gender
    );
  }

  void onDescriptionChanged(String description){
    state = state.copyWith(
      description: description
    );
  }

  void onTagsChanged(String tags){
    state = state.copyWith(
      tags: tags
    );
  }

  void _touchedEveryThing(){
    state = state.copyWith(
      isFormValid: Formz.validate([
        Tittle.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.stock.value)
      ])
    );
  }

  Future<bool> onFormSubmit() async {
    _touchedEveryThing();

    if (!state.isFormValid) return false;
    if (onSubmitCallback == null) return false;

    final Map<String, dynamic> productLike = {
      'id' : (state.id == 'new') ? null : state.id,
      "title": state.title.value,
      "price": state.price.value,
      "description": state.description,
      "slug": state.slug.value,
      "stock": state.stock.value,
      "sizes": state.sizes,
      "gender": state.gender,
      "tags": state.tags.split(','),
      "images": (state.images.map((e) => e.replaceAll('${Enviroment.apiUrl}/files/product/', ''))).toList()
    };

    try {
      return await onSubmitCallback!(productLike);
    } catch(e) {
      return false;
    }

    //TODO: LLAMAR AL ON SUBMITD CALLBACK
  }



}

final ProductFormProvider = StateNotifierProvider.autoDispose.family<ProductFormNotifier, ProductFormState, Product>((ref, product) {

  //TODO: createUpdateCallback
  //final createUpdateCallback = ref.watch(ProductsRepositoryProvider).createUpdateProduct;

  final createUpdateCallback = ref.watch(ProductsProvider.notifier).createOrUpdateProduct;

  return ProductFormNotifier(product: product, onSubmitCallback: createUpdateCallback);

});
