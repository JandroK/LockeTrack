import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locketrack/auth/auth_service.dart';
import 'package:locketrack/auth/register_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});
  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  void signIn() async {
    try {
      await authService.value.signIn(
        email: controllerEmail.text,
        password: controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'There is an error';
      });
    }
  }

  void popPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LockeTrack"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 60.0),
            const Text('Sign In', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 30.0),
            Form(
              key: formKey,
              child: Center(
                child: Column(
                  children: [
                    TextFormField(
                      controller: controllerEmail,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Field is empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: controllerPassword,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Field is empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RegisterPage();
                      },
                    ),
                  );
                },
                child: const Text('Register'),
              ),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        signIn();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    child: const Text('Sign In'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
