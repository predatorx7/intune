import 'package:flutter/material.dart';
import 'package:intune/intune.dart';
import 'package:intune_android/messages.g.dart';

void main() {
  runApp(const MyApp());
}

class IntuneAndroidCallbackImpl extends IntuneAndroidCallback {
  @override
  Future<String?> acquireTokenSilent(
    String upn,
    String aadId,
    Iterable<String> scopes,
  ) {
    // TODO: implement acquireTokenSilent
    throw UnimplementedError();
  }

  @override
  void onEnrollmentNotification(String enrollmentResult) {
    print('enrollmentResult: $enrollmentResult');
  }

  @override
  void onUnexpectedEnrollmentNotification() {
    print('onUnexpectedEnrollmentNotification');
  }

  @override
  void onErrorType(MSALErrorResponse response) {
    // TODO: implement onErrorType
  }

  @override
  void onMsalException(MSALApiException exception) {
    // TODO: implement onMsalException
  }

  @override
  void onUserAuthenticationDetails(MSALUserAuthenticationDetails details) {
    final account = details.account;
    intune.registerAccount(
        account.username, account.id, account.tenantId, account.authority);
  }
}

late final Intune intune;

void setupIntune() {
  IntuneAndroid.registerWith();
  intune = Intune();
  intune.registerReceivers(IntuneAndroidCallbackImpl());
  intune.registerAuthentication();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intune Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Intune Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                intune.signIn(SignInParams(
                  scopes: ['https://graph.microsoft.com/User.Read'],
                  authority:
                      'msauth://com.hdfc.irm/%2F56jD0%2FutKRWxj0sQxgm5d43G48%3D',
                ));
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                //
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
