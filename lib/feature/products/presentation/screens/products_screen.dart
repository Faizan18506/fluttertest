import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../data/models/products_response_model.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
import '../cubit/products_event.dart';
import 'product_details_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredProducts = [];
  List<dynamic> _allProducts = [];
  bool _isSearching = false;
  ProductsResponseModel? _cachedProductsResponse;

  @override
  void initState() {
    super.initState();
    // _searchController.text = 'iphone';
    print('ProductsScreen: initState() called');
    // Load products when screen initializes
    context.read<ProductsCubit>().getProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((product) {
          final title = product.title.toString().toLowerCase();
          final brand = product.brand.toString().toLowerCase();
          final category = product.category.toString().toLowerCase();
          final searchQuery = query.toLowerCase();
          
          return title.contains(searchQuery) ||
                 brand.contains(searchQuery) ||
                 category.contains(searchQuery);
        }).toList();
      }
    });
  }

  void _navigateToProductDetails(dynamic product) {
    print('ProductsScreen: Navigating to product details for product ${product.id}');
    // Cache the current products response before navigating
    if (_cachedProductsResponse != null) {
      print('ProductsScreen: Cached products response available');
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          productId: product.id,
        ),
      ),
    ).then((_) {
      print('ProductsScreen: Returned from ProductDetailsScreen');
      // Restore the products state when returning from product details
      if (_cachedProductsResponse != null) {
        print('ProductsScreen: Restoring products state');
        context.read<ProductsCubit>().restoreProductsState(_cachedProductsResponse!);
      } else {
        print('ProductsScreen: No cached products response, calling getProducts()');
        context.read<ProductsCubit>().getProducts();
      }
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
              _productsSection(),
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
            'Products',
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
          padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.sp),
            border: Border.all(
              color: Colors.black,
              width: 0.5.sp,
            )
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
                    hintText: 'Search products...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                  onChanged: _filterProducts,
                ),
              ),
              if (_searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _filterProducts('');
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
        BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            print('ProductsScreen: BlocBuilder state = ${state.runtimeType}');
            if (state is ProductsLoaded) {
              final totalCount = _isSearching ? _filteredProducts.length : state.productsResponse.total;
              return Text(
                '$totalCount results found',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey[600],
                ),
              );
            }
            return Text(
              'Loading...',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            );
          },
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _productsSection() {
    return Expanded(
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          print('ProductsScreen: _productsSection BlocBuilder state = ${state.runtimeType}');
          
          if (state is ProductsLoading) {
            print('ProductsScreen: Showing loading indicator');
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProductsLoaded) {
            print('ProductsScreen: ProductsLoaded state, products count: ${state.productsResponse.products.length}');
            // Cache the products response
            _cachedProductsResponse = state.productsResponse;
            
            // Initialize all products if not already done
            if (_allProducts.isEmpty) {
              _allProducts = state.productsResponse.products;
              _filteredProducts = _allProducts;
              print('ProductsScreen: Initialized _allProducts with ${_allProducts.length} products');
            }
            
            final productsToShow = _isSearching ? _filteredProducts : _allProducts;
            
            if (productsToShow.isEmpty) {
              print('ProductsScreen: No products to show');
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
                      'No products found',
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
            
            print('ProductsScreen: Building ListView with ${productsToShow.length} products');
            return ListView.builder(
              itemCount: productsToShow.length,
              itemBuilder: (context, index) {
                final product = productsToShow[index];
                return GestureDetector(
                  onTap: () => _navigateToProductDetails(product),
                  child: Container(
                  margin: EdgeInsets.only(bottom: 3.h),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Container(
                        height: 25.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          color: Colors.grey[100],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: product.images.isNotEmpty
                              ? Image.network(
                                  product.images.first,
                                  fit: BoxFit.contain,
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
                                  errorBuilder: (context, error, stackTrace) => Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_not_supported,
                                          size: 10.w,
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          'Image not available',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported,
                                        size: 10.w,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(height: 1.h),
                                      Text(
                                        'No image',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      // Product Details
                      Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and Price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    product.title,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            // Rating
                            Row(
                              children: [
                                Text(
                                  product.rating.toString(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                Row(
                                  children: List.generate(5, (index) => 
                                    Icon(
                                      Icons.star,
                                      size: 16.sp,
                                      color: index < product.rating.floor() 
                                          ? Colors.amber 
                                          : Colors.grey[300],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            // Product info
                            Text(
                              'By ${product.brand}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'In ${product.category}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
              },
            );
          } else if (state is ProductsError) {
            print('ProductsScreen: ProductsError state: ${state.message}');
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
                    'Error loading products',
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
                      context.read<ProductsCubit>().getProducts();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is ProductDetailsLoading || state is ProductDetailsLoaded || state is ProductDetailsError) {
            print('ProductsScreen: In product details state, showing loading');
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          print('ProductsScreen: Unknown state, showing empty');
          return const SizedBox.shrink();
        },
      ),
    );
  }
} 