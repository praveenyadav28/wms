import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/ui/onboarding/business.dart';
import 'package:wms_mst/ui/onboarding/utils/outside.dart';
import 'package:wms_mst/utils/button.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/navigation.dart';
import 'package:wms_mst/utils/snackbar.dart';
import 'package:wms_mst/utils/textformfield.dart';
import 'package:wms_mst/utils/textstyle.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String otpvarify = '';
  final _formKey = GlobalKey<FormState>();

  //resendOtp
  int _start = 0; // Timer duration in seconds
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _start = 30; // Reset timer duration
      _timer?.cancel(); // Cancel any existing timer
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_start > 0) {
            _start--;
          } else {
            _timer?.cancel(); // End timer
          }
        });
      });
    });
  }

    StyleText textStyles = StyleText(); 
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: OnboardingScreen(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: Sizes.height * 0.03),
                  child: Image.asset(
                    Images.logopng,
                    height: Sizes.height * .15,
                  ),
                ),
                commonTextField(
                  passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Mobile Number";
                    } else if (passwordController.text.length != 10) {
                      return "Please enter valid number";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  labelText: "Mobile Number",
                  maxLength: 10,
                  suffixIcon: TextButton(
                    onPressed:
                        _start > 0
                            ? null
                            : () async {
                              _startResendTimer(); // Start the timer after sending OTP
                              await verifyOtp(passwordController.text, context);
                            },
                    child: Text(_start > 0 ? '$_start sec' : 'Send OTP',style:  textStyles.sarifProText(14, FontWeight.w500, AppColor.primary)),
                  ),
                ),
                SizedBox(height: Sizes.height * 0.02),
                otpvarify == ""
                    ? Container()
                    : commonTextField(
                      keyboardType: TextInputType.number,
                      otpController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter OTP";
                        } else if (value != otpvarify) {
                          return 'Enter correct otp';
                        }
                        return null;
                      },
                      labelText: "OTP",
                    ),
                SizedBox(height: Sizes.height * 0.04),
                DefaultButton(
                  onTap: () {
                    if (_formKey.currentState!.validate() && otpvarify != "") {
                    pushTo(
                      BusinessDetails(
                        phoneNumber: passwordController.text.toString(),
                      ),
                    );
                    }
                  },
                  hight: 45,
                  width:
                      Sizes.width < 850 ? Sizes.width * .5 : Sizes.width * .2,
                  text: 'Sign Up',
                ),

                SizedBox(height: Sizes.height * 0.02),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child:  Text("Already have an account? Sign In",style: textStyles.sarifProText(14, FontWeight.w400, AppColor.black),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future verifyOtp(String otpMobileNo, BuildContext context) async {
    // Make the GET request
    final response = await ApiService.fetchData(
        'Login/OtpVerification?otpmobileno=$otpMobileNo');
    otpvarify = response['otp'];
    showCustomSnackbarSuccess(context, response['message']);
  }
}
