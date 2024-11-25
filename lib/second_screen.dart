import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class SecondScreen extends ConsumerStatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends ConsumerState<SecondScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _backgroundController;
  final List<String> _quotes = [
    "Keep pushing forward.",
    "Believe in yourself.",
    "The journey matters.",
    "Stay consistent.",
    "Success is no accident."
  ];
  String _currentQuote = "";

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    // Set initial random quote
    _showRandomQuote();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _showRandomQuote() {
    setState(() {
      _currentQuote = _quotes[Random().nextInt(_quotes.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.purple.withOpacity(0.5 + _backgroundController.value * 0.5), // Adjust opacity
                  Colors.orange,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentQuote,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showRandomQuote,
                    child: const Text('Show Another Quote'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
