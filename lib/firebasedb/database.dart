import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kayla/modelclass/usermodel.dart';

class FirebaseDatabaseClass {
  final String uid;
  FirebaseDatabaseClass({required this.uid});
  final CollectionReference usercollection =
      FirebaseFirestore.instance.collection("user");
  Future saveUserData(String email) async {
    usercollection.doc(uid).set({'email': email, 'uid': uid});
  }

  Future gettingUserData() async {
    QuerySnapshot snapshot =
        await usercollection.where("uid", isEqualTo: uid).get();
    return snapshot;
  }

  Future addUserToFirebase(
      UserModelClass userModel, BuildContext context) async {
    final userDoc = await usercollection.doc(uid).get();
    final folderDoc = await userDoc.reference
        .collection('studentdatacollection')
        .doc(uid + DateTime.now().millisecondsSinceEpoch.toString())
        .get();
    await folderDoc.reference.set({
      'imageurl': userModel.imageUrl,
      'name': userModel.name,
      'age': userModel.age
    });
    Navigator.pop(context);
  }
}
