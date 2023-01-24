import 'package:flutter/material.dart';

class DrawerIcon extends StatelessWidget {
  final String path;

  const DrawerIcon(this.path, {super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Image(
        image: AssetImage(path),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text("GoodGame", style: TextStyle(fontSize: 48),),
          ),
          ListTile(
            leading: const DrawerIcon("assets/icons/home.png"),
            title: const Text("Home Page"),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/home");
            },
          ),
        ],
      ),
    );
  }
}
