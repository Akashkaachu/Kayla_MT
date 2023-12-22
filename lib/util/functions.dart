// ignore_for_file: use_build_context_synchronously, avoid_print
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kayla/screen/mobile.dart';
import 'package:kayla/screen/sign.dart';
import 'package:kayla/service/authservice.dart';
import 'package:firebase_storage/firebase_storage.dart';

void clickSignUp() {
  if (isSignUpBool.value) {
    isSignUpBool.value = false;
    emailEditingController.clear();
    passwordEditingController.clear();
  } else {
    isSignUpBool.value = true;
  }
}

void clickEye() {
  if (isEyeBool.value) {
    isEyeBool.value = false;
  } else {
    isEyeBool.value = true;
  }
}

void signUpFun(
  email,
  password,
  BuildContext context,
) async {
  if (formkey.currentState!.validate()) {
    final getSignUpFromAuth =
        await AuthServiceClass().createUserAccount(email, password, context);
    print(getSignUpFromAuth);
    if (getSignUpFromAuth == true) {
    } else {
      showSnackBarFun(
          context, "Email and password is already exist ", Colors.red);
    }
    FocusScope.of(context).unfocus();
  }
}

void showSnackBarFun(BuildContext context, String content, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    backgroundColor: color,
  ));
}

void signInFun(email, password, BuildContext context) async {
  if (formkey.currentState!.validate()) {
    final getSignInIsPresent =
        await AuthServiceClass().signIn(email, password, context);
    if (getSignInIsPresent != null) {
    } else {
      showSnackBarFun(context, "Please Sign Up", Colors.red);
    }
  }
  FocusScope.of(context).unfocus();
}

//______________________LOGIN WITH PHONENUMBER________________________//

//formKey validation
void sendOtp(BuildContext context) {
  if (phoneNumberFormKey.currentState!.validate()) {
    AuthServiceClass().phoneNumberValidation(context);
  }
}

void verifyOtp(BuildContext context) {
  AuthServiceClass().verifiyingOtp(context);
  FocusScope.of(context).unfocus();
}

void alertLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: const Text("Are you sure to LogOut?"),
        title: const Text("Logout"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF188F79),
              ),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const SignupandSigninpge(),
                    ),
                    (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF188F79),
              ),
              child: const Text("LogOut"))
        ],
      );
    },
  );
}

Future<String?> uploadImageFireStore(
    File imageFile, BuildContext context) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    print(user!.uid);

    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${user.uid}/${DateTime.now().millisecondsSinceEpoch}');

    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  } catch (e) {
    showSnackBarFun(context, "Error uploading image", Colors.red);
  }
  return null;
}
