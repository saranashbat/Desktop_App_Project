// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_state.dart';
import '../utils/constants.dart';
import '../widgets/app_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppState().currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: AppColors.primary, // ✅ Dynamic color
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Please login first'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background, // ✅ Dynamic color
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primary, // ✅ Dynamic color
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration( // ✅ Removed const
                color: AppColors.primary, // ✅ Dynamic color
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppBorderRadius.lg),
                  bottomRight: Radius.circular(AppBorderRadius.lg),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: user.imagePath != null
                        ? AssetImage(
                            'assets/images/users/${user.imagePath!.split('/').last}')
                        : null,
                    child: user.imagePath == null
                        ? Icon(Icons.person, // ✅ Removed const
                            size: 60, color: AppColors.primary)
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    user.username,
                    style: AppTextStyles.h1.copyWith(color: Colors.white), // ✅ Dynamic style
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    user.email,
                    style: AppTextStyles.body.copyWith(color: Colors.white70), // ✅ Dynamic style
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  _buildMenuCard(
                    context,
                    icon: Icons.shopping_bag,
                    title: 'Order History',
                    subtitle: 'View your past and ongoing orders',
                    onTap: () {
                      Navigator.pushNamed(context, '/orders');
                    },
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.location_on,
                    title: 'Default Address',
                    subtitle: user.defaultAddress ?? 'No address set',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Address management coming soon')),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'Manage your account settings',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Settings coming soon')),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
                    iconColor: AppColors.error,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text(
                              'Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                AppState().clearUser();
                                Navigator.of(context).pop();
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/', (route) => false);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.error,
                              ),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor, // ✅ Changed to nullable
  }) {
    final color = iconColor ?? AppColors.primary; // ✅ Use dynamic default
    
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: AppTextStyles.h3), // ✅ Dynamic style
        subtitle: Text(subtitle, style: AppTextStyles.caption), // ✅ Dynamic style
        trailing: Icon(Icons.arrow_forward_ios, // ✅ Removed const
            size: 16, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}