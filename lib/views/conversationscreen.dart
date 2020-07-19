import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat_app/widgets/notification.dart' as noti;
import 'package:intl/intl.dart';

class ConversationScreen extends StatefulWidget {
  final String chatroomid, name;
  ConversationScreen(this.chatroomid, this.name);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController message = new TextEditingController();
  Stream chatMessageStream;
  Widget chatMessageList() {
    return Container(
      margin: EdgeInsets.only(bottom: 100),
      child: StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data.documents.length ?? 0,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data.documents[index].data['message'],
                        snapshot.data.documents[index].data['sendBy'] ==
                            Constants.myName,
                        snapshot.data.documents[index].data['timestamp']);
                  })
              : Container();
        },
      ),
    );
  }

  sendMessage() {
    DateTime now = DateTime.now();
    String timestamp = DateFormat.jm().format(now);
    print(timestamp);
    Map<String, dynamic> messageMap = {
      'message': message.text,
      'sendBy': Constants.myName,
      'time': DateTime.now().millisecondsSinceEpoch,
      'timestamp': timestamp
    };

    print('The message : ${message.text}');
    Database.addConvoMsg(widget.chatroomid, messageMap);
    noti.Notification();
    setState(() {
      message.text = '';
    });
  }

  Widget empty() {
    print('End point');
    return SizedBox(
      height: 20,
    );
  }

  @override
  void initState() {
    Database.getConvoMsg(widget.chatroomid).then((val) {
      chatMessageStream = val;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            chatMessageList(),
            SizedBox(
              height: 30,
            ),
            Container(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.blue[800],
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: TextField(
                      maxLines: null,
                      controller: message,
                      style: TextStyle(color: Colors.white, letterSpacing: 0.5),
                      decoration: textFieldInputDecoration('Type a message'),
                    )),
                    GestureDetector(
                      onTap: () {
                        if (message.text.isNotEmpty) {
                          sendMessage();
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue[700],
                              borderRadius: BorderRadius.circular(30)),
                          height: 40,
                          width: 40,
                          child: Icon(Icons.send)),
                    )
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

class MessageTile extends StatefulWidget {
  final String msg;
  final bool isSendByMe;
  final String time;

  MessageTile(this.msg, this.isSendByMe, this.time);

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.isSendByMe
          ? EdgeInsets.only(left: 100)
          : EdgeInsets.only(right: 100),
      child: GestureDetector(
        onLongPress: () {
          setState(() {
            visible = true;
            print('Started');
          });
          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              print('Ended');
              visible = false;
            });
          });
          Clipboard.setData(ClipboardData(text: widget.msg));
        },
        child: Column(
          children: <Widget>[
            Visibility(
              visible: visible,
              child: Text(
                'copied to clipboard',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              width: MediaQuery.of(context).size.width,
              alignment: widget.isSendByMe
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: widget.isSendByMe
                        ? BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25))
                        : BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25)),
                    color: widget.isSendByMe
                        ? Colors.blue[800]
                        : Colors.grey[700]),
                child: Text(
                  widget.msg,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                  ),
                ),
              ),
            ),
            Container(
              padding: widget.isSendByMe
                  ? EdgeInsets.only(right: 20)
                  : EdgeInsets.only(left: 20),
              child: Align(
                alignment: widget.isSendByMe
                    ? Alignment.bottomRight
                    : Alignment.bottomLeft,
                child: Text(
                  widget.time,
                  style: simpleTextStyle(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
