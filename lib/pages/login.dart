import 'package:flutter/material.dart';
import 'package:spesnow/account.dart';
import 'package:spesnow/favorite.dart';
import 'package:spesnow/providers/spesnow_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.page});

  final String page;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool _isLoggedIn = false;

  String _page = "check";

  bool hide = true;

  @override
  void initState() {
    _page = widget.page;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      if (_page == "favorite") {
        return const Favorite();
      } else if (_page == "account") {
        return const Account();
      }
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: Column(
                children: const [
                   Text("SPESNOW",style: TextStyle(color: Colors.brown,fontWeight: FontWeight.bold,fontSize: 32),),
              Text("Rentals from verified landlords",style: TextStyle(color: Color.fromARGB(255, 124, 123, 123),),),
                ],
              ),
            ),
           
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.brown),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: const Icon(Icons.person),
                    hintText: "Email",
                    hintStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: passwordController,
                  obscureText: hide ? true : false,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.brown),
                    ),
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: hide ? IconButton(
                        onPressed: () {
                          setState(() {
                            hide = false;
                          });
                        },
                        icon: const Icon(Icons.remove_red_eye),) : 
                        IconButton(
                        onPressed: () {
                          setState(() {
                            hide = true;
                          });
                        },
                        icon: const Icon(Icons.remove_red_eye_outlined),),
                    hintStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final email = emailController.text;
                        final password = passwordController.text;
                        await SpesnowProvider().login(email, password);
                        setState(() {
                          _isLoggedIn = true;
                        });
                      },
                      child: const Text('LOGIN'),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an Account?", style: TextStyle(color:Colors.brown,fontSize: 12),),
                  TextButton(onPressed: (){}, child: const Text("Sign Up",style: TextStyle(fontWeight: FontWeight.bold),),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
