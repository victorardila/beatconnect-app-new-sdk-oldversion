import 'package:flutter/material.dart';
import 'package:beatconnect_new_sdk_oldversion/lib.dart';

class BackgroundConfigPage extends StatelessWidget {
  const BackgroundConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuración de fondo"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: WallpaperTabView(),
      ),
    );
  }
}
