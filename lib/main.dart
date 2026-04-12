import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: DistanceTrackerApp()));
}

class DistanceTrackerApp  extends ConsumerWidget{
  const DistanceTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Distance Tracker',

    );
  }
}
