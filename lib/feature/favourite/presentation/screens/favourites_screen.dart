import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../cubit/favourite_cubit.dart';
import '../cubit/favourite_state.dart';
import '../../../products/data/models/product_model.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _filteredFavourites = [];
  List<ProductModel> _allFavourites = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Load favourites when screen initializes
    context.read<FavouriteCubit>().loadFavourites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFavourites(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredFavourites = _allFavourites;
      } else {
        _filteredFavourites = _allFavourites.where((product) {
          final title = product.title.toLowerCase();
          final brand = product.brand.toLowerCase();
          final category = product.category.toLowerCase();
          final searchQuery = query.toLowerCase();
          
          return title.contains(searchQuery) ||
                 brand.contains(searchQuery) ||
                 category.contains(searchQuery);
        }).toList();
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
              _favouritesSection(),
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
            'Favourites',
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
                    hintText: 'Search favourites...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                  onChanged: _filterFavourites,
                ),
              ),
              if (_searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _filterFavourites('');
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
        BlocBuilder<FavouriteCubit, FavouriteState>(
          builder: (context, state) {
            if (state is FavouriteLoaded) {
              final totalCount = _isSearching ? _filteredFavourites.length : state.favourites.length;
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

  Widget _favouritesSection() {
    return Expanded(
      child: BlocBuilder<FavouriteCubit, FavouriteState>(
        builder: (context, state) {
          if (state is FavouriteInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FavouriteLoaded) {
            // Initialize all favourites if not already done
            if (_allFavourites.isEmpty) {
              _allFavourites = state.favourites;
              _filteredFavourites = _allFavourites;
            } else {
              // Update the lists when state changes
              _allFavourites = state.favourites;
              _filteredFavourites = _isSearching ? _filteredFavourites : _allFavourites;
            }
            
            final favouritesToShow = _isSearching ? _filteredFavourites : _allFavourites;
            
            if (favouritesToShow.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 15.w,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'No favourites found',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Your favourite items will appear here',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              itemCount: favouritesToShow.length,
              itemBuilder: (context, index) {
                final product = favouritesToShow[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 0.5,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Product Image (Circular)
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[100],
                        ),
                        child: ClipOval(
                          child: product.images.isNotEmpty
                              ? Image.network(
                                  product.images.first,
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
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 6.w,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 6.w,
                                    color: Colors.grey[400],
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                Text(
                                  product.rating.toString(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                Row(
                                  children: List.generate(5, (index) => 
                                    Icon(
                                      Icons.star,
                                      size: 12.sp,
                                      color: index < product.rating.floor() 
                                          ? Colors.amber 
                                          : Colors.grey[300],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Favorite Icon (Red filled heart)
                      IconButton(
                        onPressed: () {
                          context.read<FavouriteCubit>().removeFromFavourites(product);
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
} 