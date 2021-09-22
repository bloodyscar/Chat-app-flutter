import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.offAllNamed(Routes.HOME);
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
          ),
          actions: [
            IconButton(
              onPressed: () {
                authC.logout();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            AvatarGlow(
              endRadius: 110,
              glowColor: Colors.grey,
              duration: Duration(seconds: 2),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: authC.userModel.value.photoUrl == null
                      ? Image(
                          image: AssetImage("assets/logo/noimage.png"),
                          width: 150,
                          fit: BoxFit.cover,
                        )
                      : Image(
                          image: NetworkImage(authC.userModel.value.photoUrl!),
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${authC.userModel.value.name}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${authC.userModel.value.email}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Update Status",
                          style: TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.toNamed(Routes.UPDATE_STATUS);
                          },
                          icon: Icon(Icons.chevron_right),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Change Profile",
                          style: TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.toNamed(Routes.CHANGE_PROFILE);
                          },
                          icon: Icon(Icons.chevron_right),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Change Theme",
                          style: TextStyle(fontSize: 16),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "Light",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(
                    bottom: context.mediaQueryPadding.bottom + 30),
                child: Column(
                  children: [
                    Text(
                      "Chat App",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      "V1.0",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                  ],
                ))
          ],
        ));
  }
}
