import 'package:camera_web/camera_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins(Registrar registrar) {
  CameraPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
