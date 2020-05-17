
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterapp/helper/authenticate.dart';
import 'package:flutterapp/helper/constants.dart';
import 'package:flutterapp/helper/helperfunctions.dart';
import 'package:flutterapp/helper/theme.dart';
import 'package:flutterapp/services/auth.dart';
import 'package:flutterapp/services/database.dart';
import 'package:flutterapp/views/chat.dart';
import 'package:flutterapp/views/search.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}


class _ChatRoomState extends State<ChatRoom> {


  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;

  initiateSearch(String userName) async {
    if(userName.isNotEmpty){
      setState(() {

      });
      await databaseMethods.searchByName(searchEditingController.text)
          .then((snapshot){
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
      });
    }
  }

  Widget userList(){
    return ListView.builder(
        shrinkWrap: true,
        itemCount: searchResultSnapshot.documents.length,
        itemBuilder: (context, index){
          return Text(
            searchResultSnapshot.documents[index].data["fullName"],

          );
        });
  }

  Stream chatRooms;
  String fullName;


//
//  DatabaseMethods databaseMethods = new DatabaseMethods();
//  TextEditingController searchEditingController = new TextEditingController();
//  QuerySnapshot searchResultSnapshot;
//  initiateSearch(var userName) async {
//    searchEditingController = userName;
//      await databaseMethods.searchByName(searchEditingController.text)
//          .then((snapshot){
//        searchResultSnapshot = snapshot;
//        print("$searchResultSnapshot");
//        userList();
//      });
//
//  }
//Widget userList(){
//  return ListView.builder(
//      shrinkWrap: true,
//      itemCount: searchResultSnapshot.documents.length,
//      itemBuilder: (context, index){
//        return
//          searchResultSnapshot.documents[index].data["fullName"];
//
//
//      });
//}



  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          reverse: true,
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
                 //   fullName: searchResultSnapshot.documents[index].data["fullName"],
                  );
                })
            : Container();
      },
    );
  }


  @override
  void initState() {
    getUserInfogetChats();
    initiateSearch(Constants.myName);
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();

    print(Constants.myName);
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 40,
        ),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  static ChatRoom chatRoom = new ChatRoom();
  ChatRoomsTile({this.userName,@required this.chatRoomId});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Chat(
            chatRoomId: chatRoomId,
          )
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: CustomTheme.colorAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(fullName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
