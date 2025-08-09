import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _cameraPermissionGranted = false;
  bool _accessibilityPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  void _checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final accessibilityStatus = await Permission.speech.status; // Placeholder for accessibility
    setState(() {
      _cameraPermissionGranted = cameraStatus.isGranted;
      _accessibilityPermissionGranted = accessibilityStatus.isGranted;
    });
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _cameraPermissionGranted = status.isGranted;
    });
  }

  Future<void> _requestAccessibilityPermission() async {
    // This part requires platform-specific code. 
    // Here we use a placeholder and assume it's granted for demonstration.
    // Real implementation would involve opening system settings.
    setState(() {
      _accessibilityPermissionGranted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPermissionTile(
              'Camera',
              'Required to track eye movements.',
              _cameraPermissionGranted,
              _requestCameraPermission,
            ),
            const SizedBox(height: 20),
            _buildPermissionTile(
              'Accessibility',
              'Required to control the cursor and interact with the screen.',
              _accessibilityPermissionGranted,
              _requestAccessibilityPermission,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: (_cameraPermissionGranted && _accessibilityPermissionGranted)
                  ? () => Navigator.pushReplacementNamed(context, '/faceLogin')
                  : null,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile(String title, String subtitle, bool isGranted, Function() onPressed) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isGranted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : ElevatedButton(
                onPressed: onPressed,
                child: const Text('Grant'),
              ),
      ),
    );
  }
}
