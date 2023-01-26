import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

OtpFieldController _otpController = OtpFieldController();

class VerifyOTPPage extends StatelessWidget {
  const VerifyOTPPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Page"),
        backgroundColor: const Color(0xff303030),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: const Text(
                  "Enter Your OTP",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 400,
                margin: const EdgeInsets.symmetric(vertical: 32),
                child: OTPTextField(
                  controller: _otpController,
                  length: 6,
                  textFieldAlignment: MainAxisAlignment.spaceBetween,
                  fieldWidth: 50,
                  fieldStyle: FieldStyle.box,
                  outlineBorderRadius: 8,
                  style: const TextStyle(fontSize: 32),
                  otpFieldStyle: OtpFieldStyle(
                    borderColor: Colors.white,
                    enabledBorderColor: Colors.white60,
                    backgroundColor: const Color(0xff3d3d3d),
                  ),
                  inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.phone,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueGrey,
                      ),
                      onPressed: () {},
                      child: const Text("Resend"),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {},
                        child: const Text("Submit"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
