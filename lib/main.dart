import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Age Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  void setAge(double newAge) {
    value = newAge.toInt();
    notifyListeners();
  }

  void increment() {
    if (value < 99) {
      value += 1;
      notifyListeners();
    }
  }

  void decrement() {
    if (value > 0) {
      value -= 1;
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // Determine message and background color based on age
  Map<String, dynamic> getAgeMilestone(int age) {
    if (age <= 12) {
      return {'message': "You're a child!", 'color': Colors.lightBlue};
    } else if (age <= 19) {
      return {'message': "Teenager time!", 'color': Colors.lightGreen};
    } else if (age <= 30) {
      return {'message': "You're a young adult!", 'color': Colors.yellow};
    } else if (age <= 50) {
      return {'message': "You're an adult now!", 'color': Colors.orange};
    } else if (age <= 68) {
      return {'message': "Golden years!", 'color': Colors.grey};
    } else {
      return {'message': "Enjor your retirement years!", 'color': Colors.pinkAccent};
    }
  }

  // Determine progress bar color based on age
  Color getProgressColor(int age) {
    if (age <= 33) {
      return Colors.green;
    } else if (age <= 67) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        var milestone = getAgeMilestone(counter.value);
        var progressColor = getProgressColor(counter.value);
        double progress = counter.value / 99; // Normalize to 0-1 for the progress bar

        return Scaffold(
          appBar: AppBar(
            title: const Text('Age Counter'),
          ),
          body: Container(
            color: milestone['color'], // Background color changes based on age
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    milestone['message'], // Milestone message
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'I am ${counter.value} years old', // Display age
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 20),

                  // Slider to adjust age
                  Slider(
                    value: counter.value.toDouble(),
                    min: 0,
                    max: 99,
                    divisions: 99,
                    label: counter.value.toString(),
                    onChanged: (double newAge) {
                      context.read<Counter>().setAge(newAge);
                    },
                    activeColor: Colors.blue, // Slider color
                    thumbColor: Colors.blue,
                  ),

                  const SizedBox(height: 20),

                  // Progress bar
                  Container(
                    width: 300,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[300], // Background color
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress, // Adjusts based on age
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: progressColor, // Changes color dynamically
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Adding Increase & Decrease Age Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Button color
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          context.read<Counter>().decrement();
                        },
                        child: const Text('Reduce Age', style: TextStyle(color: Colors.white),),
                      ),
                      const SizedBox(width: 20, height: 20,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Button color
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          context.read<Counter>().increment();
                        },
                        child: const Text('Increase Age', style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


