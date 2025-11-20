import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class MainLayout extends StatefulWidget {
  final VoidCallback onLogout;
  final VoidCallback onThemeChanged;
  final Function(Locale) onLanguageChanged;
  final Locale currentLocale;

  const MainLayout({
    super.key,
    required this.onLogout,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.currentLocale,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const Center(child: Text('إدارة الطلبات (قريباً)')),
    const Center(child: Text('الموظفين (قريباً)')),
    const Center(child: Text('المخزون (قريباً)')),
    const Center(child: Text('الإعدادات (قريباً)')),
  ];

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 800;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.print, color: colorScheme.secondary),
            const SizedBox(width: 8),
            const Text('Sanad Manager', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          // زر تغيير اللغة
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String value) {
              widget.onLanguageChanged(Locale(value));
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'ar', child: Text('العربية')),
              const PopupMenuItem<String>(value: 'en', child: Text('English')),
              const PopupMenuItem<String>(value: 'fr', child: Text('Français')),
            ],
          ),
          // زر تغيير الثيم
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.light 
                ? Icons.dark_mode_outlined 
                : Icons.light_mode_outlined),
            onPressed: widget.onThemeChanged,
          ),
          // زر الخروج
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout,
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
      drawer: !isWideScreen ? _buildDrawer() : null,
      body: Row(
        children: [
          if (isWideScreen)
            SizedBox(
              width: 250,
              child: _buildDrawer(isPermanent: true),
            ),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer({bool isPermanent = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Drawer(
      elevation: isPermanent ? 0 : 16,
      child: Column(
        children: [
          if (!isPermanent)
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: colorScheme.primary),
              accountName: const Text('Admin User'),
              accountEmail: const Text('admin@sanad.dz'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40),
              ),
            ),
          Expanded(
            child: ListView(
              padding: isPermanent ? const EdgeInsets.only(top: 20) : EdgeInsets.zero,
              children: [
                _buildNavItem(0, 'لوحة التحكم', Icons.dashboard),
                _buildNavItem(1, 'الطلبات', Icons.shopping_cart),
                _buildNavItem(2, 'الموظفين', Icons.people),
                _buildNavItem(3, 'المخزون', Icons.inventory),
                const Divider(),
                _buildNavItem(4, 'الإعدادات', Icons.settings),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String title, IconData icon) {
    final isSelected = _selectedIndex == index;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        icon, 
        color: isSelected ? colorScheme.secondary : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? colorScheme.primary : null,
        ),
      ),
      selected: isSelected,
      selectedTileColor: colorScheme.primary.withOpacity(0.1),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        if (Scaffold.of(context).hasDrawer && Scaffold.of(context).isDrawerOpen) {
          Navigator.pop(context);
        }
      },
    );
  }
}
