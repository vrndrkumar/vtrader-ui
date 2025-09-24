import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'shared/services/storage_service.dart';
import 'shared/services/auth_service.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Temporarily disable problematic initialization
  try {
    // Initialize Hive for local storage
    await Hive.initFlutter();
    
    // Initialize storage service
    await StorageService.init();
    
    // Initialize auth service
    await AuthService.init();
  } catch (e) {
    print('Initialization error: $e');
    // Continue with app startup even if initialization fails
  }
  
  runApp(
    const ProviderScope(
      child: VTraderApp(),
    ),
  );
}

class VTraderApp extends ConsumerWidget {
  const VTraderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      
      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      
      // Router Configuration
      routerConfig: router,
      
      // Responsive Framework
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}

// Theme Mode Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  static const String _themeModeKey = 'theme_mode';

  void _loadThemeMode() async {
    final themeIndex = await StorageService.getInt(_themeModeKey);
    if (themeIndex != null) {
      state = ThemeMode.values[themeIndex];
    }
  }

  void setThemeMode(ThemeMode themeMode) async {
    state = themeMode;
    await StorageService.setInt(_themeModeKey, themeMode.index);
  }

  void toggleTheme() {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setThemeMode(newTheme);
  }
}

