import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // استيراد Supabase
import 'screens/login_screen.dart';
import 'screens/main_layout.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تفعيل استراتيجية المسار لإزالة # من روابط الويب
  setPathUrlStrategy();

  // تهيئة Supabase
  // ملاحظة: يرجى استبدال YOUR_ANON_KEY بالمفتاح الحقيقي من إعدادات Supabase
  await Supabase.initialize(
    url: 'https://betsziqkhxevuqalrjtj.supabase.co',
    anonKey: 'YOUR_ANON_KEY_HERE', 
  );

  runApp(const SanadManagerApp());
}

class SanadManagerApp extends StatefulWidget {
  const SanadManagerApp({super.key});

  @override
  State<SanadManagerApp> createState() => _SanadManagerAppState();
}

class _SanadManagerAppState extends State<SanadManagerApp> {
  Locale _locale = const Locale('ar');
  ThemeMode _themeMode = ThemeMode.system;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    // التحقق من الجلسة الحالية عند بدء التطبيق
    _checkSession();
  }

  void _checkSession() {
    final session = Supabase.instance.client.auth.currentSession;
    setState(() {
      _isAuthenticated = session != null;
    });

    // الاستماع لتغيرات حالة المصادقة
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        setState(() => _isAuthenticated = true);
      } else if (event == AuthChangeEvent.signedOut) {
        setState(() => _isAuthenticated = false);
      }
    });
  }

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

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sanad Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: const [
        Locale('ar', ''),
        Locale('en', ''),
        Locale('fr', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => _isAuthenticated 
            ? MainLayout(
                onLogout: logout, 
                onThemeChanged: toggleTheme, 
                onLanguageChanged: setLocale,
                currentLocale: _locale,
              ) 
            : LoginScreen(onLogin: () {}), // LoginScreen handles navigation internally now via auth state listener
      },
    );
  }
}
