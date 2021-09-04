import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final List<Widget> myChats = List.generate(
      5,
      (index) => ListTile(
          onTap: () => Get.toNamed(Routes.CHAT_ROOM),
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 30,
            child: Image(
              image: AssetImage("assets/logo/noimage.png"),
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            "Orang ke-${index + 1}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          subtitle: Text("Halo ke-${index + 1}"),
          trailing: Chip(
            backgroundColor: Colors.green.shade800,
            label: Text(
              "3",
              style: TextStyle(color: Colors.white),
            ),
          ))).reversed.toList();

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
                child: ListView.builder(
                  itemCount: myChats.length,
                  itemBuilder: (context, index) => myChats[index],
                ),
              )
            ],
          ),
        ));
  }
}
