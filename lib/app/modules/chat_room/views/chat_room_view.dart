import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.08,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.emoji_emotions_outlined),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      labelText: "Typing here..."),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.green.shade800),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.green.shade800,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/logo/noimage.png",
                width: 45,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No Name",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Busy",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w300),
                  )
                ],
              )
            ],
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(
              height: 30,
            ),
            ChatBuble(
              isSender: false,
            ),
            ChatBuble(
              isSender: true,
            ),
            ChatBuble(
              isSender: false,
            ),
            ChatBuble(
              isSender: true,
            ),
            ChatBuble(
              isSender: false,
            ),
            ChatBuble(
              isSender: true,
            ),
            ChatBuble(
              isSender: false,
            ),
          ],
        ));
  }
}

class ChatBuble extends StatelessWidget {
  final bool isSender;
  ChatBuble({this.isSender = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment:
              isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(isSender ? 12 : 0),
                    topLeft: Radius.circular(isSender ? 0 : 12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  color: Colors.green.shade100,
                  border: Border.all(color: Colors.grey, width: 1)),
              child: Text(
                  "lorem ipsum lorem lorem ipsum lorem lorem ipsum lorem m ipsum lorem lorem ipsum lorem"),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            "16:22 PM",
            style: TextStyle(color: Colors.grey.shade700),
          ),
        )
      ],
    );
  }
}
