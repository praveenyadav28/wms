import 'package:flutter/material.dart';
import 'package:wms_mst/components/sidemenu.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/textstyle.dart';

class CompanyPolicy extends StatelessWidget {
  const CompanyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    StyleText textStyles = StyleText();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Company Policy",
          overflow: TextOverflow.ellipsis,
          style: textStyles.abyssinicaSilText(
            20,
            FontWeight.w600,
            AppColor.white,
          ),
        ),
        backgroundColor: AppColor.primary,
      ),
      drawer: SideMenu(),
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: Sizes.height * .02,
          horizontal: Sizes.width * .02,
        ),
        child: Column(
          children: [
            Text(
              "Data Protection and Privacy Policy",
              style: textStyles.sarifProText(
                25,
                FontWeight.w700,
                AppColor.primarydark,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: Sizes.height * .03),
              padding: EdgeInsets.symmetric(
                vertical: Sizes.height * .01,
                horizontal: Sizes.width * .02,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.grey),
              ),
              child: RichText(
                text: TextSpan(
                  style: textStyles.sarifProText(
                    16,
                    FontWeight.w400,
                    AppColor.black,
                  ), // Default text style
                  children: [
                    TextSpan(
                      text: "1. Purpose:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text:
                          "This policy is designed to ensure the confidentiality and protection of all personal, sensitive, and business-related data handled by our company, in compliance with relevant data protection regulations.\n\n",
                    ),
                    TextSpan(
                      text: "2. Scope:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text:
                          "This policy applies to all employees, contractors, and third-party service providers who handle data within the company.\n\n",
                    ),
                    TextSpan(
                      text: "3. Data Collection and Use:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text: "Types of Data Collected:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " We collect personal and business data necessary for our operations, such as contact details, financial information, and other relevant data.\n\n",
                    ),
                    TextSpan(
                      text: "Use of Data:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " The data is used exclusively for business operations such as client management, billing, and project execution. We do not use or share data for purposes outside the scope of our services.\n\n",
                    ),
                    TextSpan(
                      text: "4. Data Storage and Security:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text: "Data Storage:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " All personal and client data is securely stored on Amazon Web Services (AWS) servers, protected by encryption, firewalls, and multiple layers of access control.\n\n",
                    ),
                    TextSpan(
                      text: "Access Control:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Data stored on AWS servers is highly protected, and our company does not have direct access to any client data unless explicitly authorized.\n\n",
                    ),
                    TextSpan(
                      text: "Security Measures:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " AWS employs encryption, physical security controls, and advanced threat detection to protect data.\n\n",
                    ),
                    TextSpan(
                      text: "5. Access and Sharing of Data:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text: "Employee Access to Data:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Employees can only access data on a need-to-know basis and when explicitly authorized by the client.\n\n",
                    ),
                    TextSpan(
                      text: "Data Sharing with Third Parties:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Third-party service providers are contractually obligated to adhere to the same data protection standards.\n\n",
                    ),
                    TextSpan(
                      text: "6. Data Handling Responsibilities:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text: "Confidentiality:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Employees must maintain strict confidentiality regarding any data handled.\n\n",
                    ),
                    TextSpan(
                      text: "Data Handling:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Accidental breaches must be reported immediately.\n\n",
                    ),
                    TextSpan(
                      text: "7. Data Breach and Incident Reporting:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text: "Reporting a Data Breach:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Employees must report incidents immediately to the Data Protection Officer.\n\n",
                    ),
                    TextSpan(
                      text: "Breach Consequences:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Employees involved in a breach may face disciplinary action.\n\n",
                    ),
                    TextSpan(
                      text: "8. Employee Rights:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text: "Right to Access:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Employees and clients can request access to their personal data.\n\n",
                    ),
                    TextSpan(
                      text: "Right to Rectify or Delete Data:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Clients can request corrections or deletion of personal data.\n\n",
                    ),
                    TextSpan(
                      text: "9. Compliance with Laws:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text:
                          "The company complies with all applicable data protection laws, including the General Data Protection Regulation (GDPR) and local regulations. Any necessary changes to this policy will be made in accordance with legal updates or changes in business practices.\n\n",
                    ),
                    TextSpan(
                      text: "10. Conclusion:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text:
                          "We prioritize the privacy and security of your data. By using Amazon Web Services (AWS), one of the safest and most secure server environments globally, we ensure that client data is protected with the highest standards. Access to your data is strictly controlled, and we only interact with it when explicitly requested by you, the client\n\n\n",
                    ),
                    //  TextSpan(
                    //     text: "1. Purpose:\n",
                    //     style: textStyles.sarifProText(
                    //       18,
                    //       FontWeight.w600,
                    //       AppColor.black,
                    //     ),
                    //   ),
                    //   TextSpan(
                    //     text:
                    //         "This policy aims to ensure the responsible use of the internet and the protection of sensitive data, in line with relevant legal obligations such as the General Data Protection Regulation (GDPR) and the Information Technology Act, 2000.\n\n",
                    //   ),
                    //   TextSpan(
                    //     text: "1. Purpose:\n",
                    //     style: textStyles.sarifProText(
                    //       18,
                    //       FontWeight.w600,
                    //       AppColor.black,
                    //     ),
                    //   ),
                    //   TextSpan(
                    //     text:
                    //         "This policy aims to ensure the responsible use of the internet and the protection of sensitive data, in line with relevant legal obligations such as the General Data Protection Regulation (GDPR) and the Information Technology Act, 2000.\n\n",
                    //   ),
                    //   TextSpan(
                    //     text: "1. Purpose:\n",
                    //     style: textStyles.sarifProText(
                    //       18,
                    //       FontWeight.w600,
                    //       AppColor.black,
                    //     ),
                    //   ),
                    //   TextSpan(
                    //     text:
                    //         "This policy aims to ensure the responsible use of the internet and the protection of sensitive data, in line with relevant legal obligations such as the General Data Protection Regulation (GDPR) and the Information Technology Act, 2000.\n\n",
                    //   ),
                  ],
                ),
              ),
            ),

            Text(
              "Internet Use and Data Protection Policy",
              style: textStyles.sarifProText(
                25,
                FontWeight.w700,
                AppColor.primarydark,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: Sizes.height * .03),
              padding: EdgeInsets.symmetric(
                vertical: Sizes.height * .01,
                horizontal: Sizes.width * .02,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.grey),
              ),
              child: RichText(
                text: TextSpan(
                  style: textStyles.sarifProText(
                    16,
                    FontWeight.w400,
                    AppColor.black,
                  ), // Default text style
                  children: [
                    TextSpan(
                      text: "1. Purpose:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text:
                          "This policy is designed to ensure the confidentiality and protection of all personal, sensitive, and business-related data handled by our company, in compliance with relevant data protection regulations.\n\n",
                    ),
                    TextSpan(
                      text: "2. Scope:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text:
                          "This policy applies to all employees, contractors, and third-party service providers who handle data within the company.\n\n",
                    ),
                    TextSpan(
                      text: "3. Data Collection and Use:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text: "• Types of Data Collected:",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          "   We collect personal and business data necessary for our operations, such as contact details, financial information, and other relevant data.\n\n",
                    ),
                    TextSpan(
                      text: "⦿ Use of Data:\n",
                      // style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          "   The data is used exclusively for business operations such as client management, billing, and project execution. We do not use or share data for purposes outside the scope of our services.\n\n",
                    ),
                    TextSpan(
                      text: "4. Data Storage and Security:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text: "Data Storage:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " All personal and client data is securely stored on Amazon Web Services (AWS) servers, protected by encryption, firewalls, and multiple layers of access control.\n\n",
                    ),
                    TextSpan(
                      text: "Access Control:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Data stored on AWS servers is highly protected, and our company does not have direct access to any client data unless explicitly authorized.\n\n",
                    ),
                    TextSpan(
                      text: "Security Measures:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " AWS employs encryption, physical security controls, and advanced threat detection to protect data.\n\n",
                    ),
                    TextSpan(
                      text: "5. Access and Sharing of Data:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text: "Employee Access to Data:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Employees can only access data on a need-to-know basis and when explicitly authorized by the client.\n\n",
                    ),
                    TextSpan(
                      text: "Data Sharing with Third Parties:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Third-party service providers are contractually obligated to adhere to the same data protection standards.\n\n",
                    ),
                    TextSpan(
                      text: "6. Data Handling Responsibilities:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text: "Confidentiality:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Employees must maintain strict confidentiality regarding any data handled.\n\n",
                    ),
                    TextSpan(
                      text: "Data Handling:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Accidental breaches must be reported immediately.\n\n",
                    ),
                    TextSpan(
                      text: "7. Data Breach and Incident Reporting:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text: "Reporting a Data Breach:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Employees must report incidents immediately to the Data Protection Officer.\n\n",
                    ),
                    TextSpan(
                      text: "Breach Consequences:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Employees involved in a breach may face disciplinary action.\n\n",
                    ),
                    TextSpan(
                      text: "8. Employee Rights:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text: "Right to Access:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Employees and clients can request access to their personal data.\n\n",
                    ),
                    TextSpan(
                      text: "Right to Rectify or Delete Data:\n",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text:
                          " Clients can request corrections or deletion of personal data.\n\n",
                    ),
                    TextSpan(
                      text: "9. Compliance with Laws:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text:
                          "The company complies with all applicable data protection laws, including the General Data Protection Regulation (GDPR) and local regulations. Any necessary changes to this policy will be made in accordance with legal updates or changes in business practices.\n\n",
                    ),
                    TextSpan(
                      text: "10. Conclusion:\n",
                      style: textStyles.sarifProText(
                        18,
                        FontWeight.w600,
                        AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text:
                          "We prioritize the privacy and security of your data. By using Amazon Web Services (AWS), one of the safest and most secure server environments globally, we ensure that client data is protected with the highest standards. Access to your data is strictly controlled, and we only interact with it when explicitly requested by you, the client\n",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
