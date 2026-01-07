import 'package:equatable/equatable.dart';

class ThemeState extends Equatable {
  final bool isDarkMode;
  final String viewMode;

  const ThemeState({this.isDarkMode = false, this.viewMode = 'grid'});

  ThemeState copyWith({bool? isDarkMode, String? viewMode}) {
    return ThemeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      viewMode: viewMode ?? this.viewMode,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, viewMode];
}
