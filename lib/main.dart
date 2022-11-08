import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:persistence/screens/home_screen.dart';
import 'package:camera/camera.dart';
import 'package:persistence/screens/taken_picture_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(SqliteApp(firstCamera: firstCamera));
}

class SqliteApp extends StatelessWidget {
  final CameraDescription firstCamera;

  const SqliteApp({Key? key, required this.firstCamera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SQLite Example",
      initialRoute: "home",
      routes: {
        "home": (context) => HomeScreen(
              passCamara: firstCamera,
              imgapath: "",
            )
      },
      theme: ThemeData.light().copyWith(
          appBarTheme:
              const AppBarTheme(color: Color.fromARGB(255, 137, 69, 146))),
    );
  }
}
