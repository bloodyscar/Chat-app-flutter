import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  final authC = Get.find<AuthController>();
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
                  onChanged: (value) {
                    controller.searchFriend(
                        value, authC.userModel.value.email!);
                  },
                  controller: controller.searchC,
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
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: Obx(
          () => controller.tempSearch.length == 0
              ? Center(
                  child: Container(
                    width: Get.width * 0.7,
                    height: Get.height * 0.7,
                    child: Lottie.asset("assets/lottie/empty.json"),
                  ),
                )
              : ListView.builder(
                  itemCount: controller.tempSearch.length,
                  itemBuilder: (context, index) => ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 30,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: controller.tempSearch[index]["photoUrl"] ==
                                    "noimage"
                                ? Image.asset(
                                    "assets/logo/noimage.png",
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    controller.tempSearch[index]["photoUrl"]),
                          )),
                      title: Text(
                        "${controller.tempSearch[index]["name"]}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      subtitle:
                          Text("${controller.tempSearch[index]["email"]}"),
                      trailing: GestureDetector(
                        onTap: () {
                          authC.addNewConnection(
                              controller.tempSearch[index]["email"]);
                        },
                        child: Chip(
                          backgroundColor: Colors.green.shade800,
                          label: Text(
                            "Messages",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                ),
        ));
  }
}
