import 'dart:async';

import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth auth = FirebaseAuth.instance;

void authenticatePhone(context, String phone, Completer completer) {
  auth.verifyPhoneNumber(
    phoneNumber: phone,
    verificationCompleted: (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        debugPrint('The provided phone number is not valid.');
      }
    },
    codeSent: (String verificationId, int? resendToken) async {
      await Navigator.of(context)
          .pushNamed("/verifyOTP", arguments: [verificationId, resendToken]);
      completer.complete();
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Auto-resolution timed out
    },
  );
}

Future<bool> authenticate(
    context, String type, String credential, String password) async {
  final cred = await FirebaseFirestore.instance
      .collection("credentials")
      .where(type, isEqualTo: credential.toLowerCase())
      .get();

  if (cred.docs.isEmpty) return false;

  if (BCrypt.checkpw(password, cred.docs.first.get("password"))) {
    Completer phoneAuthComplete = Completer();
    authenticatePhone(context, cred.docs.first.get("phone"), phoneAuthComplete);
    await phoneAuthComplete.future;
    Navigator.pushReplacementNamed(context, "/");
    return true;
  }
  return false;
}

Future<void> signIn(
    context, String verificationId, String smsCode, int? resendToken) async {
  // Create a PhoneAuthCredential with the code
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
    verificationId: verificationId,
    smsCode: smsCode,
  );

  await auth.signInWithCredential(credential);
  Navigator.of(context).pop();
}

bool signedIn() {
  return (FirebaseAuth.instance.currentUser != null) ? true : false;
}

Future<void> signUp(BuildContext context, String username, String email,
    String phone, String password) async {
  Completer phoneAuthComplete = Completer();

  authenticatePhone(context, phone, phoneAuthComplete);
  await phoneAuthComplete.future;

  if (signedIn()) {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    String pwHash = BCrypt.hashpw(
      password,
      BCrypt.gensalt(
        logRounds: 11,
        prefix: "\$2y",
      ),
    );

    Map<String, dynamic> credentials = {
      "username": username.toLowerCase(),
      "email": email.toLowerCase(),
      "phone": phone,
      "password": pwHash,
      "account_creation_date": DateTime.now().millisecondsSinceEpoch,
    };
    await FirebaseFirestore.instance
        .collection("credentials")
        .doc(uid)
        .set(credentials);

    Map<String, dynamic> user = {
      "username": username,
      'followings':
          FirebaseFirestore.instance.collection("followings").doc(uid),
      'followers': FirebaseFirestore.instance.collection("followers").doc(uid),
      'wishlist': FirebaseFirestore.instance.collection("wishlist").doc(uid),
      'games_played':
          FirebaseFirestore.instance.collection("games_played").doc(uid),
      'games_liked':
          FirebaseFirestore.instance.collection("games_liked").doc(uid),
      'lists': FirebaseFirestore.instance.collection("lists").doc(uid),
      'followings_count': 0,
      'followers_count': 0,
      'wishlist_count': 0,
      'games_played_count': 0,
      'games_liked_count': 0,
      'lists_count': 0,
    };
    await FirebaseFirestore.instance.collection("users").doc(uid).set(user);

    signOut();
    Navigator.of(context).pushReplacementNamed("/signIn");
  } else {
    debugPrint("There was Some Error during Registering");
  }
}

Future<bool> usernameAvailable(String username) async {
  final cred = await FirebaseFirestore.instance
      .collection("credentials")
      .where("username", isEqualTo: username.toLowerCase())
      .get();

  return cred.docs.isEmpty ? true : false;
}

Future<bool> emailAlreadyRegistered(String email) async {
  final cred = await FirebaseFirestore.instance
      .collection("credentials")
      .where("email", isEqualTo: email.toLowerCase())
      .get();

  return cred.docs.isNotEmpty ? true : false;
}

Future<bool> phoneAlreadyRegistered(String phone) async {
  final cred = await FirebaseFirestore.instance
      .collection("credentials")
      .where("phone", isEqualTo: phone)
      .get();

  return cred.docs.isNotEmpty ? true : false;
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}
