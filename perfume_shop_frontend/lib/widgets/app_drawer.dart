import 'package:flutter/material.dart';
import '../utils/app_state.dart';
import '../utils/constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppState().currentUser;

    return Drawer(
      child: Container(
        color: AppColors.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: user?.imagePath != null
                    ? AssetImage('assets/images/users/${user!.imagePath!.split('/').last}')
                    : null,
                child: user?.imagePath == null
                    ? const Icon(Icons.person, size: 40, color: AppColors.primary)
                    : null,
              ),
              accountName: Text(user?.username ?? 'Guest', style: const TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text(user?.email ?? ''),
              otherAccountsPictures: [
                IconButton(
                  icon: Icon(
                    AppState().isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: Colors.white,
                  ),
                  tooltip: 'Toggle Dark/Light Mode',
                  onPressed: () {
                    AppState().toggleDarkMode();
                    // Force rebuild
                    (context as Element).markNeedsBuild();
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.primary),
              title: const Text('All Perfumes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/perfumes');
              },
            ),
            ListTile(
              leading: const Icon(Icons.business, color: AppColors.primary),
              title: const Text('Brands'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/brands');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: AppColors.primary),
              title: const Text('Cart'),
              trailing: AppState().cartItemCount > 0
                  ? CircleAvatar(
                      backgroundColor: AppColors.accent,
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
              leading: const Icon(Icons.person, color: AppColors.primary),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: AppColors.primary),
              title: const Text('Order History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/orders');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
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
