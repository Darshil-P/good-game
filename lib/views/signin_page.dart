import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _credential = TextEditingController();
  final _password = TextEditingController();
  bool _formEnabled = true;
  bool _invalid = false;

  void validateAndAuthenticate() async {
    setState(() {
      _invalid = false;
      _formEnabled = false;
    });
    var type = validateCredentials();
    if (type != "invalid") {
      setState(() {
        _invalid = false;
        _formEnabled = false;
      });
      if (!await authenticate(context, type, _credential.text.trim(), _password.text)) {
        setState(() {
          _invalid = true;
          _formEnabled = true;
        });
      } else {
        Navigator.of(context).pushReplacementNamed("/");
      }
    } else {
      setState(() {
        _invalid = true;
        _formEnabled = true;
      });
    }
  }

  String validateCredentials() {
    String credential = _credential.text.trim();
    String password = _password.text;

    String valid = "invalid";
    if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(credential)) {
      valid = "email";
    } else if (RegExp(r'^[a-zA-Z\d_-]{3,32}$').hasMatch(credential)) {
      valid = "username";
    }

    if (RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[a-zA-Z\d\W_]{8,32}$')
        .hasMatch(password)) {
    } else {
      valid = "invalid";
    }

    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignIn Page"),
        backgroundColor: const Color(0xff303030),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  child: const Text(
                    "Sign In To GoodGame",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      width: 3,
                      color: Colors.white,
                    ),
                  )),
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                    controller: _credential,
                    decoration: const InputDecoration(
                      hintText: "Username Or Email",
                    ),
                    style: const TextStyle(fontSize: 24),
                    enabled: _formEnabled,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      width: 3,
                      color: Colors.white,
                    ),
                  )),
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                    style: const TextStyle(fontSize: 24),
                    enabled: _formEnabled,
                  ),
                ),
                Visibility(
                  visible: _invalid,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.red),
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Invalid Username, Email or Password!"),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueGrey,
                        ),
                        onPressed: () {},
                        child: const Text("Forgot Password"),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                            ),
                            onPressed: validateAndAuthenticate,
                            child: const Text("Submit")),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: const Text("Don't have an Account?"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {},
                  child: const Text("Join Now!"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
