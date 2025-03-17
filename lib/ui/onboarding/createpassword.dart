// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/ui/onboarding/login.dart';
import 'package:wms_mst/ui/onboarding/utils/outside.dart';
import 'package:wms_mst/utils/appbar.dart';
import 'package:wms_mst/utils/button.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/navigation.dart';
import 'package:wms_mst/utils/snackbar.dart';
import 'package:wms_mst/utils/textformfield.dart';
import 'package:wms_mst/utils/textstyle.dart';

class CreatePassword extends StatefulWidget {
  CreatePassword({required this.email, super.key});
  String? email;
  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  StyleText textStyles = StyleText(); 

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: OnboardingScreen(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (Sizes.height * 1 > 400)
                Align(
                  alignment: Alignment.topCenter,
                  child: AppbarClass(title: 'Reset Password'),
                )
              else
                SizedBox(height: 0),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (Sizes.height * 1 <= 400)
                      AppbarClass(title: 'Reset Password')
                    else
                      SizedBox(height: 0, width: 0),
                    if (Sizes.height * 1 < 400)
                      SizedBox(height: Sizes.height * .04)
                    else
                      Container(height: 0),
                    RichText(
                      text: TextSpan(
                        style: textStyles.sarifProText(
                          15,
                          FontWeight.w400,
                          AppColor.black,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'Your new password and id will be sent on your ',
                          ),
                          TextSpan(
                            text: widget.email,
                            style: textStyles.sarifProText(
                              15,
                              FontWeight.w400,
                              AppColor.primary,
                            ),
                          ),
                          TextSpan(
                            text: ', after reseting the password.',
                            style: textStyles.sarifProText(
                              15,
                              FontWeight.w400,
                              AppColor.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Sizes.height * 0.05),
                    commonTextField(
                      _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Password";
                        } else if (_passwordController.text.length < 6) {
                          return "Please enter minumum 6 digit";
                        }
                        return null;
                      },
                      labelText: 'New Password',
                    ),
                    SizedBox(height: Sizes.height * 0.02),
                    commonTextField(
                      _confirmpasswordController,
                      validator: (value) {
                        if (_passwordController.text !=
                            _confirmpasswordController.text) {
                          return "Please enter same password";
                        }
                        return null;
                      },
                      labelText: "Confirm Password",
                    ),
                    SizedBox(height: Sizes.height * 0.04),
                      DefaultButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                          resetpassPostApi();
                        } 
                },
                hight: 45,
                width: Sizes.width < 850 ? Sizes.width * .5 : Sizes.width * .2,
                text: 'Save',
              ),
                  
                    SizedBox(height: Sizes.height * 0.06),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future resetpassPostApi() async {
    final response = await ApiService.postData(
      'Login/ForgotPassword?MOBOrMail=${widget.email?.length == 10 && isStringAnInteger(widget.email.toString()) ? 'MOB' : "MailId"}',
      {
        "MOB":
            "${widget.email?.length == 10 && isStringAnInteger(widget.email.toString()) ? widget.email : ""}",
        "MailId":
            "${widget.email?.length == 10 && isStringAnInteger(widget.email.toString()) ? "" : widget.email}",
        "Password": _passwordController.text.toString(),
      },
    );

    if (response['result']) {
      showCustomSnackbarSuccess(context, response['message']);
      pushNdRemove(LayoutLogin());
    } else {
      showCustomSnackbar(context, response['message']);
    }
  }

  bool isStringAnInteger(String value) {
    try {
      int.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }
}
