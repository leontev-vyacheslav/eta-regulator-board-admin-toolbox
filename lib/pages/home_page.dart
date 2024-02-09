import 'package:flutter/material.dart';
import 'package:flutter_test_app/components/window_title_bar.dart';
import 'package:flutter_test_app/components/app_drawer.dart';
import 'package:flutter_test_app/dialogs/access_token_dialog.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      drawer: AppDrawer(context: context),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              WindowTitleBar(scaffoldKey: _scaffoldKey),
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
                      return AccessTokenDialog(context: context, titleText: 'Create access token');
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
      ),
    );
  }
}
