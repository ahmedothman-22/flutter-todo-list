import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tadweer/core/routing/routes.dart';
import 'package:tadweer/core/theme/app_colors/dark_app_colors.dart';
import 'package:tadweer/core/theme/app_texts/app_text_styles.dart';
import 'package:tadweer/features/home/presentation/widgets/profile_list_tile.dart';

class LogOut extends StatelessWidget {
  const LogOut({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return ProfileListTile(
      title: 'log out',
      onPressed: () async {
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Log Out',
              style: AppTextStyles.font12Regular.copyWith(
                color: DarkAppColors.primary800,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to log out?',
              style: AppTextStyles.font14Regular.copyWith(
                color: colorScheme.secondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red), // ميزناها بلون أحمر للوضوح
                ),
              ),
            ],
          ),
        );
        
        if (shouldLogout == true) {
          await FirebaseAuth.instance.signOut(); 
          if (context.mounted) {
            GoRouter.of(context).go(Routes.loginView); 
          }
        }
      },
      icon: Icons.logout,
    );
  }
}