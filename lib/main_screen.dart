import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import 'base/constants/app_images.dart';
import 'feature/categories/presentation/screens/categories_screen.dart';
import 'feature/favourite/presentation/screens/favourites_screen.dart';
import 'feature/products/presentation/screens/products_screen.dart';
import 'feature/profile/presentation/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavouritesScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(3), // Adjust the radius as needed
          topRight: Radius.circular(3), // Adjust the radius as needed
        ),
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child:BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.black,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey[400],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedLabelStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppImages.product_icon,
                    width: 21, // Smaller width
                    height: 21, // Smaller height
                  ),
                  label: 'Products',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppImages.categories_icon,
                    width: 21, // Smaller width
                    height: 21, // Smaller height
                  ),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppImages.favourites_icon,
                    width: 21, // Smaller width
                    height: 21, // Smaller height
                  ),
                  label: 'Favourites',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppImages.profile_img,
                    width: 21, // Smaller width
                    height: 21, // Smaller height
                  ),
                  label: 'Profile',
                ),
              ],
            )
        ),
      ),
    );
  }
}
