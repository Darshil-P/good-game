import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 64,
            width: 64,
            margin: const EdgeInsets.symmetric(vertical: 32),
            child: const CircularProgressIndicator(),
          ),
          const Text(
            "Loading :)",
            style: TextStyle(fontSize: 24),
          )
        ],
      ),
    );
  }
}
