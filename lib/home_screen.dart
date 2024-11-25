import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'counter_provider.dart'; // Counter state management
import 'second_screen.dart'; // Second screen navigation
import 'theme_provider.dart'; // For dynamic theme management

// Provider to handle counter text color
final colorProvider = StateProvider<Color>((ref) => Colors.blue);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    final textColor = ref.watch(colorProvider);
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('Lalaguna_Final_Project'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              final newThemeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
              ref.read(themeProvider.notifier).state = newThemeMode;
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade100, Colors.purple.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Navigation Card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SecondScreen()),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: const [
                        Icon(Icons.navigate_next, size: 50, color: Colors.blue),
                        Text(
                          'Go to Second Screen',
                          style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Counter with animation and dynamic color
              Text(
                'You have pressed the button this many times:',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
              ),
              TweenAnimationBuilder(
                tween: IntTween(begin: 0, end: counter),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Text(
                    '$value',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: textColor),
                  );
                },
              ),
              const SizedBox(height: 30),
              // Buttons with gradient
              _buildGradientButton(
                context,
                ref,
                'Increment',
                () {
                  ref.read(counterProvider.notifier).state++;
                  _updateTextColor(ref, true);
                  _showSnackBar(context, 'Counter Incremented');
                },
                [Colors.blue, Colors.green],
              ),
              const SizedBox(height: 20),
              _buildGradientButton(
                context,
                ref,
                'Decrement',
                () {
                  ref.read(counterProvider.notifier).state--;
                  _updateTextColor(ref, false);
                  _showSnackBar(context, 'Counter Decremented');
                },
                [Colors.red, Colors.orange],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showDialog(context, counter),
                child: const Text('Show Counter Dialog'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showResetDialog(context, ref),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildGradientButton(BuildContext context, WidgetRef ref, String label, VoidCallback onPressed, List<Color> gradientColors) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(label),
        ),
      ),
    );
  }

  void _updateTextColor(WidgetRef ref, bool isIncrement) {
    final colors = [Colors.blue, Colors.green, Colors.red, Colors.purple, Colors.orange];
    final randomIndex = isIncrement ? 0 : colors.length - 1;
    ref.read(colorProvider.notifier).state = colors[randomIndex];
  }

  void _showDialog(BuildContext context, int counter) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Counter Alert'),
          content: Text('Current counter value: $counter'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Counter'),
          content: const Text('Are you sure you want to reset the counter?'),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(counterProvider.notifier).state = 0;
                ref.read(colorProvider.notifier).state = Colors.blue; // Reset color
                Navigator.pop(context);
                _showSnackBar(context, 'Counter Reset');
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
