import 'dart:convert';

import 'package:example/providers/account.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'intune/intune_android.dart';

final rootContainer = ProviderContainer();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupIntune();
  PlatformDispatcher.instance.onError = (e, s) {
    debugPrint(e.toString());
    debugPrintStack(stackTrace: s);
    return true;
  };
  runApp(
    ProviderScope(
      parent: rootContainer,
      child: const MyApp(),
    ),
  );
}

void setupIntune() {
  IntuneAndroid.registerWith();
  final app = rootContainer.read(publicClientApplicationProvider);
  app
      .updateConfiguration(
        publicClientApplicationConfiguration: pcaConfig,
      )
      .then((value) => print('pca created: $value'))
      .then((value) {
    final enrMgr = rootContainer.read(enrollmentManagerProvider);
    enrMgr.setAndroidReceiver(rootContainer.read(accountProvider.notifier));
    enrMgr
        .registerAuthentication()
        .then((value) => print('authentication registered: $value'));
  });
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

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      final aadid = await getAccountID();
      if (aadid == null) return null;
      final app = ref.read(publicClientApplicationProvider);
      app.signInSilentlyWithAccount(
        aadid,
        [
          'https://graph.microsoft.com/User.Read',
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(snackbarMessageProvider, (p, n) {
      if (p == n || n == null) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          n,
        ),
      ));
    });
    final account = ref.watch(accountProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              final app = ref.read(publicClientApplicationProvider);
              app
                  .signIn(AcquireTokenParams(
                scopes: ['https://graph.microsoft.com/User.Read'],
                authority:
                    'https://login.microsoftonline.com/330ab017-b6ba-4bcb-9fdd-46380820364a',
              ))
                  .then((value) {
                print('acquire token: $value');
              }).catchError((e, s) {
                print(e);
                debugPrintStack(stackTrace: s);
                ref
                    .read(snackbarMessageProvider.notifier)
                    .msg('Failed to login $e');
              });
            },
            child: const Text('Login'),
          ),
          ElevatedButton(
            onPressed: () {
              final a = ref.read(accountProvider)?.account;
              if (a == null) {
                return;
              }
              final app = ref.read(publicClientApplicationProvider);
              removeAccountID();
              app.signOut(a.id).then((value) {
                print('acquire token: $value');
                ref.read(snackbarMessageProvider.notifier).msg('Logged out');
              }).catchError((e, s) {
                print(e);
                debugPrintStack(stackTrace: s);
                ref
                    .read(snackbarMessageProvider.notifier)
                    .msg('Failed to logout $e');
              });
            },
            child: const Text('Logout'),
          ),
          const ListTile(
            title: Text('MAM MAMEnrollmentStatusResult'),
          ),
          SelectableText(
            ref.watch(enrollmentStatusProvider)?.result.toString() ?? '-',
          ),
          const ListTile(
            title: Text('MSAL User Auth details'),
          ),
          SelectableText(
            json.encode(account?.encode()),
          ),
        ],
      ),
    );
  }
}

final pcaConfig = {
  "authorities": [
    {
      "type": "AAD",
      "audience": {
        "type": "AzureADMyOrg",
        "tenant_id": "330ab017-b6ba-4bcb-9fdd-46380820364a"
      }
    }
  ],
  "client_id": "1211f54f-dceb-49a4-9425-68555720b104",
  "redirect_uri": "msauth://com.hdfc.irm/%2F56jD0%2FutKRWxj0sQxgm5d43G48%3D",
  "authorization_user_agent": "DEFAULT",
  "//authorization_user_agent": "WEBVIEW",
  "minimum_required_broker_protocol_version": "3.0",
  "multiple_clouds_supported": false,
  "broker_redirect_uri_registered": true,
  "environment": "Production",
  "http": {"connect_timeout": 10000, "read_timeout": 30000},
  "logging": {
    "pii_enabled": false,
    "log_level": "WARNING",
    "logcat_enabled": true
  },
  "account_mode": "MULTIPLE",
  "power_opt_check_for_network_req_enabled": true,
  "web_view_zoom_enabled": true,
  "web_view_zoom_controls_enabled": true,
  "handle_null_taskaffinity": false,
  "authorization_in_current_task": false,
  "browser_safelist": [
    {
      "browser_package_name": "com.android.chrome",
      "browser_signature_hashes": [
        "7fmduHKTdHHrlMvldlEqAIlSfii1tl35bxj1OXN5Ve8c4lU6URVu4xtSHc3BVZxS6WWJnxMDhIfQN0N0K2NDJg=="
      ],
      "browser_use_customTab": true,
      "browser_version_lower_bound": "45"
    },
    {
      "browser_package_name": "com.android.chrome",
      "browser_signature_hashes": [
        "7fmduHKTdHHrlMvldlEqAIlSfii1tl35bxj1OXN5Ve8c4lU6URVu4xtSHc3BVZxS6WWJnxMDhIfQN0N0K2NDJg=="
      ],
      "browser_use_customTab": false
    },
    {
      "browser_package_name": "org.mozilla.firefox",
      "browser_signature_hashes": [
        "2gCe6pR_AO_Q2Vu8Iep-4AsiKNnUHQxu0FaDHO_qa178GByKybdT_BuE8_dYk99G5Uvx_gdONXAOO2EaXidpVQ=="
      ],
      "browser_use_customTab": false
    },
    {
      "browser_package_name": "org.mozilla.firefox",
      "browser_signature_hashes": [
        "2gCe6pR_AO_Q2Vu8Iep-4AsiKNnUHQxu0FaDHO_qa178GByKybdT_BuE8_dYk99G5Uvx_gdONXAOO2EaXidpVQ=="
      ],
      "browser_use_customTab": true,
      "browser_version_lower_bound": "57"
    },
    {
      "browser_package_name": "com.sec.android.app.sbrowser",
      "browser_signature_hashes": [
        "ABi2fbt8vkzj7SJ8aD5jc4xJFTDFntdkMrYXL3itsvqY1QIw-dZozdop5rgKNxjbrQAd5nntAGpgh9w84O1Xgg=="
      ],
      "browser_use_customTab": true,
      "browser_version_lower_bound": "4.0"
    },
    {
      "browser_package_name": "com.sec.android.app.sbrowser",
      "browser_signature_hashes": [
        "ABi2fbt8vkzj7SJ8aD5jc4xJFTDFntdkMrYXL3itsvqY1QIw-dZozdop5rgKNxjbrQAd5nntAGpgh9w84O1Xgg=="
      ],
      "browser_use_customTab": false
    },
    {
      "browser_package_name": "com.cloudmosa.puffinFree",
      "browser_signature_hashes": [
        "1WqG8SoK2WvE4NTYgr2550TRhjhxT-7DWxu6C_o6GrOLK6xzG67Hq7GCGDjkAFRCOChlo2XUUglLRAYu3Mn8Ag=="
      ],
      "browser_use_customTab": false
    },
    {
      "browser_package_name": "com.duckduckgo.mobile.android",
      "browser_signature_hashes": [
        "S5Av4cfEycCvIvKPpKGjyCuAE5gZ8y60-knFfGkAEIZWPr9lU5kA7iOAlSZxaJei08s0ruDvuEzFYlmH-jAi4Q=="
      ],
      "browser_use_customTab": false
    },
    {
      "browser_package_name": "com.explore.web.browser",
      "browser_signature_hashes": [
        "BzDzBVSAwah8f_A0MYJCPOkt0eb7WcIEw6Udn7VLcizjoU3wxAzVisCm6bW7uTs4WpMfBEJYf0nDgzTYvYHCag=="
      ],
      "browser_use_customTab": false
    },
    {
      "browser_package_name": "com.ksmobile.cb",
      "browser_signature_hashes": [
        "lFDYx1Rwc7_XUn4KlfQk2klXLufRyuGHLa3a7rNjqQMkMaxZueQfxukVTvA7yKKp3Md3XUeeDSWGIZcRy7nouw=="
      ],
      "browser_use_customTab": false
    },
    {
      "browser_package_name": "com.microsoft.emmx",
      "browser_signature_hashes": [
        "Ivy-Rk6ztai_IudfbyUrSHugzRqAtHWslFvHT0PTvLMsEKLUIgv7ZZbVxygWy_M5mOPpfjZrd3vOx3t-cA6fVQ=="
      ],
      "browser_use_customTab": false
    },
    {
      "browser_package_name": "com.opera.browser",
      "browser_signature_hashes": [
        "FIJ3IIeqB7V0qHpRNEpYNkhEGA_eJaf7ntca-Oa_6Feev3UkgnpguTNV31JdAmpEFPGNPo0RHqdlU0k-3jWJWw=="
      ],
      "browser_use_customTab": false
    },
    {
      "browser_package_name": "com.opera.mini.native",
      "browser_signature_hashes": [
        "TOTyHs086iGIEdxrX_24aAewTZxV7Wbi6niS2ZrpPhLkjuZPAh1c3NQ_U4Lx1KdgyhQE4BiS36MIfP6LbmmUYQ=="
      ],
      "browser_use_customTab": false
    },
    {
      "browser_package_name": "mobi.mgeek.TunnyBrowser",
      "browser_signature_hashes": [
        "RMVoXuK1sfJZuGZ8onG1yhMc-sKiAV2NiB_GZfdNlN8XJ78XEE2wPM6LnQiyltF25GkHiPN2iKQiGwaO2bkyyQ=="
      ],
      "browser_use_customTab": false
    },
    {
      "browser_package_name": "org.mozilla.focus",
      "browser_signature_hashes": [
        "L72dT-stFqomSY7sYySrgBJ3VYKbipMZapmUXfTZNqOzN_dekT5wdBACJkpz0C6P0yx5EmZ5IciI93Q0hq0oYA=="
      ],
      "browser_use_customTab": false
    }
  ]
};
