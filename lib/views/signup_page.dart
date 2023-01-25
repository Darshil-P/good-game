import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUp Page"),
        backgroundColor: const Color(0xff303030),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: const Text(
                  "Join GoodGame",
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
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Pick a Username",
                  ),
                  style: TextStyle(fontSize: 24),
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
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Email Address",
                  ),
                  style: TextStyle(fontSize: 24),
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
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                  ),
                  style: TextStyle(fontSize: 24),
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
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                  style: TextStyle(fontSize: 24),
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
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Re-Enter Password",
                  ),
                  style: TextStyle(fontSize: 24),
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
                        onPressed: () {},
                        child: const Text("Submit"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
