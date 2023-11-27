// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intune/intune.dart';

import 'intune_msal_config.dart';

const useMAM = false;

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
    setupMAM: useMAM,
  )
      .then((_) {
    print('ainfo: Did complete intune setup');
  }).catchError((e) {
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
  late final TextEditingController scopeTextController;

  void setGraphScope() {
    scopeTextController.text = 'https://graph.microsoft.com/user.read';
  }

  void setUserRead() {
    scopeTextController.text = 'user.read';
  }

  @override
  void initState() {
    super.initState();
    scopeTextController = TextEditingController(
      text: pref.getString('scope') ?? 'user.read',
    );
    scopeTextController.addListener(() {
      pref.setString('scope', scopeTextController.text.trim());
    });
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
    intune.pluginExceptionsStream.listen((event) {
      if (event == null) return;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(event.toString()),
        ),
      );
    });
    Future.microtask(() {
      _loginSilently();
    });
  }

  List<String> get scopes =>
      scopeTextController.text.split(',').map((e) => e.trim()).toList();

  void _loginSilently() async {
    await intuneInitializedFuture;
    final id = pref.getString('auth-user-id');
    if (id == null) return;
    intune.msal.acquireTokenSilently(
      AcquireTokenSilentlyParams(
        scopes: scopes,
        aadId: id,
      ),
    );
  }

  void _onLogin() {
    intune.msal.acquireToken(
      AcquireTokenParams(
        scopes: scopes,
      ),
    );
  }

  void copyText(String? text) async {
    final msg = ScaffoldMessenger.of(context);
    msg.removeCurrentSnackBar();
    if (text == null || text.isEmpty) {
      msg.showSnackBar(const SnackBar(content: Text('Nothing to copy')));
      return;
    }
    await Clipboard.setData(
      ClipboardData(
        text: text,
      ),
    );
    msg.showSnackBar(const SnackBar(content: Text('Copied')));
  }

  void copyToken() async {
    copyText(authDetails?.accessToken);
  }

  void copyIdToken() async {
    copyText(authDetails?.account.idToken);
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
        onSignout(oldAuthDetails.account.username, oldAuthDetails.account.id);
      }
    } on Exception catch (e) {
      print('failed to logout');
      print(e);
    }
  }

  @override
  void dispose() {
    scopeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            if (!isAuthenticated) ...[
              TextField(
                controller: scopeTextController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'https://graph.microsoft.com/user.read',
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: setGraphScope,
                    child: const Text('Graph Scope'),
                  ),
                  FilledButton(
                    onPressed: setUserRead,
                    child: const Text('Just user.read'),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: _onLogin,
                child: const Text('Login with MSAL'),
              ),
            ],
            if (isAuthenticated) ...[
              ListTile(
                onTap: copyToken,
                title: Text(
                  authDetails?.accessToken ?? 'No Token',
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: const Text('Access Token'),
                trailing: IconButton(
                  onPressed: copyToken,
                  icon: const Icon(Icons.copy_rounded),
                  tooltip: 'Copy token',
                ),
              ),
              ListTile(
                onTap: copyToken,
                title: Text(
                  authDetails?.account.idToken ?? 'No Token',
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: const Text('ID Token'),
                trailing: IconButton(
                  onPressed: copyIdToken,
                  icon: const Icon(Icons.copy_rounded),
                  tooltip: 'Copy ID Token',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _onLogout,
                child: const Text('Logout'),
              ),
              const SizedBox(
                height: 10,
              ),
              SelectableText(
                authDetails?.encode().toString() ?? 'No Auth Details',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void onMSALUserAccount(MSALUserAccount account) async {
  if (!useMAM) return;
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

void onSignout(String upn, String aadId) async {
  if (!useMAM) return;
  try {
    print('unregistering account for mam');
    // This may close the app
    final result = await intune.mam.unregisterAccountFromMAM(upn, aadId);
    print('did unregister account for mam: $result');
  } catch (e) {
    print('failed to unregister account for mam');
    print(e);
  }
}
