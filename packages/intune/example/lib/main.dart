// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intune/intune.dart';

import 'intune_msal_config.dart';

final intune = Intune();
late SharedPreferences pref;
late final Future<void> intuneInitializedFuture;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pref = await SharedPreferences.getInstance();
  intune.enrollmentStatusStream.listen((event) {
    print('enrollment status: $event');
  });
  intuneInitializedFuture = intune
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
  MSALUserAuthenticationDetails? authDetails;
  bool get isAuthenticated => authDetails != null;

  @override
  void initState() {
    super.initState();
    intune.authenticationStream.listen((event) {
      print('auth info: ${event?.accessToken}');
      if (event != null) {
        pref.setString('auth-user-id', event.account.id);
        onMSALUserAccount(event.account);
      }
      if (mounted) {
        setState(() {
          authDetails = event;
        });
      }
    });
    Future.microtask(() {
      _loginSilently();
    });
  }

  void _loginSilently() async {
    await intuneInitializedFuture;
    final id = pref.getString('auth-user-id');
    if (id == null) return;
    intune.msal.acquireTokenSilently(
      AcquireTokenSilentlyParams(
        scopes: ['https://graph.microsoft.com/user.read'],
        aadId: id,
      ),
    );
  }

  void _onLogin() {
    intune.msal.acquireToken(
      AcquireTokenParams(
        scopes: ['https://graph.microsoft.com/user.read'],
      ),
    );
  }

  void copyToken() {
    Clipboard.setData(
      ClipboardData(
        text: authDetails?.accessToken ?? 'no access token',
      ),
    );
  }

  void _onLogout() async {
    try {
      final id = pref.getString('auth-user-id');
      final result = await intune.msal.signOut(
        id,
        iosParameters: SignoutIOSParameters(
          prefersEphemeralWebBrowserSession: false,
          signoutFromBrowser: true,
        ),
      );
      print('logout: $result');
      final oldAuthDetails = authDetails;
      if (mounted) {
        setState(() {
          authDetails = null;
        });
      }
      if (oldAuthDetails != null) {
        onSignout(oldAuthDetails.account.username);
      }
    } on Exception catch (e) {
      print('failed to logout');
      print(e);
    }
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
            if (!isAuthenticated)
              ElevatedButton(
                onPressed: _onLogin,
                child: const Text('Login with MSAL'),
              ),
            if (isAuthenticated) ...[
              ElevatedButton(
                onPressed: copyToken,
                child: const Text('Copy Token'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _onLogout,
                child: const Text('Logout'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void onMSALUserAccount(MSALUserAccount account) async {
  try {
    print('registering account for mam');
    final result = await intune.mam.registerAccountForMAM(
      account.username,
      account.id,
      account.tenantId,
      account.authority,
    );
    print('did register account for mam: $result');
  } catch (e) {
    print('failed to register account for mam');
    print(e);
  }
}

void onSignout(String upn) async {
  try {
    print('unregistering account for mam');
    // This may close the app
    final result = await intune.mam.unregisterAccountFromMAM(upn);
    print('did unregister account for mam: $result');
  } catch (e) {
    print('failed to unregister account for mam');
    print(e);
  }
}
