import 'package:flutter/material.dart';
import 'package:flutter_test_app/access_token_dialog.dart';
import 'package:flutter_test_app/window_drag_area.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      themeMode: ThemeMode.dark,
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 96.0,
              child: DrawerHeader(
                decoration: BoxDecoration(),
                child: Text('ETA24™', style: TextStyle(color: Color.fromRGBO(0xff, 0x57, 0x22, 1))),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Navigator.pushNamed(context, '/settings');
              },
            ),
            // ... other navigation items
          ],
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: WindowDragArea(
                    maximizable: true,
                    child: Row(children: [
                      IconButton(
                          iconSize: 24,
                          icon: const Icon(Icons.menu),
                          onPressed: () async {
                            // Scaffold.of(context).openDrawer();
                            _scaffoldKey.currentState!.openDrawer();
                          }),
                      const Expanded(
                        child: Text("ETA Regulator Board Admin",
                            textAlign: TextAlign.center, style: TextStyle(color: Color.fromRGBO(0xff, 0x57, 0x22, 1), fontSize: 24)),
                      ),
                      IconButton(
                          iconSize: 24,
                          icon: const Icon(Icons.close),
                          onPressed: () async {
                            await windowManager.close();
                          }),
                    ]),
                  )),
                ],
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                child: const Text('Test'),
                onPressed: () => {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AccessTokenDialog(context: context);
                    },
                  )
                },
              )
            ],
          )),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
