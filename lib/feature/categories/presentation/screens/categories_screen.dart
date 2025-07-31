import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';
import '../cubit/categories_event.dart';
import 'products_by_category_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('CategoriesScreen: initState');
    // Load categories when screen initializes
    context.read<CategoriesCubit>().getCategories();
  }

  @override
  void dispose() {
    print('CategoriesScreen: dispose');
    _searchController.dispose();
    super.dispose();
  }

  String _getCategoryImageUrl(String categoryName) {
    // Get the thumbnail image from the category using the same API endpoint
    // that works in products_by_category_screen.dart
    final categorySlug = categoryName.toLowerCase().replaceAll(' ', '-');
    
    // Map categories to their thumbnail URLs from the API response
    // Using thumbnail URLs which are more optimized and consistent
    final categoryThumbnailMap = {
      'beauty': 'https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp',
      'fragrances': 'https://cdn.dummyjson.com/product-images/fragrances/calvin-klein-ck-one/thumbnail.webp',
      'furniture': 'https://cdn.dummyjson.com/product-images/furniture/annibale-colombo-bed/thumbnail.webp',
      'groceries': 'https://cdn.dummyjson.com/product-images/groceries/apple/thumbnail.webp',
      'home-decoration': 'https://cdn.dummyjson.com/product-images/home-decoration/decoration-swing/thumbnail.webp',
      'kitchen-accessories': 'https://cdn.dummyjson.com/product-images/kitchen-accessories/bamboo-spatula/thumbnail.webp',
      'laptops': 'https://cdn.dummyjson.com/product-images/laptops/apple-macbook-pro-14-inch-space-grey/thumbnail.webp',
      'mens-shirts': 'https://cdn.dummyjson.com/product-images/mens-shirts/blue-&-black-check-shirt/thumbnail.webp',
      'mens-shoes': 'https://cdn.dummyjson.com/product-images/mens-shoes/nike-air-jordan-1-red-and-black/thumbnail.webp',
      'mens-watches': 'https://cdn.dummyjson.com/product-images/mens-watches/brown-leather-belt-watch/thumbnail.webp',
      'mobile-accessories': 'https://cdn.dummyjson.com/product-images/mobile-accessories/amazon-echo-plus/thumbnail.webp',
      'motorcycle': 'https://cdn.dummyjson.com/product-images/motorcycle/generic-motorcycle/thumbnail.webp',
      'skincare': 'https://cdn.dummyjson.com/product-images/skin-care/attitude-super-leaves-hand-soap/thumbnail.webp',
      'smartphones': 'https://cdn.dummyjson.com/product-images/smartphones/iphone-5s/thumbnail.webp',
      'sports-accessories': 'https://cdn.dummyjson.com/product-images/sports-accessories/american-football/thumbnail.webp',
      'sunglasses': 'https://cdn.dummyjson.com/product-images/sunglasses/black-sun-glasses/thumbnail.webp',
      'tablets': 'https://cdn.dummyjson.com/product-images/tablets/ipad-mini-2021-starlight/thumbnail.webp',
      'tops': 'https://cdn.dummyjson.com/product-images/tops/blue-frock/thumbnail.webp',
      'vehicle': 'https://cdn.dummyjson.com/product-images/vehicle/300-touring/thumbnail.webp',
      'womens-bags': 'https://cdn.dummyjson.com/product-images/womens-bags/blue-women\'s-handbag/thumbnail.webp',
      'womens-dresses': 'https://cdn.dummyjson.com/product-images/womens-dresses/black-women\'s-gown/thumbnail.webp',
      'womens-jewellery': 'https://cdn.dummyjson.com/product-images/womens-jewellery/green-crystal-earring/thumbnail.webp',
      'womens-shoes': 'https://cdn.dummyjson.com/product-images/womens-shoes/black-&-brown-slipper/thumbnail.webp',
      'womens-watches': 'https://cdn.dummyjson.com/product-images/womens-watches/iwc-ingenieur-automatic-steel/thumbnail.webp',
    };
    
    final imageUrl = categoryThumbnailMap[categorySlug] ?? 'https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp';
    
    return imageUrl;
  }

  void _navigateToProductsByCategory(dynamic category) async {
    print('CategoriesScreen: Navigating to ProductsByCategoryScreen for category: ${category.name}');
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsByCategoryScreen(
          categoryName: category.name,
          categorySlug: category.slug,
        ),
      ),
    );
    print('CategoriesScreen: Returned from ProductsByCategoryScreen, clearing search');
    setState(() {
      _searchController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('CategoriesScreen: Calling getCategories after return');
      context.read<CategoriesCubit>().getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerSection(),
              _searchSection(),
              _categoriesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 1.h),
      ],
    );
  }

  Widget _searchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        Container(
          height: 5.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.sp),
            border: Border.all(
              color: Colors.black,
              width: 0.5.sp,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.black,
                size: 20.sp,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search categories...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                  onChanged: (value) {
                    setState(() {}); // Trigger rebuild to update filtered results
                  },
                ),
              ),
              if (_searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                  child: Icon(
                    Icons.clear,
                    color: Colors.grey[600],
                    size: 20.sp,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        // Results count
        BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesLoaded) {
              final searchQuery = _searchController.text.trim().toLowerCase();
              final allCategories = state.categoriesResponse.categories;
              final filteredCount = searchQuery.isEmpty
                  ? allCategories.length
                  : allCategories.where((category) =>
                      category.name.toLowerCase().contains(searchQuery)).length;
              
              return Text(
                '$filteredCount results found',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey[600],
                ),
              );
            }
            return Text(
              'Loading...',
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey[600],
              ),
            );
          },
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _categoriesSection() {
    return Expanded(
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          print('CategoriesScreen: BlocBuilder state = ${state.runtimeType}');
          if (state is CategoriesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CategoriesLoaded) {
            // Get categories from state and filter based on search
            final allCategories = state.categoriesResponse.categories;
            final searchQuery = _searchController.text.trim().toLowerCase();
            final filteredCategories = searchQuery.isEmpty
                ? allCategories
                : allCategories.where((category) =>
                    category.name.toLowerCase().contains(searchQuery)).toList();
            
            if (filteredCategories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 15.w,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'No categories found',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Try searching with different keywords',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 3.h,
                childAspectRatio: 1.2,
              ),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return GestureDetector(
                  onTap: () => _navigateToProductsByCategory(category),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 0.5,
                          blurRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Category Image
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Image.network(
                                _getCategoryImageUrl(category.name),
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.grey[400],
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[100],
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_not_supported,
                                          size: 6.w,
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                          'Image not available',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.grey[500],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Category Name
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is CategoriesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 15.w,
                    color: Colors.red[400],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Error loading categories',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CategoriesCubit>().getCategories();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
} 