
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/entity/Product.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_form_provider.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_provider.dart';
import 'package:teslo_shop/features/products/presentation/screens/custom_product_field.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/camera_gallery_service_impl.dart';
import 'package:teslo_shop/features/shared/widgets/full_scren_loader.dart';

class ProductScreen extends ConsumerWidget {

  final String productId;

  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final productState = ref.watch(ProductProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar producto'),
        actions: [
          IconButton(
              onPressed: () async {
                final photoPath = await CameraServiceImpl().selectPhoto();
                if (photoPath == null) return;
                ref.read(ProductFormProvider(productState.product!).notifier).updateProductImage(photoPath);
                photoPath;
              },
              icon: const Icon(Icons.camera_alt_outlined)
          ),

          IconButton(
              onPressed: () async {
                final photoPath = await CameraServiceImpl().takePhoto();
                if (photoPath == null) return;
                ref.read(ProductFormProvider(productState.product!).notifier).updateProductImage(photoPath);
                photoPath;
              },
              icon: const Icon(Icons.photo_library_outlined)
          )
        ],
      ),

      body: productState.isLoading ? const FullScreenLoader() : _ProductView(product: productState.product!),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (productState.product == null) return;
          ref.read(ProductFormProvider(productState.product!).notifier).onFormSubmit();
        },
      child: const Icon(Icons.save_as_outlined),
      ),
    );
  }
}

class _ProductView extends ConsumerWidget {
  final Product product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final productForm = ref.watch(ProductFormProvider(product));
    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(images: productForm.images),
        ),

        const SizedBox(height: 10,),
        Center(child: Text(productForm.title.value, style: textStyles.titleSmall,),),
        const SizedBox(height: 10,),
        _ProductInformation(product: product),
      ],
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final Product product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final productForm = ref.watch(ProductFormProvider(product));


    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15,),
          CustomProductField(
            isTopField: true,
            label: 'Nombre',
            initialValue: productForm.title.value,
            onChanged: ref.read(ProductFormProvider(product).notifier).onTitleChanged,
            errorMessage: productForm.title.errorMessage,
          ),

          CustomProductField(
            isTopField: true,
            label: 'Slug',
            initialValue: productForm.slug.value,
            onChanged: ref.read(ProductFormProvider(product).notifier).onSlugCHanged,
            errorMessage: productForm.slug.errorMessage,
          ),

          CustomProductField(
            isBottomField: true,
            label: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.price.value.toString(),
            onChanged: (value) => ref.read(ProductFormProvider(product).notifier).onPriceChanged(double.tryParse(value) ?? -1),
            errorMessage: productForm.price.errorMessage,
          ),

          const SizedBox(height: 15,),
          const Text('Extras'),

          _SizeSelector(
            selectedSizes: productForm.sizes,
            onSizesChanged: ref.read(ProductFormProvider(product).notifier).onSizeChanged,
          ),

          const SizedBox(height: 5,),
          _GenderSelector(
              selectedGender: productForm.gender,
            onGenderChanged: ref.read(ProductFormProvider(product).notifier).onGenderChanged,
          ),

          const SizedBox(height: 15,),
          CustomProductField(
            isTopField: true,
            label: 'Existencias',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.stock.value.toString(),
            onChanged: (value) => ref.read(ProductFormProvider(product).notifier).onStockChanged(int.tryParse(value) ?? -1),
            errorMessage: productForm.stock.errorMessage,
          ),

          CustomProductField(
            maxLines: 6,
            label: 'Description',
            keyboardType: TextInputType.multiline,
            initialValue: product.description,
          ),

          CustomProductField(
            isBottomField: true,
            maxLines: 2,
            label: 'Tags',
            keyboardType: TextInputType.multiline,
            initialValue: product.tags.join(', '),
          ),

          const SizedBox(height: 100,),
        ],
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const['XS','S','M','L','XL','XXL','XXXL'];

  final Function(List<String> sizes) onSizesChanged;

  const _SizeSelector({required this.selectedSizes, required this.onSizesChanged});


  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 10))
        );
      }).toList(),
      selected: Set.from( selectedSizes ),
      onSelectionChanged: (newSelection) {
        onSizesChanged(List.from(newSelection));
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final List<String> genders = const['men','women','kid'];
  final List<IconData> genderIcons = const[
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];

  final void Function(String gender) onGenderChanged;

  const _GenderSelector({required this.selectedGender, required this.onGenderChanged});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact ),
        segments: genders.map((size) {
          return ButtonSegment(
              icon: Icon( genderIcons[ genders.indexOf(size) ] ),
              value: size,
              label: Text(size, style: const TextStyle(fontSize: 12))
          );
        }).toList(),
        selected: { selectedGender },
        onSelectionChanged: (newSelection) {
          onGenderChanged(newSelection.first);
        },
      ),
    );
  }
}


class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {

    if (images.isEmpty) {
      return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover ));
    }

    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(
          viewportFraction: 0.7
      ),
      children: images.map((e){

        late ImageProvider imageProvider;
        if (e.startsWith('http')){
          imageProvider = NetworkImage(e);
        } else {
          imageProvider = FileImage(File(e));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: FadeInImage(
              fit: BoxFit.cover,
              image: imageProvider,
              placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
            )
          ),
        );
      }).toList(),
    );
  }
}

