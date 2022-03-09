import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  /// UI configurations.
  final BorderRadius _radius = BorderRadius.circular(10);

  /// Period configurations.
  Duration get _waitingDuration => const Duration(seconds: 5);

  List<Duration> get _periodDurations {
    return <Duration>[
      const Duration(seconds: 5),
      const Duration(seconds: 10),
      const Duration(seconds: 4),
      const Duration(seconds: 7),
      const Duration(seconds: 1),
    ];
  }

  int get currentPeriod => _currentPeriod.value;
  final ValueNotifier<int> _currentPeriod = ValueNotifier<int>(1);

  set currentPeriod(int value) => _currentPeriod.value = value;

  @override
  void initState() {
    super.initState();
    Future.delayed(_waitingDuration).then((_) => _callAnimation());
  }

  @override
  void reassemble() {
    super.reassemble();
    _restart();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _callAnimation() async {
    final Duration _currentDuration = _periodDurations[currentPeriod];
    currentPeriod++;
    final Duration? _nextDuration =
    currentPeriod < _periodDurations.length ? _periodDurations.last : null;
    final double target = currentPeriod / _periodDurations.length;
    await _controller.animateTo(target, duration: _currentDuration);
    if (_nextDuration == null) {
      currentPeriod = 0;
      return;
    }
    await _callAnimation();
  }

  void _restart() {
    _controller
      ..stop()
      ..reset();
    currentPeriod = 0;
    Future.delayed(_waitingDuration).then((_) => _callAnimation());
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '',
              style: TextStyle(
                fontSize: 200,
                color: Colors.white,
              ),
            ),

            Container(
              constraints: const BoxConstraints(maxWidth: 400,maxHeight: 10),
              child: ValueListenableBuilder<int> (
                valueListenable: _currentPeriod,
                builder: (_, int period, __) {
                  if (period == 0) {
                    return const SizedBox.shrink();
                  }
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (_, __) => LinearProgressIndicator(
                          value: _controller.value,
                          backgroundColor: CupertinoColors.lightBackgroundGray.withOpacity(.3) ,
                          color: Colors.white,
                          minHeight: 5,
                        ),
                      )
                  );
                }
              )
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



