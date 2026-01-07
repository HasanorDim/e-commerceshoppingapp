import 'package:equatable/equatable.dart';
import '../../models/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final String searchQuery;
  final String selectedCategory;
  final String sortOption;

  const ProductLoaded({
    required this.products,
    required this.filteredProducts,
    this.searchQuery = '',
    this.selectedCategory = 'all',
    this.sortOption = 'default',
  });

  ProductLoaded copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    String? searchQuery,
    String? selectedCategory,
    String? sortOption,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  @override
  List<Object?> get props => [
    products,
    filteredProducts,
    searchQuery,
    selectedCategory,
    sortOption,
  ];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
