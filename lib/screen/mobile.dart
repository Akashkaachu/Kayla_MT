import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayla/util/functions.dart';
import 'package:kayla/widget/refactory.dart';

class MobilePage extends StatefulWidget {
  const MobilePage({super.key});

  @override
  State<MobilePage> createState() => _MobilePageState();
}

TextEditingController phoneEditingController = TextEditingController();

TextEditingController OtpEditingController = TextEditingController();

final phoneNumberFormKey = GlobalKey<FormState>();

ValueNotifier<bool> isOTP = ValueNotifier<bool>(false);

class _MobilePageState extends State<MobilePage> {
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
            height: size.height,
            padding: const EdgeInsets.all(8),
            child: Form(
              key: phoneNumberFormKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormFieldWidget(
                      label: Text(
                        "Enter your Phone Number",
                        style: GoogleFonts.poppins(),
                      ),
                      prefixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "+91",
                            style: GoogleFonts.poppins(),
                          ),
                        ],
                      ),
                      keyboardType: TextInputType.number,
                      controller: phoneEditingController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Phone number";
                        } else if (value.length == 10) {
                          return null;
                        } else {
                          return "Invalid Phone Number";
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder(
                        valueListenable: isOTP,
                        builder: (context, isOTPTrue, child) {
                          return Column(
                            children: [
                              Visibility(
                                visible: isOTPTrue,
                                child: TextFormFieldWidget(
                                  prefixIcon: Icon(Icons.key),
                                  controller: OtpEditingController,
                                  keyboardType: TextInputType.number,
                                  label: const Text("Enter OTP Number"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter your OTP number";
                                    } else {
                                      return "Invalid OTP Number";
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0XFF188F79)),
                                  onPressed: () => isOTPTrue
                                      ? verifyOtp(context)
                                      : sendOtp(context),
                                  child: Text(
                                    isOTPTrue ? "Verify" : "Get OTP",
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ))
                            ],
                          );
                        }),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneEditingController.clear();
    OtpEditingController.clear();
    isOTP.value = false;
    super.dispose();
  }
}
