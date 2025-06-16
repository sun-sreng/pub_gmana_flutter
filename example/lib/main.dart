import 'package:flutter/material.dart';
import 'package:gmana_flutter/gmana_flutter.dart';

import 'theme_mode_extensions.dart';
import 'theme_mode_service.dart';

void main() {
  runApp(const ThemeModeExampleApp());
}

/// The main application widget.
class ThemeModeExampleApp extends StatefulWidget {
  const ThemeModeExampleApp({super.key});

  @override
  ThemeModeExampleAppState createState() => ThemeModeExampleAppState();
}

/// State for the main application widget, managing theme mode.
class ThemeModeExampleAppState extends State<ThemeModeExampleApp> {
  ThemeMode _currentThemeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme Mode Example',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _currentThemeMode,
      home: const ThemeModeHomePage(),
    );
  }

  /// Updates the app's theme mode and triggers a rebuild.
  void updateThemeMode(ThemeMode newMode) {
    setState(() {
      _currentThemeMode = newMode;
    });
  }
}

/// The home page widget, displaying a theme mode selector.
class ThemeModeHomePage extends StatelessWidget {
  const ThemeModeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the app state to update theme mode
    final appState =
        context.findAncestorStateOfType<ThemeModeExampleAppState>()!;

    // Available theme mode keys from ThemeModeService
    final themeKeys =
        ThemeModeService()._themeConfigs.values
            .map((config) => config.key)
            .toList();

    // Get current theme mode from the app's theme
    final currentThemeMode =
        Theme.of(context).brightness == Brightness.dark &&
                Theme.of(context).platform != TargetPlatform.iOS
            ? ThemeMode.dark
            : ThemeMode.light;

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Mode Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display current theme icon and label
            Icon(currentThemeMode.toIcon(), size: 48),
            const SizedBox(height: 16),
            Text(
              currentThemeMode.toLabel(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            // Dropdown to select theme mode
            DropdownButton<String>(
              value: ThemeModeService()._themeConfigs[currentThemeMode]?.key,
              hint: const Text('Select Theme'),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  final newThemeMode = newValue.toThemeMode();
                  appState.updateThemeMode(newThemeMode);
                }
              },
              items:
                  themeKeys.map<DropdownMenuItem<String>>((String key) {
                    return DropdownMenuItem<String>(
                      value: key,
                      child: Row(
                        children: [
                          Icon(key.toThemeIcon()),
                          const SizedBox(width: 8),
                          Text(key.toThemeLabel()),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
