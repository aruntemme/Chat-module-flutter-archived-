import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/helper/constants.dart';
import 'package:flutterapp/services/database.dart';
import 'package:flutterapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chatrooms.dart';


class Chat extends StatefulWidget {
  final String chatRoomId;

  Chat({this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {


  final _firestore = Firestore.instance;
  ChatRoom chatRoom = ChatRoom();
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();

  Widget chatMessages(){
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
        .collection("chatRoom")
        .document(widget.chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
          final messages = snapshot.data.documents.reversed;
          List<MessageTile> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.data['message'];
            final messageSender = message.data['sendBy'];
            Constants.fullTime  = DateTime.fromMillisecondsSinceEpoch(message.data['time']);
            final messageBubble = MessageTile(
              message: messageText,
              sendByMe: Constants.myName == messageSender,
              time: Constants.myFullName.toString(),
            );

            messageBubbles.add(messageBubble);
          }

          return Expanded(
            child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                children: messageBubbles),
          );
        });

//      stream: chats,
//      builder: (context, snapshot){
//        return snapshot.hasData ?  ListView.builder(
//            reverse: true,
//          itemCount: snapshot.data.documents.length,
//            itemBuilder: (context, index){
//              return MessageTile(
//                message: snapshot.data.documents[index].data["message"],
//                sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
//              );
//            }) : Container();
//      },
//    );
  }

  addMessage() {
    Constants.currentTime = DateTime
        .now()
        .millisecondsSinceEpoch;

    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      Map<String, dynamic> time = {
        "time" :  DateTime
            .now()
            .millisecondsSinceEpoch,
      };
      DatabaseMethods().updateTime(time, widget.chatRoomId);
      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    chatMessages();
//    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
//      setState(() {
//         chats= val;
//      });
//    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    kPrimaryColor,
                    Color(0xFF67eaa4),
                  ])),
        ),
        title: Text(
          'BONTA',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
        child: Column(
          children: [
            Container(child: chatMessages()),

            Container(alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),topRight: Radius.circular(30.0)),
                  color: Color(0x95bcbcbc),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),

                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          style: TextStyle(
                            color: Colors.black,

                          ),
                          decoration: InputDecoration(
                              hintText: "Type a message ",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              border: InputBorder.none
                          ),
                        )),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {

                        addMessage();

                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    kPrimaryColor,
                                    Color(0xFF67eaa4),
                                    Color(0xFF48e9f2),
                                  ]),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/send.png",
                            height: 25, width: 25,)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String time;

  MessageTile({@required this.message, @required this.sendByMe, this.time});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Container(
            margin: sendByMe
                ? EdgeInsets.only(left: 30)
                : EdgeInsets.only(right: 30),
            padding: EdgeInsets.only(
                top: 17, bottom: 17, left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: sendByMe ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23)
                ) :
                BorderRadius.only(
            topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)),
                gradient: LinearGradient(
                  colors: sendByMe ? [
                    Colors.blue,
                    const Color(0xff2A75BC)
                  ]
                      : [
                    Color(0xffff716d),
                    Color(0xffffc371),
                  ],
                )
            ),
            child: Text(message,
                textAlign: TextAlign.start,
                style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
          ),
          Text(time)
        ],
      ),
    );
  }
}

