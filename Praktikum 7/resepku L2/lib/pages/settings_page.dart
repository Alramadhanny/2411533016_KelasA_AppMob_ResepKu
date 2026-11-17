import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/provider/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: SwitchListTile(
        title: const Text('Mode gelap'),
        subtitle: const Text('Aktifkan tema gelap aplikasi'),
        value: themeProvider.isDarkMode,
        onChanged: (value) {
          context.read<ThemeProvider>().setDarkMode(value);
        },
      ),
    );
  }
}