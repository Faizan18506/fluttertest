import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../favourite/presentation/cubit/favourite_state.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
import '../cubit/products_event.dart';
import '../../../favourite/presentation/cubit/favourite_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Load product details when screen initializes
    context.read<ProductsCubit>().getProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProductDetailsLoaded) {
              final product = state.product;
              return Column(
                children: [
                  _headerSection(),
                  _mainProductBanner(product),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _productInformationSection(product),
                          _productGallerySection(product),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is ProductDetailsError) {
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
                      'Error loading product details',
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
                        context.read<ProductsCubit>().getProductById(widget.productId);
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
      ),
    );
  }

  Widget _headerSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Product Details',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Removed favorite button from header - it will be in product details section
        ],
      ),
    );
  }

  Widget _mainProductBanner(dynamic product) {
    return Container(
      height: 28.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        // borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(20),
        //   bottomRight: Radius.circular(20),
        // ),
      ),
      child: Stack(
        children: [
          // Background product images
          if (product.images.isNotEmpty)
            Positioned(
              right: -5.w,
              top: 5.h,
              child: Container(
                width: 40.w,
                height: 30.h,
                child: Image.network(
                  product.images.first,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 10.w,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
          // Text content
          Positioned(
            left: 4.w,
            top: 5.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meet',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                // Brand logo/name
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.brand,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productInformationSection(dynamic product) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and favorite button
          Row(
            children: [
              Expanded(
                child: Text(
                  'Product Details:',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              BlocBuilder<FavouriteCubit, FavouriteState>(
                builder: (context, favouriteState) {
                  final isFavourite = context.read<FavouriteCubit>().isFavourite(product.id);
                  return IconButton(
                    onPressed: () {
                      if (isFavourite) {
                        context.read<FavouriteCubit>().removeFromFavourites(product);
                      } else {
                        context.read<FavouriteCubit>().addToFavourites(product);
                      }
                    },
                    icon: Icon(
                      isFavourite ? Icons.favorite : Icons.favorite_border,
                      color: isFavourite ? Colors.red : Colors.black,
                    ),
                  );
                },
              ),
            ],
          ),

          _detailRow('Name', product.title),
          _detailRow('Price', '\$${product.price.toStringAsFixed(2)}'),
          _detailRow('Category', product.category),
          _detailRow('Brand', product.brand),
          _detailRow('Rating', '${product.rating}', showStars: true, rating: product.rating),
          _detailRow('Stock', '${product.stock}'),

          Text(
            'Description:',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            product.description,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool showStars = false, double? rating}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          if (showStars && rating != null) ...[
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 1.w),
            Row(
              children: List.generate(5, (index) => 
                Icon(
                  Icons.star,
                  size: 16.sp,
                  color: index < rating.floor() 
                      ? Colors.amber 
                      : Colors.grey[300],
                ),
              ),
            ),
          ] else ...[
            Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[700],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _productGallerySection(dynamic product) {
    if (product.images.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Gallery:',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 1.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.2,
            ),
            itemCount: product.images.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),

                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.images[index],
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
                    errorBuilder: (context, error, stackTrace) => Center(
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
              );
            },
          ),
        ],
      ),
    );
  }
} 