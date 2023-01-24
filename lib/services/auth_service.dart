import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> authenticate() async {
  await auth.verifyPhoneNumber(
    phoneNumber: '+91 7900160770',
    verificationCompleted: (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }
    },
    codeSent: (String verificationId, int? resendToken) async {
      signIn(verificationId, resendToken);
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Auto-resolution timed out
    },
  );
}

Future<void> signIn(String verificationId, int? resendToken) async {
  String smsCode = '111111';
  // Create a PhoneAuthCredential with the code
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
    verificationId: verificationId,
    smsCode: smsCode,
  );

  await auth.signInWithCredential(credential);
}