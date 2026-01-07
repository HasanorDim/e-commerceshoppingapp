import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const Duration timeout = Duration(seconds: 10);

  Future<List<Product>> getProducts() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/products'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/products/$id'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
