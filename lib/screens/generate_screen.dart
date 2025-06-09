import 'package:flutter/material.dart';

class GenerateScreen extends StatelessWidget {
  const GenerateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                color: Colors.red,
                child: const Text('QRコード表示', style: TextStyle(color: Colors.black54)),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                color: Colors.amber,
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter text',
                        ),
                        enabled: true,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 