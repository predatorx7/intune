import 'package:flutter/material.dart';
import 'package:intune/intune.dart';

import 'intune_msal_config.dart';

final intune = Intune();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  intune.authenticationStream.listen((event) {
    print('auth info: ${event?.accessToken}');
  });
  intune.enrollmentStatusStream.listen((event) {
    print('enrollment status: $event');
  });
  intune
      .setup(
    configuration: pcaConfig,
  )
      .then(
    (_) {
      print('ainfo: Did complete intune setup');
    },
  ).catchError((e) {
    print('aerror: $e');
    if (e is IntuneSetupException) {
      print(e.internalException);
      print(e.message);
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intune MSAL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MSAL Login Page'),
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
  void _onLogin() {
    intune.msal.acquireToken(
        AcquireTokenParams(scopes: ['https://graph.microsoft.com/user.read']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _onLogin,
              child: const Text('Login with MSAL'),
            ),
          ],
        ),
      ),
    );
  }
}
