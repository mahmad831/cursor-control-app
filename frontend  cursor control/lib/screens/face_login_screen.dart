import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../main.dart'; // Import cameras list

class FaceLoginScreen extends StatefulWidget {
  const FaceLoginScreen({super.key});

  @override
  _FaceLoginScreenState createState() => _FaceLoginScreenState();
}

class _FaceLoginScreenState extends State<FaceLoginScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String _status = 'Please position your face in the frame.';

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      cameras[1], // Use the front camera
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    
    // We would have a real face authentication logic here, but for now, 
    // we'll simulate a successful login after a few seconds.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _status = 'Authentication Successful!';
        });
        Navigator.pushReplacementNamed(context, '/settings');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face Login')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.center,
              children: [
                CameraPreview(_controller),
                Text(_status,
                    style: const TextStyle(color: Colors.white, fontSize: 20)),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
