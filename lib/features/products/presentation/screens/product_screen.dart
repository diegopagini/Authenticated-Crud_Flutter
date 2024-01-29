import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_provider.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;

  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider(productId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar producto'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt_outlined))
        ],
      ),
      body: Center(child: Text(productState.product?.id ?? 'Cargando')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save_as_outlined),
        onPressed: () {},
      ),
    );
  }
}
