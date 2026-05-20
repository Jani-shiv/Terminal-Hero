import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/terminal_hero_app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure uncaught Flutter errors are forwarded to the current zone
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Forward to zone so runZonedGuarded handler receives it.
    Zone.current.handleUncaughtError(
        details.exception, details.stack ?? StackTrace.current);
  };

  // Provide a user-friendly error widget for build-time failures
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.redAccent, size: 56),
                  const SizedBox(height: 12),
                  const Text('An unexpected error occurred',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text('${details.exception}',
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  };

  await runZonedGuarded<Future<void>>(() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e, st) {
      // Keep local UI development possible before Firebase is configured
      // Log the error to console for diagnosis.
      debugPrint('Firebase.initializeApp failed: $e');
      debugPrint('$st');
    }

    runApp(const ProviderScope(child: TerminalHeroApp()));
  }, (Object error, StackTrace stack) {
    // Global uncaught error handler - log for diagnostics.
    // In a production app you would forward these to a remote crash reporter.
    debugPrint('Uncaught zone error: $error');
    debugPrint('$stack');
  });
}
