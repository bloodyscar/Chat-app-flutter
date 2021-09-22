import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green.shade700,
          onPressed: () => Get.toNamed(Routes.SEARCH),
          child: Icon(Icons.search),
        ),
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                color: Colors.green.shade700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Chats",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                          onTap: () => Get.toNamed(Routes.PROFILE),
                          child: Icon(
                            Icons.person,
                            color: Colors.grey,
                          )),
                    )
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: controller.chatStream(authC.userModel.value.email!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var allChats = (snapshot.data!.data()
                          as Map<String, dynamic>)["chats"] as List;

                      return ListView.builder(
                        itemCount: allChats.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                            stream: controller
                                .friendStream(allChats[index]["connection"]),
                            builder: (context, snapshot2) {
                              if (snapshot2.connectionState ==
                                  ConnectionState.active) {
                                var data = snapshot2.data!.data();
                                return ListTile(
                                  onTap: () => Get.toNamed(Routes.CHAT_ROOM),
                                  leading: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 30,
                                      child: data!["photoUrl"] == "noimage"
                                          ? Image.asset(
                                              "assets/logo/noimage.png",
                                              fit: BoxFit.cover,
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Image.network(
                                                "${data["photoUrl"]}",
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                  title: Text(
                                    "${data["name"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text("${data["status"]}"),
                                  trailing: allChats[index]["total_unread"] == 0
                                      ? SizedBox()
                                      : Chip(
                                          backgroundColor:
                                              Colors.green.shade800,
                                          label: Text(
                                            "${allChats[index]["total_unread"]}",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
