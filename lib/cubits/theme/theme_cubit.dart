import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/cache_service.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final CacheService _cacheService = CacheService();

  ThemeCubit() : super(const ThemeState()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final isDark = await _cacheService.getDarkMode();
    final viewMode = await _cacheService.getViewMode();
    emit(state.copyWith(isDarkMode: isDark, viewMode: viewMode));
  }

  Future<void> toggleDarkMode() async {
    final newValue = !state.isDarkMode;
    emit(state.copyWith(isDarkMode: newValue));
    await _cacheService.setDarkMode(newValue);
  }

  Future<void> setViewMode(String mode) async {
    emit(state.copyWith(viewMode: mode));
    await _cacheService.setViewMode(mode);
  }
}
