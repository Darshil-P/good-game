import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Testing & Debugging",
              style: TextStyle(color: Colors.red),
            ),
            MaterialButton(
              onPressed: () {},
              color: Colors.red,
              child: const Text("Run"),
            )
          ],
        ),
      ),
    );
  }
}
