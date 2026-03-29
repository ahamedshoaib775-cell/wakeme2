import 'package:flutter/material.dart';
import 'tracking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WakeMe Stop")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Enter Destination Coordinates"),
            TextField(
              controller: _latController,
              decoration: const InputDecoration(labelText: "Latitude"),
            ),
            TextField(
              controller: _lngController,
              decoration: const InputDecoration(labelText: "Longitude"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double lat = double.parse(_latController.text);
                double lng = double.parse(_lngController.text);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrackingScreen(
                      destLat: lat,
                      destLng: lng,
                    ),
                  ),
                );
              },
              child: const Text("Start Tracking"),
            )
          ],
        ),
      ),
    );
  }
}
