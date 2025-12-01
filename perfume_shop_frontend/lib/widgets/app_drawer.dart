import 'package:flutter/material.dart';
import '../utils/app_state.dart';
import '../utils/constants.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = AppState().currentUser;

    return Drawer(
      child: Container(
        color: AppColors.background, // ✅ Dynamic color
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary), // ✅ Removed const
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: user?.imagePath != null
                    ? AssetImage('assets/images/users/${user!.imagePath!.split('/').last}')
                    : null,
                child: user?.imagePath == null
                    ? Icon(Icons.person, size: 40, color: AppColors.primary) // ✅ Removed const
                    : null,
              ),
              accountName: Text(user?.username ?? 'Guest', style: const TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text(user?.email ?? ''),
              otherAccountsPictures: [
                IconButton(
                  icon: Icon(
                    AppState().isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.white,
                  ),
                  tooltip: 'Toggle Dark/Light Mode',
                  onPressed: () {
                    setState(() {
                      AppState().toggleDarkMode();
                    });
                  },
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.home, color: AppColors.primary), // ✅ Removed const
              title: const Text('All Perfumes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/perfumes');
              },
            ),
            ListTile(
              leading: Icon(Icons.business, color: AppColors.primary), // ✅ Removed const
              title: const Text('Brands'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/brands');
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: AppColors.primary), // ✅ Removed const
              title: const Text('Cart'),
              trailing: AppState().cartItemCount > 0
                  ? CircleAvatar(
                      backgroundColor: AppColors.accent, // ✅ Dynamic color
                      radius: 12,
                      child: Text('${AppState().cartItemCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 10)),
                    )
                  : null,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cart');
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.person, color: AppColors.primary), // ✅ Removed const
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: AppColors.primary), // ✅ Removed const
              title: const Text('Order History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/orders');
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.error), // ✅ Removed const
              title: const Text('Logout'),
              onTap: () {
                AppState().clearUser();
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}