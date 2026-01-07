import 'package:e_commerceshoppingapp/cubits/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/product/product_cubit.dart';
import 'cubits/cart/cart_cubit.dart';
import 'cubits/theme/theme_cubit.dart';
import 'screens/home_screen.dart';
import 'utils/app_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductCubit()..loadProducts()),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'E-Commerce Shop',
            debugShowCheckedModeBanner: false,
            theme: themeState.isDarkMode
                ? AppStyles.darkTheme
                : AppStyles.lightTheme,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
