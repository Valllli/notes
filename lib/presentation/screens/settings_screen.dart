import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListTile(
        title: const Text('Тёмная тема'),
        trailing: Switch(
          value: themeViewModel.isDark,
          onChanged: (value) => themeViewModel.toggleTheme(value),
        ),
      ),
    );
  }
}
