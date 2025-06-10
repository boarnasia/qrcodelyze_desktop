import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'screens/generate_screen.dart';
import 'screens/scan_screen.dart';

// 1. ScreenModeの追加
enum ScreenMode { generate, scan }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: AppConstants.appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 2. モード状態を追加
  ScreenMode _mode = ScreenMode.generate;

  void _switchMode(ScreenMode mode) {
    setState(() {
      _mode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;
    switch (_mode) {
      case ScreenMode.generate:
        screen = const GenerateScreen();
        break;
      case ScreenMode.scan:
        screen = const ScanScreen();
        break;
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: screen),
          // 3. 画面下部に切り替えボタン
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _mode == ScreenMode.generate
                    ? null
                    : () => _switchMode(ScreenMode.generate),
                child: const Text('Generate'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _mode == ScreenMode.scan
                    ? null
                    : () => _switchMode(ScreenMode.scan),
                child: const Text('Scan'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
