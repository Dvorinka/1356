import 'package:flutter/material.dart';

class HomeCountdownScreen extends StatelessWidget {
  const HomeCountdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeTimer'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '1356',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'days remaining',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 32),
            Text(
              'Your countdown starts here',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
