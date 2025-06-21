import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';
import 'constants/app_constants.dart';
import 'screens/generate_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/log_view.dart';
import 'log/logger.dart';
import 'log/log_wrapper.dart';
import 'models/qr_data_provider.dart';
import 'providers/scan_provider.dart';
import 'providers/barcode_provider.dart';

// 1. ScreenModeの追加
enum ScreenMode { generate, scan }

void main(List<String> args) async {
  initLogging(args);
  logInfo('アプリケーションを起動します');
  
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const Size windowSize = AppConstants.windowSize;

  WindowOptions options = const WindowOptions(
    size: windowSize,
    minimumSize: windowSize,
    center: true,
    title: AppConstants.appName,
  );

  await windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.show();
    await windowManager.focus();
    logInfo('ウィンドウを表示しました: ${windowSize.width}x${windowSize.height}');
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QrDataProvider()),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => BarcodeProvider()),
      ],
      child: const MyApp(),
    ),
  );
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

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // モード状態を追加
  ScreenMode _mode = ScreenMode.generate;
  bool _logExpanded = false;

  void _switchMode(ScreenMode mode) {
    setState(() {
      _mode = mode;
    });
    logInfo('画面モードを切り替えました: ${mode.name}');
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
          if (!_logExpanded) ...[
            Expanded(child: screen),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _mode == ScreenMode.generate
                      ? null
                      : () {
                          logFine('Generateボタンが押されました');
                          _switchMode(ScreenMode.generate);
                        },
                  child: const Text('Generate'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _mode == ScreenMode.scan
                      ? null
                      : () {
                          logFine('Scanボタンが押されました');
                          _switchMode(ScreenMode.scan);
                        },
                  child: const Text('Scan'),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          if (_logExpanded)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LogView(
                  expanded: true,
                  onExpandChanged: (expanded) {
                    setState(() {
                      _logExpanded = expanded;
                    });
                  },
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LogView(
                expanded: false,
                onExpandChanged: (expanded) {
                  setState(() {
                    _logExpanded = expanded;
                  });
                },
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
