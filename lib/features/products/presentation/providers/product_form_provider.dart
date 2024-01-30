import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/shared/shared.dart';

/// NOTIFIER
class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final void Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({this.onSubmitCallback, required Product product})
      : super(ProductFormState(
            id: product.id,
            title: Title.dirty(product.title),
            slug: Slug.dirty(product.slug),
            price: Price.dirty(product.price),
            stock: Stock.dirty(product.stock),
            sizes: product.sizes,
            description: product.description,
            images: product.images,
            tags: product.tags.join(', ')));

  void onTitleChange(String value) {
    state = state.copyWith(
        title: Title.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.stock.value),
        ]));
  }

  void onSlugChange(String value) {
    state = state.copyWith(
        slug: Slug.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(value),
          Price.dirty(state.price.value),
          Stock.dirty(state.stock.value),
        ]));
  }

  void onPriceChange(double value) {
    state = state.copyWith(
        price: Price.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(value),
          Stock.dirty(state.stock.value),
        ]));
  }

  void onStockChange(int value) {
    state = state.copyWith(
        stock: Stock.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(value),
        ]));
  }

  void onSizedChanges(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onGenderChange(String gender) {
    state = state.copyWith(gender: gender);
  }

  void onDescriptionChange(String description) {
    state = state.copyWith(description: description);
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(tags: tags);
  }

  void _touchEverything() {
    state = state.copyWith(
        isFormValid: Formz.validate([
      Title.dirty(state.title.value),
      Slug.dirty(state.slug.value),
      Price.dirty(state.price.value),
      Stock.dirty(state.stock.value),
    ]));
  }

  Future<bool> onFormSubmit() async {
    _touchEverything();
    if (!state.isFormValid) return false;

    if (onSubmitCallback == null) return false;

    final productLike = {
      'id': state.id,
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug,
      'stock': state.stock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(','),
      'images': state.images
          .map((img) =>
              img.replaceAll('${Environment.apiUrl}/files/product/', ''))
          .toList()
    };

    return true;
  }
}

/// STATE
class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock stock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState(
      {this.isFormValid = false,
      this.id,
      this.title = const Title.dirty(''),
      this.slug = const Slug.dirty(''),
      this.price = const Price.dirty(0),
      this.sizes = const [],
      this.gender = 'men',
      this.stock = const Stock.dirty(0),
      this.description = '',
      this.tags = '',
      this.images = const []});

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? stock,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      ProductFormState(
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
          images: images ?? this.images);
}

/// Provider
final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  return ProductFormNotifier(
    product: product,
    // onSubmitCallback:
  );
});
