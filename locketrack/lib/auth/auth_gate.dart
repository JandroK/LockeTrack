import 'package:flutter/material.dart';
import 'package:locketrack/auth/auth_service.dart';
import 'package:locketrack/auth/login_page.dart';

class AuthGate extends StatelessWidget {
  final Widget app;
  const AuthGate({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return MaterialApp(theme: ThemeData.dark(), home: LogInPage());
            }
            return app;
          },
        );
      },
    );
  }
}
