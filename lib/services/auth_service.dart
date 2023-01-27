import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> authenticate(context, String phone) async {
  await auth.verifyPhoneNumber(
    phoneNumber: '+91 $phone',
    verificationCompleted: (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }
    },
    codeSent: (String verificationId, int? resendToken) async {
      Navigator.of(context).pushReplacementNamed("/verifyOTP",
          arguments: [verificationId, resendToken]);
      // signIn(verificationId, resendToken);
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Auto-resolution timed out
    },
  );
}

Future<void> signIn(
    context, String verificationId, String smsCode, int? resendToken) async {
  // String smsCode = '111111';
  // Create a PhoneAuthCredential with the code
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
    verificationId: verificationId,
    smsCode: smsCode,
  );

  await auth.signInWithCredential(credential);
  Navigator.of(context).pushReplacementNamed("/");
}

bool signedIn() {
  if (FirebaseAuth.instance.currentUser != null) {
    return true;
  }
  return false;
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
  print(FirebaseAuth.instance.currentUser);
}
