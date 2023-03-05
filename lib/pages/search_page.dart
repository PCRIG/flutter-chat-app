import 'package:chatapp/helper/helper_functions.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  QuerySnapshot? searchGroupList;
  String userName = '';
  String userId = '';
  bool isUserJoined = false;

  @override
  void initState() {
    super.initState();
    getUserNameAndId();
  }

  getUserNameAndId() async {
    await HelperFunctions.getUserName().then((value) => {userName = value!});
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  getGroupName(String data) {
    return data.substring(data.indexOf('_') + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Group'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(children: [
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              border:
                  Border.all(width: 1, color: Theme.of(context).primaryColor),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type here...',
                      hintStyle: TextStyle(color: Colors.black)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  initiateSearch();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: const Icon(Icons.search, color: Colors.white),
                ),
              )
            ],
          ),
        ),
        _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
              )
            : groupList()
      ]),
    );
  }

  initiateSearch() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      await DatabaseService(FirebaseAuth.instance.currentUser!.uid)
          .searchGroup(searchController.text)
          .then((value) {
        setState(() {
          searchGroupList = value;
          _isLoading = false;
        });
      });
    }
  }

  groupList() {
    return searchGroupList != null && searchGroupList!.docs.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchGroupList!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                  searchGroupList!.docs[index]['groupId'],
                  searchGroupList!.docs[index]['groupName'],
                  searchGroupList!.docs[index]['admin'],
                  userName);
            },
          )
        : Container();
  }

  getGroupJoinData(String groupId, String groupName) async {
    await DatabaseService(FirebaseAuth.instance.currentUser!.uid)
        .isUserJoined(groupId, groupName)
        .then((value) => {
              setState((() {
                isUserJoined = value;
              }))
            });
  }

  joinGroup(String groupId, String groupName) async {
    await DatabaseService(FirebaseAuth.instance.currentUser!.uid)
        .joinGroup(groupId, groupName, userName)
        .then((value) {
      setState(() {
        isUserJoined = true;
      });
      showSnackBar(context, "Joined the group sucessfully", Colors.green);
      Future.delayed(const Duration(seconds: 2)).then((value) => {
            nextScreen(
                context,
                ChatPage(
                    groupId: groupId, groupName: groupName, userName: userName))
          });
    });
  }

  Widget groupTile(
      String groupId, String groupName, String admin, String userName) {
    getGroupJoinData(groupId, groupName);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(groupName.substring(0, 1).toUpperCase(),
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25)),
      ),
      title: Text(groupName),
      subtitle: Text("Admin: ${getGroupName(admin)}"),
      trailing: InkWell(
          onTap: () {
            joinGroup(groupId, groupName);
          },
          child: isUserJoined
              ? Container(
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: const Text("Joined",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)))
              : Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: const Text("Join",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)))),
    );
  }
}
