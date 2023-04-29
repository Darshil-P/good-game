import 'package:flutter/material.dart';
import 'package:goodgame/services/auth_service.dart';

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
            child: Text(
              "GoodGame",
              style: TextStyle(fontSize: 48),
            ),
          ),
          ListTile(
            leading: const DrawerIcon("assets/icons/home.png"),
            title: const Text("Home Page"),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
          ListTile(
            leading: const DrawerIcon("assets/icons/search.png"),
            title: const Text("Search"),
            onTap: () {
              Navigator.pushNamed(context, "/search");
            },
          ),
          ListTile(
            leading: const DrawerIcon("assets/icons/signin.png"),
            title: const Text("Sign In"),
            onTap: () {
              Navigator.pushNamed(context, "/signIn");
            },
          ),
          ListTile(
            leading: const DrawerIcon("assets/icons/new_account.png"),
            title: const Text("Create Account"),
            onTap: () {
              Navigator.pushNamed(context, "/signUp");
            },
          ),
        ],
      ),
    );
  }
}

class UserAppDrawer extends StatelessWidget {
  const UserAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text(
              "GoodGame",
              style: TextStyle(fontSize: 48),
            ),
          ),
          ListTile(
            leading: const DrawerIcon("assets/icons/home.png"),
            title: const Text("Home Page"),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
          ListTile(
            leading: const DrawerIcon("assets/icons/search.png"),
            title: const Text("Search"),
            onTap: () {
              Navigator.pushNamed(context, "/search");
            },
          ),
          ListTile(
            leading: const DrawerIcon("assets/icons/profile.png"),
            title: const Text("Profile"),
            onTap: () {
              Navigator.pushNamed(context, "/profile");
            },
          ),
          ListTile(
            leading: const DrawerIcon("assets/icons/signout.png"),
            title: const Text("Sign Out"),
            onTap: () async {
              signOut().then((_) {
                Navigator.pushReplacementNamed(context, "/");
              });
            },
          ),
        ],
      ),
    );
  }
}
