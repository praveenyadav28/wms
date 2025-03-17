// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/ui/onboarding/login.dart';
import 'package:wms_mst/ui/onboarding/utils/emailpatern.dart';
import 'package:wms_mst/ui/onboarding/utils/outside.dart';
import 'package:wms_mst/utils/appbar.dart';
import 'package:wms_mst/utils/button.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/navigation.dart';
import 'package:wms_mst/utils/snackbar.dart';
import 'package:wms_mst/utils/textformfield.dart';

class BusinessDetails extends StatefulWidget {
  BusinessDetails({required this.phoneNumber, super.key});
  String phoneNumber;
  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController businessController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isObscure = true;
  bool isload = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: OnboardingScreen(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppbarClass(title: 'Business Details'),
              SizedBox(height: Sizes.height * .04),
              commonTextField(
                nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter Company Name";
                  }
                  return null;
                },
                labelText: "Company Name",
              ),
              SizedBox(height: Sizes.height * 0.02),
              commonTextField(
                ownerController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter owner name";
                  }
                  return null;
                },
                labelText: "Owner Name",
              ),
              SizedBox(height: Sizes.height * 0.02),
              commonTextField(
                businessController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter business type";
                  }
                  return null;
                },
                labelText: "Business Type",
              ),
              SizedBox(height: Sizes.height * 0.02),
              commonTextField(
                addressController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter address";
                  }
                  return null;
                },
                labelText: "Address",
              ),
              SizedBox(height: Sizes.height * 0.02),
              commonTextField(emailController,
                  keyboardType: TextInputType.emailAddress, validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter email id";
                } else if (!emailPattern
                    .hasMatch(emailController.text.toString())) {
                  return 'Please enter valid email';
                }
                return null;
              }, labelText: "Email id"),
              SizedBox(height: Sizes.height * 0.02),
              commonTextField(
                passwordController,
                validator: (value) {
                  if (value!.isEmpty && value.length < 6) {
                    return "Please enter minimum 6 digit";
                  }
                  return null;
                },
                labelText: "Create Password",
                obscureText: _isObscure,
                suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    }),
              ),
              SizedBox(height: Sizes.height * 0.04),
              isload == true
                  ? const CircularProgressIndicator()
                  :   DefaultButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                     isload = true;
                          busenissPostApi().then((value) => setState(() {
                                isload = false;
                              }));
                  }
                },
                hight: 45,
                width: Sizes.width < 850 ? Sizes.width * .5 : Sizes.width * .2,
                text: 'Submit',
              ),
               
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }

  Future busenissPostApi() async {
    final response = await ApiService.postData('Login/SignUP', {
      "CompanyName": nameController.text.toString(),
      "OwnerName": ownerController.text.toString(),
      "BusinessType": businessController.text.toString(),
      "Address1": addressController.text.toString(),
      "MOB": widget.phoneNumber,
      "MailId": emailController.text.toString(),
      "UserValid": "1",
      "Password": passwordController.text.toString()
    });

    if (response['result']) {
      showCustomSnackbarSuccess(context, response['message']);
      pushNdRemove(const LayoutLogin());
    } else {
      showCustomSnackbar(context, response['message']);
    }
    isload = false;
  }
}
