import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'screens/permission_screen.dart';
import 'screens/face_login_screen.dart';
import 'screens/settings_screen.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const EyeControlApp());
}

class EyeControlApp extends StatelessWidget {
  const EyeControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EyeControl',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PermissionScreen(),
        '/faceLogin': (context) => const FaceLoginScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
