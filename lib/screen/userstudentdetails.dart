import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kayla/modelclass/usermodel.dart';
import 'package:kayla/util/functions.dart';
import 'package:kayla/firebasedb/database.dart';

class StudentDetailsPage extends StatefulWidget {
  const StudentDetailsPage({super.key});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

TextEditingController nameEditingController = TextEditingController();
TextEditingController ageEditingController = TextEditingController();
final studentFormKey = GlobalKey<FormState>();
File? selectedImage;

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
              padding: const EdgeInsets.only(top: 89, left: 35, right: 35),
              child: Form(
                key: studentFormKey,
                child: Column(
                  children: [
                    Text(
                      "Enter User Details!",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color(0XFF188F79),
                      ),
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Choose Image Source"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0XFF188F79)),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        final pickedImage =
                                            await ImagePicker().pickImage(
                                          source: ImageSource.camera,
                                        );
                                        if (pickedImage != null) {
                                          selectedImage =
                                              File(pickedImage.path);
                                          setState(() {});
                                        }
                                      },
                                      child: const Text("Camera"),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0XFF188F79)),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        final pickedImage =
                                            await ImagePicker().pickImage(
                                          source: ImageSource.gallery,
                                        );
                                        if (pickedImage != null) {
                                          selectedImage =
                                              File(pickedImage.path);
                                          setState(() {});
                                        }
                                      },
                                      child: const Text("Gallery"),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: ClipOval(
                        child: Container(
                          color: const Color(0XFF188F79),
                          width:
                              160, // Adjust the width and height according to your needs
                          height: 160,
                          child: selectedImage != null
                              ? Image.file(
                                  selectedImage!,
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.image,
                                  size: 80, // Adjust the icon size as needed
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: nameEditingController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your name";
                        } else if (value.length < 3) {
                          return "Atleast 3 charectors required";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          label: Text("Name"), border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: ageEditingController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your age";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          label: Text("Age"), border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 35),
                    SizedBox(
                        width: size.width,
                        height: (size.height / 2) / 2 - 150,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (studentFormKey.currentState!.validate()) {
                                if (selectedImage != null) {
                                  String? imageurl = await uploadImageFireStore(
                                      selectedImage!, context);
                                  final userdata = UserModelClass(
                                      imageUrl: imageurl!,
                                      name: nameEditingController.text.trim(),
                                      age: int.parse(
                                          ageEditingController.text.trim()));
                                  User? user =
                                      FirebaseAuth.instance.currentUser;
                                  await FirebaseDatabaseClass(uid: user!.uid)
                                      .addUserToFirebase(userdata, context);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0XFF188F79)),
                            child: Text(
                              "Save",
                              style: GoogleFonts.poppins(
                                  fontSize: 22, fontWeight: FontWeight.w400),
                            )))
                  ],
                ),
              )),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0XFF188F79),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.people),
        ),
      ),
    );
  }
}
