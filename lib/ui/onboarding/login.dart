import 'package:flutter/material.dart';
import 'package:wms_mst/components/api.dart' show ApiService;
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/components/responsive.dart';
import 'package:wms_mst/ui/home/dashboard/dashboard.dart';
import 'package:wms_mst/ui/onboarding/forgotpassword.dart';
import 'package:wms_mst/ui/onboarding/utils/outside.dart';
import 'package:wms_mst/ui/onboarding/signup.dart';
import 'package:wms_mst/utils/button.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/navigation.dart';
import 'package:wms_mst/utils/snackbar.dart';
import 'package:wms_mst/utils/textformfield.dart';
import 'package:wms_mst/utils/textstyle.dart';

class LayoutLogin extends StatefulWidget {
  const LayoutLogin({super.key});

  @override
  State<LayoutLogin> createState() => _LayoutLoginState();
}

class _LayoutLoginState extends State<LayoutLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  int selectedUserType = 0;
  StyleText textStyles = StyleText();
  @override
  void initState() {
    emailController.text = 'info.modernsoftwareonlinelead@gmail.com';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: OnboardingScreen(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: Sizes.height * 0.03),
                child: Image.asset(Images.logopng, height: Sizes.height * .15),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 43,
                    width:
                        Sizes.width < 850
                            ? Sizes.width * .7
                            : Sizes.width * .25,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.primary),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(2, (index) {
                      return InkWell(
                        onTap: () {
                          setState(() {});
                          selectedUserType = index;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: selectedUserType == index ? 45 : 41,
                          width:
                              selectedUserType == index
                                  ? Responsive.isTablet(context)
                                      ? Sizes.width * .17
                                      : !Responsive.isMobile(context)
                                      ? Sizes.width * .12
                                      : Sizes.width * .4
                                  : Responsive.isTablet(context)
                                  ? Sizes.width * .11
                                  : !Responsive.isMobile(context)
                                  ? Sizes.width * .08
                                  : Sizes.width * .3,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(5, 5),
                                blurRadius: 10,
                                color:
                                    selectedUserType == index
                                        ? AppColor.grey
                                        : AppColor.transparent,
                              ),
                            ],
                            color:
                                selectedUserType == index
                                    ? AppColor.grey
                                    : AppColor.transparent,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            index == 0 ? "Admin" : 'Staff',
                            style: textStyles.sarifProText(
                              18,
                              FontWeight.w500,
                              AppColor.primary,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: Sizes.height * 0.06),
              if (selectedUserType != 1)
                commonTextField(
                  emailController,
                  // readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  labelText: "Email Id",
                ),
              if (selectedUserType == 1)
                commonTextField(
                  usernameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Username";
                    }
                    return null;
                  },
                  labelText: "Username",
                ),
              SizedBox(height: Sizes.height * 0.02),
              commonTextField(
                passwordController,
                onFieldSubmitted: (p0) {
                  //  loginPostApi();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter password";
                  }
                  return null;
                },
                obscureText: _isObscure,
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),

              if (selectedUserType != 1)
                InkWell(
                  onTap: () {
                    pushTo(ForgotPassword());
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Forgot Password",
                      style: textStyles
                          .sarifProText(13, FontWeight.w400, AppColor.primary)
                          .copyWith(height: 2),
                    ),
                  ),
                )
              else
                SizedBox(height: 26),
              SizedBox(height: Sizes.height * 0.02),
              DefaultButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    loginPostApi();
                  }
                },
                hight: 45,
                width: Sizes.width < 850 ? Sizes.width * .5 : Sizes.width * .2,
                text: 'Login',
              ),

              SizedBox(height: Sizes.height * 0.02),
              InkWell(
                onTap: () {
                  pushTo(SignUp());
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: textStyles.sarifProText(
                    14,
                    FontWeight.w400,
                    AppColor.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future loginPostApi() async {
    final response = await ApiService.postData('Login/LOGINValid', {
      "MailId": emailController.text.toString(),
      "Password": passwordController.text.toString(),
      "UserType": selectedUserType == 0 ? "Admin" : "Staff",
      "UserName": usernameController.text.toString(),
    });

    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      Preference.setBool(PrefKeys.userstatus, response['result']);
      Preference.setString(PrefKeys.email, response['mailId']);
      Preference.setString(PrefKeys.phoneNumber, response['mob']);
      Preference.setString(PrefKeys.locationId, response['locationId']);
      Preference.setString(
        PrefKeys.userType,
        selectedUserType == 0 ? "Admin" : "Staff",
      );
      Preference.setString(PrefKeys.staffId, response['staffId'] ?? "0");
      pushNdRemove(const DashboardScreen());
    } else {
      showCustomSnackbar(context, response['message']);
    }
  }
}
