import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/theme/theme_cubit.dart';
import '../cubits/theme/theme_state.dart';
import '../utils/app_styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          body: Container(
            decoration: themeState.isDarkMode
                ? AppStyles.darkGradientBackground
                : AppStyles.gradientBackground,
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeState.isDarkMode
                            ? AppColors.darkBackground
                            : Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _buildPreferencesCard(context, themeState),
                            const SizedBox(height: 16),
                            _buildAboutCard(themeState),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard(BuildContext context, ThemeState themeState) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppStyles.cardDecoration(themeState.isDarkMode),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PREFERENCES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          _buildSettingTile(
            icon: themeState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            title: 'Dark Mode',
            subtitle: 'Change app theme',
            color: AppColors.primary,
            trailing: Switch(
              value: themeState.isDarkMode,
              onChanged: (value) {
                context.read<ThemeCubit>().toggleDarkMode();
              },
              activeThumbColor: AppColors.primary,
            ),
            isDark: themeState.isDarkMode,
          ),
          const Divider(height: 32),
          _buildSettingTile(
            icon: themeState.viewMode == 'list'
                ? Icons.view_list
                : Icons.grid_view,
            title: 'Default View',
            subtitle: 'List or Grid view',
            color: AppColors.secondary,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildViewModeButton(
                  context,
                  'list',
                  themeState.viewMode == 'list',
                ),
                const SizedBox(width: 8),
                _buildViewModeButton(
                  context,
                  'grid',
                  themeState.viewMode == 'grid',
                ),
              ],
            ),
            isDark: themeState.isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeButton(
    BuildContext context,
    String mode,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<ThemeCubit>().setViewMode(mode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          mode.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget trailing,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }

  Widget _buildAboutCard(ThemeState themeState) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppStyles.cardDecoration(themeState.isDarkMode),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ABOUT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Version',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: themeState.isDarkMode
                          ? AppColors.darkText
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'v1.0.0',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'E-Commerce Shopping App built with Flutter and Cubit state management. '
            'Browse products, add to cart, and enjoy a seamless shopping experience.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: themeState.isDarkMode
                  ? Colors.grey.shade400
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
