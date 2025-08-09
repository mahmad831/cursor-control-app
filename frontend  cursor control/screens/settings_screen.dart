import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _cursorSensitivity = 0.5;
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cursorSensitivity = prefs.getDouble('cursorSensitivity') ?? 0.5;
      _soundEnabled = prefs.getBool('soundEnabled') ?? true;
    });
  }

  _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('cursorSensitivity', _cursorSensitivity);
    await prefs.setBool('soundEnabled', _soundEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Cursor Sensitivity', style: TextStyle(fontSize: 18)),
            Slider(
              value: _cursorSensitivity,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              label: _cursorSensitivity.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _cursorSensitivity = value;
                });
                _saveSettings();
              },
            ),
            const Divider(),
            const Text('Controls', style: TextStyle(fontSize: 18)),
            const ListTile(
              title: Text('Cursor Movement'),
              subtitle: Text('Move your eyes to control the cursor.'),
            ),
            const ListTile(
              title: Text('Click Action'),
              subtitle: Text('Close your eyes for 2 seconds to click.'),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Sound for Eye Closing'),
              value: _soundEnabled,
              onChanged: (value) {
                setState(() {
                  _soundEnabled = value;
                });
                _saveSettings();
              },
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () {
                // This is where the eye-tracking loop would be initiated.
                // For demonstration, we'll just show a simple dialog.
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Start Cursor Movement'),
                    content: const Text('Eye-tracking mode has been activated!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Start Cursor Movement'),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // This would navigate to a detailed help screen.
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('User Manual'),
                    content: const Text('Detailed instructions on how to use the app.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('User Manual / Help'),
            ),
          ],
        ),
      ),
    );
  }
}
