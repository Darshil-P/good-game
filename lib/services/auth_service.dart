import 'dart:async';

import 'package:bcrypt/bcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'firestore_services.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

User? currentUser;
String? userId;
late bool signedIn;

void authenticatePhone(context, String phone, Completer completer) {
  _auth.verifyPhoneNumber(
    phoneNumber: phone,
    verificationCompleted: (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
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
  final cred = await getCredential(type, credential);

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

  await _auth.signInWithCredential(credential);
  Navigator.of(context).pop();
}

Future<void> signUp(
    BuildContext context, String username, String email, String phone, String password) async {
  Completer phoneAuthComplete = Completer();

  authenticatePhone(context, phone, phoneAuthComplete);
  await phoneAuthComplete.future;

  if (signedIn) {
    String pwHash = BCrypt.hashpw(
      password,
      BCrypt.gensalt(
        logRounds: 11,
        prefix: "\$2y",
      ),
    );

    await registerUser(username, email, phone, pwHash);

    _auth.signOut();
    Navigator.of(context).pushReplacementNamed("/signIn");
  } else {
    debugPrint("There was Some Error during Registering");
  }
}

Future<void> signOut() async {
  await _auth.signOut();
}

void initAuthStateListener() {
  _auth.authStateChanges().listen((user) {
    debugPrint("Auth State Changed");
    currentUser = user;
    userId = user?.uid;
    updateReferences(userId);
    signedIn = user != null;
  });
}
