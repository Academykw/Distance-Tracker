import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Route Map'),),
     body: Center(child: Text('Map view -flutter_map'),),
    );
  }
}
