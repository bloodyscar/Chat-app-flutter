import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: WillPopScope(
          onWillPop: () {
            if (controller.isEmojiShow.isTrue) {
              controller.isEmojiShow.value = false;
            } else {
              Navigator.pop(context);
            }
            return Future.value(false);
          },
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Stack(
              children: [
                // Emoji Picker
                controller.isEmojiShow.isTrue
                    ? Container(
                        margin: EdgeInsets.only(
                            top: controller.isEmojiShow.isTrue ? 70 : 0),
                        height: 250,
                        child: EmojiPicker(
                          onEmojiSelected: (category, emoji) {
                            controller.addEmojiToChat(emoji);
                          },
                          onBackspacePressed: () {
                            controller.removeEmoji();
                          },
                          config: Config(
                              backspaceColor: Colors.green,
                              columns: 7,
                              emojiSizeMax: 32 *
                                  1.0, // Issue: https://github.com/flutter/flutter/issues/28894
                              verticalSpacing: 0,
                              horizontalSpacing: 0,
                              initCategory: Category.RECENT,
                              bgColor: Color(0xFFF2F2F2),
                              indicatorColor: Colors.green,
                              iconColor: Colors.grey,
                              iconColorSelected: Colors.green,
                              progressIndicatorColor: Colors.blue,
                              showRecentsTab: true,
                              recentsLimit: 28,
                              noRecentsText: "No Recents",
                              noRecentsStyle: const TextStyle(
                                  fontSize: 20, color: Colors.black26),
                              tabIndicatorAnimDuration: kTabScrollDuration,
                              categoryIcons: const CategoryIcons(),
                              buttonMode: ButtonMode.MATERIAL),
                        ),
                      )
                    : SizedBox(),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          controller: controller.chatC,
                          focusNode: controller.focusNode,
                          decoration: InputDecoration(
                              prefixIcon: IconButton(
                                onPressed: () {
                                  controller.focusNode.unfocus();
                                  controller.isEmojiShow.toggle();
                                },
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
              ],
            ),
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.green.shade800,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
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
