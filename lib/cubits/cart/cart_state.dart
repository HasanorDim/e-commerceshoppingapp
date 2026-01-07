import 'package:equatable/equatable.dart';
import '../../models/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final bool isLoading;

  const CartState({this.items = const [], this.isLoading = false});

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);

  CartState copyWith({List<CartItem>? items, bool? isLoading}) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [items, isLoading];
}
