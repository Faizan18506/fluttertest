import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/products_response_model.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<ProductsResponseModel> getProducts();
  Future<ProductModel> getProductById(int productId);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final http.Client client;

  ProductsRemoteDataSourceImpl({required this.client});

  @override
  Future<ProductsResponseModel> getProducts() async {
    final response = await client.get(
      Uri.parse('https://dummyjson.com/products?limit=100'),
    );

    if (response.statusCode == 200) {
      return ProductsResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<ProductModel> getProductById(int productId) async {
    final response = await client.get(
      Uri.parse('https://dummyjson.com/products/$productId'),
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product details');
    }
  }
} 