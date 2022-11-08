import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:async';

import 'package:persistence/screens/home_screen.dart';

class TakenPictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakenPictureScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<TakenPictureScreen> createState() => _TakenPictureScreenState();
}

class _TakenPictureScreenState extends State<TakenPictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Take a picture')),
        body: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final image = await _controller.takePicture();
              if (!mounted) return;

              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewScreen(
                      imagePath: image.path, passCamarados: widget.camera)));
            } catch (e) {
              print(e);
            }
          },
          child: const Icon(Icons.camera_alt),
        ));
  }
}

class NewScreen extends StatelessWidget {
  final String imagePath;
  final CameraDescription passCamarados;
  const NewScreen(
      {Key? key, required this.imagePath, required this.passCamarados})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Display the picture"),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Image.file(File(imagePath)),
          FloatingActionButton(
              child: const Icon(Icons.save),
              onPressed: () {
                print(imagePath);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                            passCamara: passCamarados, imgapath: imagePath)));
              })
        ]));
  }
}
