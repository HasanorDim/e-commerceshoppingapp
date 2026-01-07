import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../services/cache_service.dart';
import '../../models/product.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  ProductCubit() : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());

    try {
      final products = await _apiService.getProducts();
      await _cacheService.cacheProducts(products);

      emit(ProductLoaded(products: products, filteredProducts: products));
    } catch (e) {
      // Try to load from cache
      try {
        final cachedProducts = await _cacheService.getCachedProducts();
        if (cachedProducts.isNotEmpty) {
          emit(
            ProductLoaded(
              products: cachedProducts,
              filteredProducts: cachedProducts,
            ),
          );
        } else {
          emit(ProductError('Failed to load products: $e'));
        }
      } catch (cacheError) {
        emit(ProductError('Failed to load products: $e'));
      }
    }
  }

  void searchProducts(String query) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final filtered = currentState.products.where((product) {
        return product.title.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase());
      }).toList();

      emit(
        currentState.copyWith(filteredProducts: filtered, searchQuery: query),
      );
    }
  }

  void filterByCategory(String category) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;

      List<Product> filtered;
      if (category == 'all') {
        filtered = currentState.products;
      } else {
        filtered = currentState.products
            .where((product) => product.category == category)
            .toList();
      }

      // Apply search if exists
      if (currentState.searchQuery.isNotEmpty) {
        filtered = filtered.where((product) {
          return product.title.toLowerCase().contains(
            currentState.searchQuery.toLowerCase(),
          );
        }).toList();
      }

      emit(
        currentState.copyWith(
          filteredProducts: filtered,
          selectedCategory: category,
        ),
      );
    }
  }

  // void sortProducts(String sortOption) {
  //   if (state is ProductLoaded) {
  //     final currentState = state as ProductLoaded;
  //     final sorted = List<Product>.from(currentState.filteredProducts);

  //     switch (sortOption) {
  //       case 'price_low':
  //         sorted.sort((a, b) => a.price.compareTo(b.price));
  //         break;
  //       case 'price_high':
  //         sorted.sort((a, b) => b.price.compareTo(a.price));
  //         break;
  //       case 'rating':
  //         sorted.sort((a, b) => b.rating.compareTo(a.rating));
  //         break;
  //       case 'name':
  //         sorted.sort((a, b) => a.title.compareTo(b.title));
  //         break;
  //     }

  //     emit(
  //       currentState.copyWith(filteredProducts: sorted, sortOption: sortOption),
  //     );
  //   }
  // }

  List<Product> _applyCurrentFilters(List<Product> products) {
    if (state is! ProductLoaded) return products;

    final currentState = state as ProductLoaded;
    var filtered = products;

    // Apply category filter
    if (currentState.selectedCategory != 'all') {
      filtered = filtered
          .where((p) => p.category == currentState.selectedCategory)
          .toList();
    }

    // Apply search filter
    if (currentState.searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        return product.title.toLowerCase().contains(
              currentState.searchQuery.toLowerCase(),
            ) ||
            product.description.toLowerCase().contains(
              currentState.searchQuery.toLowerCase(),
            );
      }).toList();
    }

    return filtered;
  }

  void sortProducts(String sortOption) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      List<Product> sorted = List<Product>.from(currentState.filteredProducts);

      switch (sortOption) {
        case 'price_low':
          sorted.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'price_high':
          sorted.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'rating':
          sorted.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'name':
          sorted.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'default':
          // Reset to original filtered order
          sorted = _applyCurrentFilters(currentState.products);
          break;
      }

      emit(
        currentState.copyWith(filteredProducts: sorted, sortOption: sortOption),
      );
    }
  }

  List<String> getCategories() {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final categories = currentState.products
          .map((p) => p.category)
          .toSet()
          .toList();
      return ['all', ...categories];
    }
    return ['all'];
  }
}
