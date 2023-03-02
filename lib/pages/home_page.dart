import 'package:chatapp/helper/helper_functions.dart';
import 'package:chatapp/pages/auth/login_page.dart';
import 'package:chatapp/pages/profile_page.dart';
import 'package:chatapp/pages/search_page.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";
  String email = "";
  Stream? userStream;
  bool _isLoading = false;

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
    setState(() async {
      userStream = await DatabaseService(FirebaseAuth.instance.currentUser!.uid)
          .getUsersCollectionData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                nextScreen(
                    context, ProfilePage(username: username, email: email));
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text("Create a Group"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor))
                    : TextField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(15)),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      )
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text("CANCLE")),
              ElevatedButton(
                  onPressed: () {
                    
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text("CREATE")),
            ],
          );
        });
  }

  groupList() {
    return StreamBuilder(
      stream: userStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'].length > 0) {
            return Text("Has group");
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor));
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: const Center(child: Text("No Groups found")),
    );
  }
}
