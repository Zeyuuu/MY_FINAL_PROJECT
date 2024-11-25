import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'counter_provider.dart';
import 'second_screen.dart';
import 'theme_provider.dart';
import 'dart:math';


final colorProvider = StateProvider<Color>((ref) => Colors.blue);

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Final Project',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }
}

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
        title: const Text('Final Project'),
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
              const Text(
                'You have pressed the button this many times:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
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
              ElevatedButton(
                onPressed: () {
                  ref.read(counterProvider.notifier).state++;
                  _updateTextColor(ref);
                },
                child: const Text('Increment'),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(counterProvider.notifier).state--;
                  _updateTextColor(ref);
                },
                child: const Text('Decrement'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(counterProvider.notifier).state = 0;
          ref.read(colorProvider.notifier).state = Colors.blue;
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _updateTextColor(WidgetRef ref) {
    final colors = [Colors.blue, Colors.green, Colors.red, Colors.purple, Colors.orange];
    final randomColor = colors[Random().nextInt(colors.length)];
    ref.read(colorProvider.notifier).state = randomColor;
  }
}
