import 'package:flutter/material.dart';
import 'package:nyumba/account.dart';
import 'package:nyumba/providers/spesnow_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool _isLoggedIn = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return const Account();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: false,
        title: const Text(
          'LOGIN',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help),
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown),
                ),
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown),
                ),
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                  final email = emailController.text;
                  final password = passwordController.text;
                  await SpesnowProvider().login(email, password);
                  setState(() {
                    _isLoggedIn = true;
                  });
                },
                child: const Text('Login'),
              )),
        ],
      ),
    );
  }
}
