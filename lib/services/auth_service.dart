import 'dart:async';

import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goodgame/models/user_model.dart' as model;

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
      await Navigator.of(context).pushNamed("/verifyOTP", arguments: [verificationId, resendToken]);
      completer.complete();
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Auto-resolution timed out
    },
  );
}

Future<bool> authenticate(context, String type, String credential, String password) async {
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

Future<void> signIn(context, String verificationId, String smsCode, int? resendToken) async {
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

Future<void> signUp(
    BuildContext context, String username, String email, String phone, String password) async {
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
    await FirebaseFirestore.instance.collection("credentials").doc(uid).set(credentials);

    model.User user = model.User(
      username: username,
      followings: FirebaseFirestore.instance.collection("followings").doc(uid),
      followers: FirebaseFirestore.instance.collection("followers").doc(uid),
      wishlist: FirebaseFirestore.instance.collection("wishlist").doc(uid),
      gamesPlayed: FirebaseFirestore.instance.collection("games_played").doc(uid),
      gamesLiked: FirebaseFirestore.instance.collection("games_liked").doc(uid),
      lists: FirebaseFirestore.instance.collection("lists").doc(uid),
      followingsCount: 0,
      followersCount: 0,
      wishlistCount: 0,
      gamesPlayedCount: 0,
      gamesLikedCount: 0,
      listsCount: 0,
    );
    await FirebaseFirestore.instance.collection("users").doc(uid).set(user.toMap());

    signOut();
    Navigator.of(context).pushReplacementNamed("/signIn");
  } else {
    debugPrint("There was Some Error during Registering");
  }
}

Future<bool> isRegistered({required String credentialType, required String value}) async {
  final cred = await FirebaseFirestore.instance
      .collection("credentials")
      .where(credentialType, isEqualTo: value.toLowerCase())
      .get();

  return cred.docs.isNotEmpty ? true : false;
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}
