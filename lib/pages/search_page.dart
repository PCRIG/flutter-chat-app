import 'package:chatapp/helper/helper_functions.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  TextEditingController searchGroupController = TextEditingController();
  TextEditingController searchContactController = TextEditingController();
  late TabController tabController;

  bool _isLoading = false;
  QuerySnapshot? searchGroupList;
  List<Contact> searchContactList = [];
  String userName = '';
  String userId = '';
  bool isUserJoined = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
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
        bottom: TabBar(
          overlayColor: MaterialStateProperty.all(Colors.white12),
          indicatorColor: Colors.white,
          controller: tabController,
          tabs: <Widget>[
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.group),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Group")
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.contact_phone),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Contacts")
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          searchWidget(isGroup: true),
          searchWidget(isGroup: false),
        ],
      ),
    );
  }

  Widget searchWidget({required bool isGroup}) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(14),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller:
                      isGroup ? searchGroupController : searchContactController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type here...',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  isGroup ? initiateGroupSearch() : initiateContactSearch();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
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
            : isGroup
                ? groupList()
                : contactList(),
      ],
    );
  }

  initiateGroupSearch() async {
    if (searchGroupController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      await DatabaseService(FirebaseAuth.instance.currentUser!.uid)
          .searchGroup(searchGroupController.text)
          .then((value) {
        setState(() {
          searchGroupList = value;
          _isLoading = false;
        });
      });
      return;
    }
  }

  initiateContactSearch() async {
    if (await Permission.contacts.request().isGranted) {
      setState(() {
        _isLoading = true;
      });

      await ContactsService.getContacts(
              withThumbnails: false, query: searchContactController.text)
          .then((value) {
        setState(() {
          searchContactList = value;
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

  contactList() {
    return searchContactList.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchContactList.length,
            itemBuilder: ((context, index) {
              return contactTile(searchContactList[index].displayName ?? "",
                  searchContactList[index].phones?[0].value ?? "", userName);
            }))
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

  Widget contactTile(
      String contactName, String contactNumber, String userName) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          contactName.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ), 
      title: Text(contactName),
      subtitle: Text(contactNumber),
    );
  }

  Widget groupTile(
      String groupId, String groupName, String admin, String userName) {
    getGroupJoinData(groupId, groupName);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
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
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: const Text(
                  "Join",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}
