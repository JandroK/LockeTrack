import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locketrack/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  void register() async {
    try {
      await authService.value.createAccount(
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
      appBar: AppBar(
        title: const Text("LockeTrack"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            popPage();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 60.0),
            const Text('Register', style: TextStyle(fontSize: 40)),
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
            Spacer(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        register();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    child: const Text('Register'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
