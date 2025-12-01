// lib/main.dart
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
import 'config/theme_config.dart'; // ✅ Import
import 'utils/app_state.dart'; // ✅ Import

void main() {
  runApp(const PerfumeShopApp());
}

class PerfumeShopApp extends StatefulWidget {
  const PerfumeShopApp({super.key});

  @override
  State<PerfumeShopApp> createState() => _PerfumeShopAppState();
}

class _PerfumeShopAppState extends State<PerfumeShopApp> {
  // ✅ Static reference for rebuilding
  static _PerfumeShopAppState? _instance;

  @override
  void initState() {
    super.initState();
    _instance = this;

    // ✅ ADD THIS LINE
  AppState().onThemeChanged = () {
    setState(() {});
  };
  }

  @override
  void dispose() {
    _instance = null;
    super.dispose();
  }

  // ✅ Call this to toggle theme
  static void toggleTheme() {
    ThemeConfig.isDarkMode = !ThemeConfig.isDarkMode;
    _instance?.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elite Notes Perfume Shop',
      debugShowCheckedModeBanner: false,
      
      // ✅ Light Theme (your original colors)
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: const Color(0xFF6B4CE6),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6B4CE6),
          secondary: Color(0xFFFF6B9D),
          surface: Colors.white,
          background: Color(0xFFF8F9FA),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6B4CE6),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 2,
        ),
      ),
      
      // ✅ Dark Theme (new dark colors)
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF9C6FFF),
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF9C6FFF),
          secondary: Color(0xFFFF8AB5),
          surface: Color(0xFF1E1E1E),
          background: Color(0xFF121212),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF9C6FFF),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF1E1E1E),
          elevation: 2,
        ),
      ),
      
      // ✅ Switch between light and dark based on ThemeConfig
      themeMode: ThemeConfig.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
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