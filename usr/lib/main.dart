import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_strategy/url_strategy.dart'; // استيراد مكتبة استراتيجية الروابط
import 'screens/login_screen.dart';
import 'screens/main_layout.dart';
import 'theme/app_theme.dart';

void main() {
  // تفعيل استراتيجية المسار لإزالة # من روابط الويب
  setPathUrlStrategy();
  runApp(const SanadManagerApp());
}

class SanadManagerApp extends StatefulWidget {
  const SanadManagerApp({super.key});

  @override
  State<SanadManagerApp> createState() => _SanadManagerAppState();
}

class _SanadManagerAppState extends State<SanadManagerApp> {
  // إدارة الحالة العامة للتطبيق (اللغة، الثيم، المصادقة)
  Locale _locale = const Locale('ar');
  ThemeMode _themeMode = ThemeMode.system;
  bool _isAuthenticated = false;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void login() {
    setState(() {
      _isAuthenticated = true;
    });
  }

  void logout() {
    setState(() {
      _isAuthenticated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sanad Manager',
      debugShowCheckedModeBanner: false,
      // إعدادات الثيم (أزرق + برتقالي)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      
      // إعدادات اللغة
      locale: _locale,
      supportedLocales: const [
        Locale('ar', ''), // Arabic
        Locale('en', ''), // English
        Locale('fr', ''), // French
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // التوجيه
      initialRoute: '/',
      routes: {
        '/': (context) => _isAuthenticated 
            ? MainLayout(
                onLogout: logout, 
                onThemeChanged: toggleTheme, 
                onLanguageChanged: setLocale,
                currentLocale: _locale,
              ) 
            : LoginScreen(onLogin: login),
      },
    );
  }
}
