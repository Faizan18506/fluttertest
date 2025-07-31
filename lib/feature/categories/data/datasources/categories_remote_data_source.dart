import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/categories_response_model.dart';
import '../../../../feature/products/data/models/products_response_model.dart';

abstract class CategoriesRemoteDataSource {
  Future<CategoriesResponseModel> getCategories();
  Future<ProductsResponseModel> getProductsByCategory(String category);
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final http.Client client;

  CategoriesRemoteDataSourceImpl({required this.client});

  @override
  Future<CategoriesResponseModel> getCategories() async {
    try {
      final response = await client.get(
        Uri.parse('https://dummyjson.com/products/categories'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        return CategoriesResponseModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  @override
  Future<ProductsResponseModel> getProductsByCategory(String category) async {
    try {
      final response = await client.get(
        Uri.parse('https://dummyjson.com/products/category/$category'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ProductsResponseModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load products by category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load products by category: $e');
    }
  }
} 