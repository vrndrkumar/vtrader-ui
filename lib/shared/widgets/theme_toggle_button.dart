import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

/// Theme toggle button widget
class ThemeToggleButton extends ConsumerWidget {
  final bool showLabel;
  final double? iconSize;

  const ThemeToggleButton({
    super.key,
    this.showLabel = false,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeModeNotifier = ref.read(themeModeProvider.notifier);

    if (showLabel) {
      return TextButton.icon(
        onPressed: () => _showThemeMenu(context, themeModeNotifier),
        icon: Icon(_getThemeIcon(themeMode), size: iconSize),
        label: Text(_getThemeLabel(themeMode)),
      );
    }

    return IconButton(
      onPressed: () => _showThemeMenu(context, themeModeNotifier),
      icon: Icon(_getThemeIcon(themeMode), size: iconSize),
      tooltip: 'Theme: ${_getThemeLabel(themeMode)}',
    );
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  String _getThemeLabel(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeMenu(BuildContext context, ThemeModeNotifier notifier) {
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<ThemeMode>(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: ThemeMode.light,
          child: ListTile(
            leading: const Icon(Icons.light_mode),
            title: const Text('Light'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.dark,
          child: ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.system,
          child: ListTile(
            leading: const Icon(Icons.brightness_auto),
            title: const Text('System'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    ).then((selectedTheme) {
      if (selectedTheme != null) {
        notifier.setThemeMode(selectedTheme);
      }
    });
  }
}

