import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CacheService {
  static const String _productsKey = 'cached_products';
  static const String _cartKey = 'shopping_cart';
  static const String _darkModeKey = 'dark_mode';
  static const String _viewModeKey = 'view_mode';

  // Cache products
  Future<void> cacheProducts(List<Product> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonString = json.encode(
        products.map((product) => product.toJson()).toList(),
      );
      await prefs.setString(_productsKey, jsonString);
    } catch (e) {
      throw Exception('Failed to cache products: $e');
    }
  }

  // Get cached products
  Future<List<Product>> getCachedProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_productsKey);

      if (jsonString == null) return [];

      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Save cart
  Future<void> saveCart(List<CartItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonString = json.encode(
        items.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_cartKey, jsonString);
    } catch (e) {
      throw Exception('Failed to save cart: $e');
    }
  }

  // Load cart
  Future<List<CartItem>> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_cartKey);

      if (jsonString == null) return [];

      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => CartItem.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Dark mode
  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDark);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  // View mode
  Future<void> setViewMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_viewModeKey, mode);
  }

  Future<String> getViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_viewModeKey) ?? 'grid';
  }
}
