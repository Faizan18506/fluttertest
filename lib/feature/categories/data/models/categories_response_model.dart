import 'category_model.dart';

class CategoriesResponseModel {
  final List<CategoryModel> categories;

  CategoriesResponseModel({
    required this.categories,
  });

  factory CategoriesResponseModel.fromJson(List<dynamic> json) {
    return CategoriesResponseModel(
      categories: json.map((category) => CategoryModel.fromJson(category)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return categories.map((category) => category.toJson()).toList();
  }
} 