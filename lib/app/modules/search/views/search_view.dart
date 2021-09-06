import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  final List<Widget> friends = List.generate(
      5,
      (index) => ListTile(
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
          subtitle: Text("orang${index + 1}@gmail.com"),
          trailing: GestureDetector(
            onTap: () {
              Get.toNamed(Routes.CHAT_ROOM);
            },
            child: Chip(
              backgroundColor: Colors.green.shade800,
              label: Text(
                "Messages",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBar(
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                cursorColor: Colors.green,
                decoration: InputDecoration(
                    suffixIcon: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {},
                      child: Icon(
                        Icons.search,
                        color: Colors.green,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    hintText: "Search Friend here ...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.white)),
                    fillColor: Colors.white,
                    filled: true),
              ),
            ),
          ),
          backgroundColor: Colors.green.shade700,
          title: Text('Search'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: friends.length == 0
          ? Center(
              child: Container(
                width: Get.width * 0.7,
                height: Get.height * 0.7,
                child: Lottie.asset("assets/lottie/empty.json"),
              ),
            )
          : ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) => friends[index],
            ),
    );
  }
}
