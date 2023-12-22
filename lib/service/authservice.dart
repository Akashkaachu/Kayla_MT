// ignore_for_file: use_build_context_synchronously, unused_catch_clause
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kayla/firebasedb/database.dart';
import 'package:kayla/screen/home.dart';
import 'package:kayla/screen/mobile.dart';
import 'package:kayla/util/functions.dart';

String verificationID = "";

class AuthServiceClass {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //creating   account   in   firebase(signUp)
  Future createUserAccount(
      String email, String password, BuildContext context) async {
    try {
      User? user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        await FirebaseDatabaseClass(uid: user.uid).saveUserData(email);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(uid: user.uid),
        ));
        return true;
      } else {
        return false;
      }
    } catch (e) {}
  }

  // for signIn
  Future signIn(String email, String password, BuildContext context) async {
    try {
      User? users = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (users != null) {
        final getSnapshrt =
            await FirebaseDatabaseClass(uid: users.uid).gettingUserData();
        if (getSnapshrt != null) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage(uid: users.uid),
          ));
        } else {}

        return true;
      } else {
        return false;
      }
    } catch (e) {}
  }

//google sign up
  Future<void> googleSignUp(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        return;
      } else {
        final GoogleSignInAuthentication gAuth = await gUser.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: gAuth.accessToken, idToken: gAuth.idToken);
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = userCredential.user;
        if (user != null) {
          QuerySnapshot snapshot =
              await FirebaseDatabaseClass(uid: user.uid).gettingUserData();
          if (snapshot == null) {
            await FirebaseDatabaseClass(uid: user.uid)
                .saveUserData(user.email!);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomePage(uid: user.uid),
            ));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomePage(uid: user.uid),
            ));
          }
        } else {}
      }
    } catch (e) {
      showSnackBarFun(context, "Google Sign In ", Colors.red);
    }
  }

//OTP varaaan

  Future<void> phoneNumberValidation(BuildContext context) async {
    String countrycode = "+91";
    firebaseAuth.verifyPhoneNumber(
      phoneNumber: countrycode + phoneEditingController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await firebaseAuth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
        });
      },
      verificationFailed: (error) {
        showSnackBarFun(context, error.toString(), Colors.red);
      },
      codeSent: (verificationId, forceResendingToken) {
        verificationID = verificationId;
        isOTP.value = true;
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

//verify otp
  Future<void> verifiyingOtp(BuildContext context) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID,
        smsCode: OtpEditingController.text.trim());

    try {
      await firebaseAuth.signInWithCredential(credential);
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        QuerySnapshot snapshot =
            await FirebaseDatabaseClass(uid: user.uid).gettingUserData();
        if (snapshot == null) {
          await FirebaseDatabaseClass(uid: user.uid).saveUserData(user.email!);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage(uid: user.uid),
          ));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage(uid: user.uid),
          ));
        }
      }
    } on Exception catch (e) {
      showSnackBarFun(context, "Error in OTP verificarion", Colors.red);
    }
  }
}
