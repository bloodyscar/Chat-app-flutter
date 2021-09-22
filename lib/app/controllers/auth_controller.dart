import 'package:chatapp/app/data/models/users_model.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  UserCredential? userCredential;

  GoogleSignInAccount? _currentUser;
  var userModel = UsersModel().obs;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> firstInitialized() async {
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });

    await skipIntro().then((value) {
      if (value) {
        isSkipIntro.value = true;
      }
    });
  }

  Future<bool> skipIntro() async {
    // kita akan mengubah isSkipIntro => true
    final box = GetStorage();
    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
      return true;
    }
    return false;
  }

  Future<bool> autoLogin() async {
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);

        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        print("==== USER CREDENTIAL ====");
        print(userCredential);

        // masukkan data ke firebase
        CollectionReference users = firebaseFirestore.collection('users');
        final checkUser = await users.doc(_currentUser!.email).get();

        await users.doc(_currentUser!.email).update({
          'lastSignInTime':
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });

        final getUser = await users.doc(_currentUser!.email).get();
        final getUserData = getUser.data() as Map<String, dynamic>;
        userModel(UsersModel.fromJson(getUserData));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> login() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      final isSignIn = await _googleSignIn.isSignedIn();

      if (isSignIn) {
        print("Berhasil login");
        print("==== CURRENT USER ====");
        print(_currentUser);

        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        print("==== USER CREDENTIAL ====");
        print(userCredential);

        // Simpan status user sudah pernah login & tidak tampilkan intro
        final box = GetStorage();
        if (box.read('skipIntro') != null) {
          box.remove('skipIntro');
        }
        box.write('skipIntro', true);

        // masukkan data ke database
        CollectionReference users = firebaseFirestore.collection('users');
        final checkUser = await users.doc(_currentUser!.email).get();
        if (checkUser.data() == null) {
          await users.doc(_currentUser!.email).set({
            'uid': userCredential!.user!.uid,
            'name': _currentUser!.displayName,
            'keyName': _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            'email': _currentUser!.email,
            'photoUrl': _currentUser!.photoUrl,
            'status': '',
            'creationTime':
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            'lastSignInTime': userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            'updatedTime': DateTime.now().toIso8601String(),
            'chats': []
          });
        } else {
          await users.doc(_currentUser!.email).update({
            'lastSignInTime': userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
          });
        }

        final getUser = await users.doc(_currentUser!.email).get();
        final getUserData = getUser.data() as Map<String, dynamic>;
        userModel(UsersModel.fromJson(getUserData));

        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {
        print("Gagal login");
      }

      print(_currentUser);
    } catch (error) {
      throw PlatformException(code: "Gagal Login");
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();

    Get.offAllNamed(Routes.LOGIN);
  }

  void changeProfile(String name, String status) {
    final date = DateTime.now().toIso8601String();
    // ubah data yang ada di database
    CollectionReference users = firebaseFirestore.collection('users');
    users.doc(_currentUser!.email).update({
      "name": name,
      "keyName": name.substring(0, 1).toUpperCase(),
      "status": status,
      'lastSignInTime':
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      'updatedTime': date,
    });

    // update data pada userModel
    userModel.update((user) {
      user!.name = name;
      user.keyName = name.substring(0, 1).toUpperCase();
      user.status = status;
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = date;
    });

    userModel.refresh();
    Get.defaultDialog(
        title: "Update Profile Success", middleText: "Change Profile Success");
  }

  void updateStatus(String status) {
    final date = DateTime.now().toIso8601String();
    // ambil data dari database
    CollectionReference users = firebaseFirestore.collection('users');
    users.doc(_currentUser!.email).update({
      "status": status,
      'lastSignInTime':
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      'updatedTime': date,
    });

    // update model pada userModel
    userModel.update((user) {
      user!.status = status;
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = date;
    });

    userModel.refresh();
    Get.defaultDialog(
        title: "Update Status Success", middleText: "Change Status Success");
  }

  // SEARCH
  void addNewConnection(String friendEmail) async {
    final date = DateTime.now().toIso8601String();
    CollectionReference chats = firebaseFirestore.collection("chats");
    CollectionReference users = firebaseFirestore.collection("users");
    var chat_id;
    bool flagNewConnection = false;

    final docUser = await users.doc(_currentUser!.email).get();
    final docChats = (docUser.data() as Map<String, dynamic>)["chats"] as List;

    if (docChats != 0) {
      // user sudah pernah chat
      docChats.forEach((singleChat) {
        if (singleChat["connection"] == friendEmail) {
          chat_id = singleChat["chat_id"];
        }
      });
      if (chat_id != null) {
        flagNewConnection = false;
      } else {
        flagNewConnection = true;
      }
    } else {
      // user belum pernah chat
      flagNewConnection = true;
    }

    // 1. belum ada history chat friendEmail

    // 2. sudah ada history chat dengan friendEmail

    if (flagNewConnection) {
      final chatsDocs = await chats.where(
        "connections",
        whereIn: [
          [
            _currentUser!.email,
            friendEmail,
          ],
          [
            friendEmail,
            _currentUser!.email,
          ],
        ],
      ).get();

      if (chatsDocs.docs.length != 0) {
        // terdapat data chats (sudah ada koneksi antara mereka berdua)
        final chatDataId = chatsDocs.docs[0].id;
        final chatsData = chatsDocs.docs[0].data() as Map<String, dynamic>;

        docChats.add({
          "connection": friendEmail,
          "chat_id": chatDataId,
          "lastTime": chatsData["lastTime"],
          "total_unread": 0,
        });

        await users.doc(_currentUser!.email).update({"chats": docChats});

        userModel.update((user) {
          user!.chats = [
            ChatUser(
                chatId: chatDataId, connection: friendEmail, lastTime: date)
          ];
        });
        chat_id = chatDataId;
        userModel.refresh();
      } else {
        // buat baru , mereka berdua benar2 belum ada koneksi
        final newChatDoc = await chats.add({
          "connections": [_currentUser!.email, friendEmail],
          "chat": [],
        });

        docChats.add({
          "connection": friendEmail,
          "chat_id": newChatDoc.id,
          "lastTime": date,
          "total_unread": 0,
        });

        await users.doc(_currentUser!.email).update({"chats": docChats});

        userModel.update((user) {
          user!.chats = [
            ChatUser(
                chatId: newChatDoc.id, connection: friendEmail, lastTime: date)
          ];
        });
        chat_id = newChatDoc.id;
        userModel.refresh();
      }
    }

    print(chat_id);
    Get.toNamed(Routes.CHAT_ROOM, arguments: chat_id);
  }
}
