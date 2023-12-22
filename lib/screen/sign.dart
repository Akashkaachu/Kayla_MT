// ignore_for_file: avoid_unnecessary_containers, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayla/screen/mobile.dart';
import 'package:kayla/service/authservice.dart';
import 'package:kayla/util/functions.dart';
import 'package:kayla/widget/refactory.dart';

class SignupandSigninpge extends StatefulWidget {
  const SignupandSigninpge({super.key});

  @override
  State<SignupandSigninpge> createState() => _SignupandSigninpgeState();
}

TextEditingController emailEditingController = TextEditingController();
TextEditingController passwordEditingController = TextEditingController();
final formkey = GlobalKey<FormState>();
ValueNotifier<bool> isSignUpBool = ValueNotifier<bool>(true);
ValueNotifier<bool> isEyeBool = ValueNotifier<bool>(true);

class _SignupandSigninpgeState extends State<SignupandSigninpge> {
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
        body: Container(
          width: size.width,
          padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
          child: ValueListenableBuilder(
              valueListenable: isSignUpBool,
              builder: (context, isSignUp, child) {
                return Form(
                  key: formkey,
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Hello!\nWelcome back",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                color: const Color(0XFF188F79)),
                          ),
                          const SizedBox(height: 80),
                          TextFormFieldWidget(
                            prefixIcon: const Icon(Icons.email_outlined),
                            label: const Text("Email"),
                            controller: emailEditingController,
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please enter a valid email";
                            },
                          ),
                          const SizedBox(height: 15),
                          ValueListenableBuilder(
                              valueListenable: isEyeBool,
                              builder: (context, isEyeBool, child) {
                                return TextFormFieldWidget(
                                  onpressSufix: () => clickEye(),
                                  obscureText: isEyeBool,
                                  prefixIcon:
                                      const Icon(Icons.fingerprint_outlined),
                                  suffixIcon: isEyeBool
                                      ? Icons.visibility_off_outlined
                                      : Icons.remove_red_eye,
                                  label: const Text("Password"),
                                  controller: passwordEditingController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter your Password";
                                    } else if (value.length < 6) {
                                      return "Atleast Six charecters";
                                    } else {
                                      null;
                                    }
                                  },
                                );
                              }),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: isSignUp,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Forgot Password?",
                                      style: GoogleFonts.poppins(
                                          color: const Color(0XFF188F79)),
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: size.width - 90,
                            height: (size.height / 2) / 2 - 150,
                            child: isSignUp
                                ? ElevatedButton(
                                    onPressed: () => signInFun(
                                        emailEditingController.text,
                                        passwordEditingController.text,
                                        context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0XFF188F79),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Sign In",
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ))
                                : ElevatedButton(
                                    onPressed: () => signUpFun(
                                        emailEditingController.text,
                                        passwordEditingController.text,
                                        context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Sign Up",
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    )),
                          ),
                          const SizedBox(height: 18),
                          isSignUp
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have any account?",
                                      style: GoogleFonts.poppins(),
                                    ),
                                    TextButton(
                                        onPressed: () => clickSignUp(),
                                        child: Text("Sign Up",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    const Color(0XFF188F79))))
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account",
                                      style: GoogleFonts.poppins(),
                                    ),
                                    TextButton(
                                        onPressed: () => clickSignUp(),
                                        child: Text("Sign In",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    const Color(0XFF188F79))))
                                  ],
                                ),
                          const SizedBox(height: 10),
                          const Divider(
                            color: Colors.grey,
                            thickness: .5,
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await AuthServiceClass()
                                      .googleSignUp(context);
                                },
                                child: Image.asset(
                                  "Assets/images/google.png",
                                  width: (size.width / 2) / 2 - 60,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const MobilePage(),
                                  ));
                                },
                                child: Image.asset(
                                  "Assets/images/iphone.png",
                                  width: (size.width / 2) / 2 - 60,
                                ),
                              )
                            ],
                          )
                        ]),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
