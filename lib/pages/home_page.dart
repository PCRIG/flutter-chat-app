import 'package:chatapp/helper/helper_functions.dart';
import 'package:chatapp/pages/auth/login_page.dart';
import 'package:chatapp/pages/profile_page.dart';
import 'package:chatapp/pages/search_page.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    await HelperFunctions.getUserName().then((value) => {
          setState(() {
            username = value!;
          })
        });
    await HelperFunctions.getUserEmail().then((value) => {
          setState(() {
            email = value!;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
                onPressed: () {
                  nextScreen(context, const SearchPage());
                },
                icon: const Icon(Icons.search))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: [
              const Icon(Icons.account_circle, size: 150),
              const SizedBox(height: 8),
              Text(
                username,
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
                selected: true,
                selectedColor: Theme.of(context).primaryColor,
                onTap: () {},
              ),
              ListTile(
                title:
                    const Text("Profile", style: TextStyle(color: Colors.black)),
                leading: const Icon(Icons.person),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                onTap: () {
                  nextScreen(context, const ProfilePage());
                },
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
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                HelperFunctions.setUserLoggedInDetails(false, "", "");
                nextScreen(context, const LoginPage());
              },
              child: const Text("Logout")),
        ));
  }
}
