import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversationscreen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchText = new TextEditingController();
  QuerySnapshot searchSnapshot;
  bool userNotFound = false;
  String error = '';
  bool isloading = false;

  initiateSearch() async {
    print('Searching for user.......');
    QuerySnapshot val =
        await Database.getUserByUsername(searchText.text.trim());
    print('Search completed');
    print('Search result : ${val.documents}');
    setState(() {
      isloading = false;
      searchSnapshot = val;
      if (searchText.text == Constants.myName) {
        userNotFound = true;
        error = 'Nice try, but you cannot chat with yourself';
      } else {
        if (val.documents.length == 0) {
          error = 'User not found';
          if (searchText.text.isEmpty) {
            error = ' ';
          } else {
            userNotFound = true;
          }
        } else {
          userNotFound = false;
        }
      }
    });
  }

  createChatRoomAndStartChatting(String username, BuildContext context) async {
    print('Inside createChatRoomAndStartChatting function');
    List<String> users = [username, Constants.myName];
    String chatRoomID = getChatRoomId(username, Constants.myName);
    print('Chat room ID is $chatRoomID');
    Map<String, dynamic> chatRoomMap = {
      'users': users,
      'chatroomid': chatRoomID,
    };
    print('Map created $chatRoomMap');
    print('Creating chatroom.........');

    await Database.createChatRoom(chatRoomID, chatRoomMap);

    print('Chatroom created');
    print('Preparing to push to new screen.......');
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomID, username),
        )).catchError((e) {
      print('The error is : ${e.toString()}');
    });
    print('Pushed to new screen');
  }

  getChatRoomId(String a, String b) {
    print('$a, $b');
    String id;
    if (a.length > b.length) {
      id = '$b\_$a';
    } else {
      id = '$a\_$b';
    }
    return id;
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.documents.length,
            itemBuilder: (context, index) {
              return SearchTile(
                email: searchSnapshot.documents[index].data['email'],
                username: searchSnapshot.documents[index].data['name'],
              );
            })
        : Container();
  }

  Widget select() {
    if (userNotFound) {
      return Container(
        padding: EdgeInsets.all(50),
        child: Center(
          child: Text(
            error,
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      );
    } else {
      return searchList();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? loading()
        : Scaffold(
            body: SafeArea(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.blue[800],
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back)),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: TextField(
                            controller: searchText,
                            style: TextStyle(
                                color: Colors.white, letterSpacing: 0.5),
                            decoration:
                                textFieldInputDecoration('Search user....'),
                          )),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                if (searchText.text.isEmpty) {
                                  isloading = false;
                                } else {
                                  isloading = true;
                                }

                                error = ' ';
                                initiateSearch();
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue[700],
                                    borderRadius: BorderRadius.circular(30)),
                                height: 40,
                                width: 40,
                                child: Icon(Icons.search)),
                          )
                        ],
                      ),
                    ),
                    select()
                  ],
                ),
              ),
            ),
          );
  }
}

class SearchTile extends StatefulWidget {
  final String username, email;
  SearchTile({this.email, this.username});

  @override
  _SearchTileState createState() => _SearchTileState();
}

class _SearchTileState extends State<SearchTile> {
  final Database db = new Database();

  bool isloading = false;

  _SearchScreenState ob = _SearchScreenState();

  @override
  Widget build(BuildContext context) {
    return isloading
        ? loading()
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.username,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      widget.email,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    print('Name ${Constants.myName}');
                    ob.createChatRoomAndStartChatting(widget.username, context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Message',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
