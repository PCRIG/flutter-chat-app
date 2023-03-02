import 'package:chatapp/helper/helper_functions.dart';
import 'package:chatapp/pages/auth/login_page.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  String username;
  String email;
  ProfilePage({super.key, required this.username, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: [
              const Icon(Icons.account_circle, size: 150),
              const SizedBox(height: 8),
              Text(
                widget.username,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Divider(height: 10),
              ListTile(
                title:
                    const Text("Groups", style: TextStyle(color: Colors.black)),
                leading: const Icon(Icons.group),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                onTap: () {
                  nextScreenReplacement(context, const HomePage());
                },
              ),
              ListTile(
                title:
                    const Text("Profile", style: TextStyle(color: Colors.black)),
                leading: const Icon(Icons.person),
                selected: true,
                selectedColor: Theme.of(context).primaryColor,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                onTap: () {},
              ),
              ListTile(
                title:
                    const Text("Logout", style: TextStyle(color: Colors.black)),
                leading: const Icon(Icons.exit_to_app),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                onTap: () {
                  HelperFunctions.setUserLoggedInDetails(false, "", "");
                  nextScreenReplacement(context, const LoginPage());
                },
              ),
            ],
          ),
        ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
        child: Column(children: [
        const Icon(Icons.account_circle, size: 200),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("UserName:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(widget.username, style: const TextStyle(fontSize: 18))
          ],
        ),
        const Divider(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Email:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(widget.email, style: const TextStyle(fontSize: 18))
          ],
        )
      ],)));
  }
}