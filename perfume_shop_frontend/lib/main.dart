import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/perfume_list_screen.dart';
import 'screens/brand_list_screen.dart';
import 'screens/brand_perfumes_screen.dart';
import 'screens/perfume_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/profile_screen.dart';
import 'models/brand.dart';
import 'models/perfume.dart';
import 'utils/constants.dart';
import 'utils/app_state.dart';

void main() {
  runApp(const PerfumeShopApp());
}

class PerfumeShopApp extends StatefulWidget {
  const PerfumeShopApp({super.key});

  @override
  State<PerfumeShopApp> createState() => _PerfumeShopAppState();
}

class _PerfumeShopAppState extends State<PerfumeShopApp> {
  // Static reference to rebuild the app
  static _PerfumeShopAppState? _instance;

  @override
  void initState() {
    super.initState();
    _instance = this;
  }

  @override
  void dispose() {
    _instance = null;
    super.dispose();
  }

  // Method to rebuild the entire app
  static void rebuild() {
    _instance?.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elite Notes Perfume Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryDark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      themeMode: AppState().isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const LoginScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/perfumes':
            return MaterialPageRoute(builder: (_) => const PerfumeListScreen());
          case '/brands':
            return MaterialPageRoute(builder: (_) => const BrandListScreen());
          case '/brand-perfumes':
            final brand = settings.arguments as Brand;
            return MaterialPageRoute(builder: (_) => BrandPerfumesScreen(brand: brand));
          case '/perfume-detail':
            final perfume = settings.arguments as Perfume;
            return MaterialPageRoute(builder: (_) => PerfumeDetailScreen(perfume: perfume));
          case '/cart':
            return MaterialPageRoute(builder: (_) => const CartScreen());
          case '/checkout':
            return MaterialPageRoute(builder: (_) => const CheckoutScreen());
          case '/orders':
            return MaterialPageRoute(builder: (_) => const OrderHistoryScreen());
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          default:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
      },
    );
  }
}