import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:todo_auth_app/pages/sign_up_page.dart';
import 'package:todo_auth_app/service/auth_service.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key? key}) : super(key: key);

  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  int start = 30;
  bool wait = false;
  String buttonName = 'Send';
  String verificationID = '';
  String smsCode = '';
  TextEditingController phoneController = TextEditingController();
  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => const SignUpPage()),
              (route) => false),
        ),
        title: const Text('OTP Page'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              textFeild(),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    const Text(
                      'Enter 6 digit OTP',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              otpFeild(),
              const SizedBox(
                height: 40,
              ),
              RichText(
                text: TextSpan(children: [
                  const TextSpan(
                    text: 'Send OTP again in  ',
                    style: TextStyle(color: Colors.yellowAccent, fontSize: 16),
                  ),
                  TextSpan(
                    text: '00:$start',
                    style:
                        const TextStyle(color: Colors.pinkAccent, fontSize: 16),
                  ),
                  const TextSpan(
                    text: '  Sec ',
                    style: TextStyle(color: Colors.yellowAccent, fontSize: 16),
                  ),
                ]),
              ),
              const SizedBox(
                height: 150,
              ),
              InkWell(
                onTap: () {
                  authClass.signInWithPhoneNumber(
                      verificationID, smsCode, context);
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width - 60,
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Let\'s Go',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startTime() {
    const onsec = Duration(seconds: 1);
    // ignore: unused_local_variable
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget otpFeild() {
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width - 15,
      fieldWidth: 50,
      otpFieldStyle: OtpFieldStyle(
          backgroundColor: Colors.blueGrey, borderColor: Colors.white),
      style: const TextStyle(fontSize: 17, color: Colors.white),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.underline,
      onCompleted: (pin) {
        if (kDebugMode) {
          print("Completed: " + pin);
          setState(() {
            smsCode = pin;
          });
        }
      },
    );
  }

  Widget textFeild() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextFormField(
        controller: phoneController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter Your Phone Number',
          hintStyle: const TextStyle(color: Colors.white, fontSize: 16),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 19, horizontal: 8),
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Text(
              '(+92)',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
          suffixIcon: InkWell(
            onTap: wait
                ? null
                : () async {
                    startTime();
                    start = 30;
                    setState(() {
                      wait = true;
                      buttonName = 'Resend';
                    });
                    await authClass.verifyPhoneNumber(
                        '+92 ${phoneController.text}', context, serData);
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Text(
                buttonName,
                style: TextStyle(
                    color: wait ? Colors.grey : Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void serData(verificationId) {
    setState(() {
      verificationID = verificationId;
    });
  }
}
