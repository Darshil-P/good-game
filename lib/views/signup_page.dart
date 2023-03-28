import 'package:flutter/material.dart';
import 'package:goodgame/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  String _emailError = "Invalid Email";
  String _usernameError = "Invalid Username";
  String _phoneError = "Invalid Phone";

  bool _invalidCredentials = true;
  bool _invalidUsername = false;
  bool _invalidEmail = false;
  bool _invalidPhone = false;
  bool _invalidPassword = false;
  bool _passwordMismatch = false;

  Future<bool> validateCredentials() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text;
    String rePassword = _rePasswordController.text;

    _invalidUsername = false;
    if (!RegExp(r'^[a-zA-Z\d_-]{3,32}$').hasMatch(username)) {
      _invalidUsername = true;
      _usernameError = "Invalid Username";
    }

    _invalidEmail = false;
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _invalidEmail = true;
      _emailError = "Invalid Email";
    }

    _invalidPhone = false;
    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      _invalidPhone = true;
      _phoneError = "Invalid Phone";
    }

    _invalidPassword = false;
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])(?!.* )[\w\W]{8,32}$')
        .hasMatch(password)) {
      _invalidPassword = true;
    }

    _passwordMismatch = false;
    if (password != rePassword) {
      _passwordMismatch = true;
    }

    if (!(_invalidUsername ||
        _invalidEmail ||
        _invalidPhone ||
        _invalidPassword ||
        _passwordMismatch)) {
      _invalidUsername = await isRegistered(credentialType: "username", value: username);
      _usernameError = "Username Already Taken";

      _invalidEmail = await isRegistered(credentialType: "email", value: email);
      _emailError = "Email Already Registered";

      _invalidPhone = await isRegistered(credentialType: "phone", value: "+91$phone");
      _phoneError = "Phone Already Registered";
    }

    setState(() {});

    return !(_invalidUsername ||
        _invalidEmail ||
        _invalidPhone ||
        _invalidPassword ||
        _passwordMismatch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUp Page"),
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
                  margin: const EdgeInsets.symmetric(vertical: 32),
                  child: const Text(
                    "Join GoodGame",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Visibility(
                  visible: (_invalidUsername || _invalidPassword),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.red,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Password Must Have:\n\n- Atleast 8 Characters\n- Atleast 1:\n    - Uppercase Letter\n    - Lowercase Letter\n    - Special Character\n    - Number",
                        ),
                        Text(
                          "Username Can Have:\n\n- Upto 32 Characters\n- Uppercase Letters\n- Lowercase Letters\n- Underscore (_)\n- Hyphen (-)\n- Numbers",
                        ),
                      ],
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
                  margin: const EdgeInsets.only(top: 32),
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      hintText: "Pick a Username",
                    ),
                    style: const TextStyle(fontSize: 24),
                    enabled: _invalidCredentials,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Visibility(
                    visible: _invalidUsername,
                    child: Text(
                      _usernameError,
                      style: const TextStyle(color: Color(0xffd53b3b)),
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
                  margin: const EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: "Email Address",
                    ),
                    style: const TextStyle(fontSize: 24),
                    enabled: _invalidCredentials,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Visibility(
                    visible: _invalidEmail,
                    child: Text(
                      _emailError,
                      style: const TextStyle(color: Color(0xffd53b3b)),
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
                  margin: const EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      hintText: "Phone Number",
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          "+91 ",
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xffcccccc),
                          ),
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 24),
                    enabled: _invalidCredentials,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Visibility(
                    visible: _invalidPhone,
                    child: Text(
                      _phoneError,
                      style: const TextStyle(color: Color(0xffd53b3b)),
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
                  margin: const EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                    style: const TextStyle(fontSize: 24),
                    enabled: _invalidCredentials,
                    obscureText: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Visibility(
                    visible: _invalidPassword,
                    child: const Text(
                      "Invalid Password",
                      style: TextStyle(color: Color(0xffd53b3b)),
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
                  margin: const EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: _rePasswordController,
                    decoration: const InputDecoration(
                      hintText: "Re-Enter Password",
                    ),
                    style: const TextStyle(fontSize: 24),
                    enabled: _invalidCredentials,
                    obscureText: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Visibility(
                    visible: _passwordMismatch,
                    child: const Text(
                      "Password Does not Match",
                      style: TextStyle(color: Color(0xffd53b3b)),
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
                        child: const Text("SignIn"),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                          child: const Text("Submit"),
                          onPressed: () async {
                            if (await validateCredentials()) {
                              setState(() {
                                _invalidCredentials = false;
                              });

                              await signUp(
                                context,
                                _usernameController.text.trim(),
                                _emailController.text.trim(),
                                "+91${_phoneController.text.trim()}",
                                _passwordController.text,
                              );
                            } else {
                              setState(() {
                                _invalidCredentials = true;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
