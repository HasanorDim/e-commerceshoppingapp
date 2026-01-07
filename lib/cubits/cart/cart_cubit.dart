import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/cache_service.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CacheService _cacheService = CacheService();

  CartCubit() : super(const CartState()) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    emit(state.copyWith(isLoading: true));
    try {
      final items = await _cacheService.loadCart();
      emit(state.copyWith(items: items, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _saveCart() async {
    await _cacheService.saveCart(state.items);
  }

  Future<void> addItem(Product product, {int quantity = 1}) async {
    final items = List<CartItem>.from(state.items);

    final existingIndex = items.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingIndex >= 0) {
      items[existingIndex].quantity += quantity;
    } else {
      items.add(
        CartItem(
          productId: product.id,
          title: product.title,
          price: product.price,
          image: product.image,
          quantity: quantity,
        ),
      );
    }

    // IMPORTANT: Create new state object
    emit(CartState(items: items, isLoading: false));
    await _saveCart();
  }

  Future<void> removeItem(int productId) async {
    final items = List<CartItem>.from(state.items);
    items.removeWhere((item) => item.productId == productId);

    // IMPORTANT: Create new state object
    emit(CartState(items: items, isLoading: false));
    await _saveCart();
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    if (quantity <= 0) {
      await removeItem(productId);
      return;
    }

    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((item) => item.productId == productId);

    if (index >= 0) {
      // Create a NEW CartItem with updated quantity
      items[index] = CartItem(
        productId: items[index].productId,
        title: items[index].title,
        price: items[index].price,
        image: items[index].image,
        quantity: quantity,
      );

      // IMPORTANT: Create new state object
      emit(CartState(items: items, isLoading: false));
      await _saveCart();
    }
  }

  Future<void> clearCart() async {
    emit(const CartState(items: []));
    await _saveCart();
  }
}
