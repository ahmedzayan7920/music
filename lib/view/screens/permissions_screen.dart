import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../di/dependency_injection.dart';
import 'home_screen.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({Key? key}) : super(key: key);

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen>
    with WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _comeFromSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkAndRequestPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && _comeFromSettings) {
      final status = await getIt<OnAudioQuery>().permissionsStatus();
      if (status) {
        _goNext();
      } else {
        setState(() {});
      }
    }
  }

  Future<void> checkAndRequestPermissions({bool retry = false}) async {
    try {
      final status = await getIt<OnAudioQuery>().permissionsStatus();
      if (status) {
        _goNext();
      } else {
        _hasPermission = await getIt<OnAudioQuery>().permissionsRequest(
          retryRequest: retry,
        );
        if (_hasPermission) {
          _goNext();
        } else {
          checkAndRequestPermissions(retry: true);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  void _goNext() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Permissions Screen"),
        elevation: 2,
        centerTitle: true,
      ),
      body: Center(
        child: !_hasPermission
            ? Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning,
                      size: 100,
                      color: Colors.redAccent.withOpacity(0.8),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Permission Denied",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Please open settings and enable permissions to continue using the app.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _goToSettings,
                      icon: const Icon(Icons.settings),
                      label: const Text("Open Settings"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  void _goToSettings() async {
    if (Platform.isAndroid) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final packageName = packageInfo.packageName;
      final intent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:$packageName',
      );
      await intent.launch();
      _comeFromSettings = true;
    }
  }
}
