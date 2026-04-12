import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackingScreen extends ConsumerWidget{
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Distance Tracker'),),
      body: Center(
        child: Text('Tracking Screen'),
      ),
    );
  }
}