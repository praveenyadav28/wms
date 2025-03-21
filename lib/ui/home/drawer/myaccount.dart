// import 'package:flutter/material.dart';

// class MyAccount extends StatefulWidget {
//   const MyAccount({super.key});

//   @override
//   State<MyAccount> createState() => _MyAccountState();
// }

// class _MyAccountState extends State<MyAccount> {
//   TextEditingController gstNumberController = TextEditingController();
//   TextEditingController businesNameController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController mobileNumberController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController pinCodeController = TextEditingController();
//   TextEditingController dealerCodeController = TextEditingController();
//   TextEditingController jurdictionController = TextEditingController();
//   TextEditingController searchController = TextEditingController();

//   //City
//   List<Map<String, dynamic>> cityList = [];
//   List<Map<String, dynamic>> districtList = [];
//   int? cityId;
//   Map<String, dynamic>? cityValue;
//   String cityName = '';
//   String districtName = 'Unknown';
//   String stateName = 'Unknown';

//   //gst Applicable
//   bool isSwitched = false;

//   void _toggleSwitch(bool value) {
//     setState(() {
//       isSwitched = value;
//     });
//   }

//   @override
//   void initState() {
//     fetchDistrict().then((value) => setState(() {}));
//     fetchCity().then((value) => setState(() {}));
//     getAccountDetails().then((value) {
//       setState(() {});
//     });
//     super.initState();
//   }

//   String getimagepath = '';
//   File? _image;

//   @override
//   Widget build(BuildContext context) {
//     Uint8List bytes = base64Decode(getimagepath);
//     return Scaffold(
//       drawer: SideMenu(),
//       appBar: AppBar(
//         backgroundColor: AppColor.colPrimary,
//         centerTitle: true,
//         title: const Text("My Account", overflow: TextOverflow.ellipsis),
//       ),
//       backgroundColor: AppColor.colWhite,
//       body: Container(
//         color: AppColor.colPrimary.withOpacity(.1),
//         height: Sizes.height,
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(
//               vertical: Sizes.height * 0.02, horizontal: Sizes.width * .04),
//           child: ReuseContainer(
//             text: "My Account",
//             child: Column(
//               children: [
//                 // Stack(
//                 //   alignment: Alignment.bottomRight,
//                 //   children: [
//                 //     Container(
//                 //       width: 135,
//                 //       height: 135,
//                 //       decoration: BoxDecoration(
//                 //         shape: BoxShape.circle,
//                 //         color: AppColor.colPrimary.withOpacity(.2),
//                 //         image: _image != null
//                 //             ? DecorationImage(
//                 //                 image: FileImage(_image!), fit: BoxFit.cover)
//                 //             : getimagepath.isNotEmpty
//                 //                 ? DecorationImage(
//                 //                     image: MemoryImage(
//                 //                       bytes,
//                 //                       // You can specify other parameters such as width, height, fit, etc.
//                 //                     ),
//                 //                     fit: BoxFit.cover)
//                 //                 : null,
//                 //       ),
//                 //     ),
//                 //     InkWell(
//                 //       onTap: () {
//                 //         getImage();
//                 //       },
//                 //       child: CircleAvatar(
//                 //         maxRadius: 16,
//                 //         backgroundColor: AppColor.colPrimary,
//                 //         child: Icon(Icons.edit,
//                 //             size: 20, color: AppColor.colWhite),
//                 //       ),
//                 //     )
//                 //   ],
//                 // ),
//                 // SizedBox(height: Sizes.height * 0.04),

//                 addMasterOutside(children: [
//                   commonTextField(
//                     gstNumberController,
//                     labelText: 'GST Number',
//                     readOnly: !isSwitched,
//                     prefixIcon: const Icon(Icons.gesture),
//                     suffixIcon: Switch(
//                       value: isSwitched,
//                       onChanged: _toggleSwitch,
//                       activeTrackColor: AppColor.colPrimary.withOpacity(.2),
//                       activeColor: AppColor.colPrimary,
//                     ),
//                   ),
//                   commonTextField(businesNameController,
//                       labelText: 'Business Name',
//                       prefixIcon: const Icon(Icons.business)),
//                   commonTextField(descriptionController,
//                       labelText: 'Description',
//                       prefixIcon: const Icon(Icons.description)),
//                   commonTextField(emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       labelText: 'Email',
//                       prefixIcon: const Icon(Icons.mail)),
//                   commonTextField(mobileNumberController,
//                       keyboardType: TextInputType.phone,
//                       labelText: 'Mobile No.',
//                       prefixIcon: const Icon(Icons.phone)),
//                   commonTextField(addressController, labelText: 'Address'),
//                   coverTextField(
//                       context,
//                       "City*",
//                       searchDropDown(
//                           context,
//                           cityName.isEmpty ? "Select City*" : cityName,
//                           cityList
//                               .map((item) => DropdownMenuItem(
//                                     onTap: () {
//                                       setState(() {
//                                         cityId = item['city_Id'];
//                                         cityName = item['city_Name'];
//                                         int districtId =
//                                             item['district_Id'];
//                                         districtName = districtList
//                                                 .isEmpty
//                                             ? ""
//                                             : districtList.firstWhere(
//                                                     (element) =>
//                                                         element[
//                                                             'district_Id'] ==
//                                                         districtId)[
//                                                 'district_Name'];
//                                         stateName = districtList.isEmpty
//                                             ? ""
//                                             : districtList.firstWhere(
//                                                     (element) =>
//                                                         element[
//                                                             'district_Id'] ==
//                                                         districtId)[
//                                                 'state_Name'];
//                                       });
//                                     },
//                                     value: item,
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           item['city_Name'].toString(),
//                                           style: rubikTextStyle(
//                                               16,
//                                               FontWeight.w500,
//                                               AppColor.colBlack),
//                                         ),
//                                       ],
//                                     ),
//                                   ))
//                               .toList(),
//                           cityValue,
//                           (value) {
//                             setState(() {
//                               cityValue = value;
//                             });
//                           },
//                           searchController,
//                           (value) {
//                             setState(() {
//                               cityList
//                                   .where((item) => item['city_Name']
//                                       .toString()
//                                       .toLowerCase()
//                                       .contains(value.toLowerCase()))
//                                   .toList();
//                             });
//                           },
//                           'Search for a City...',
//                           (isOpen) {
//                             if (!isOpen) {
//                               searchController.clear();
//                             }
//                           })),
//                   coverTextField(
//                       context,
//                       "",
//                       datastyle("District", districtName, context,
//                           dense: true)),
//                   coverTextField(context, "",
//                       datastyle("State", stateName, context, dense: true)),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Expanded(
//                           child: commonTextField(pinCodeController,
//                               keyboardType: TextInputType.number,
//                               labelText: 'Pin Code')),
//                       const SizedBox(width: 10),
//                       Expanded(
//                           child: commonTextField(dealerCodeController,
//                               keyboardType: TextInputType.number,
//                               labelText: 'Dealer Code')),
//                     ],
//                   ),
//                   commonTextField(jurdictionController,
//                       labelText: 'Jurdiction'),
//                   Column(
//                     children: [
//                       button(
//                         "Save",
//                         AppColor.colPrimary,
//                         onTap: () async {
//                           String base64Image =
//                               "${_image != null ? convertImageToBase64(_image!) : getimagepath}";
//                           await postProfileApi(base64Image);
//                         },
//                       ),
//                     ],
//                   )
//                 ], context: context),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> getImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   Future<String> convertImageToBase64(File imageFile) async {
//     List<int> imageBytes = await imageFile.readAsBytes();
//     return base64Encode(imageBytes);
//   }

//   Future postProfileApi(String base64Image) async {
//     try {
//       Map<String, dynamic> response = await ApiService.postData(
//           "CRM/UpdateLocationById?Id=${Preference.getString(PrefKeys.locationId)}",
//           {
//             "ID": int.parse(Preference.getString(PrefKeys.locationId)),
//             "Lic_No": 1,
//             "Location_Name": businesNameController.text.toString(),
//             "Description": descriptionController.text.toString(),
//             "Address1": addressController.text.toString(),
//             "Address2": "Not Set Yet",
//             "City_Name": cityName,
//             "District_Name": districtName,
//             "State_Name": stateName,
//             "Pin_Code": pinCodeController.text.toString(),
//             "Std_Code": "Not Set Yet",
//             "Contact_No": mobileNumberController.text.toString(),
//             "BEmailId": emailController.text.toString(),
//             "BGSTINNO": gstNumberController.text.toString(),
//             "BLogoPath": base64Image,
//             "BLogo": "",
//             "BJuridiction": jurdictionController.text.toString(),
//             "BDealerCode": dealerCodeController.text.toString()
//           });
//       if (response['result'] != null && response['message'] != null) {
//         String message = response['message'];
//         showCustomSnackbarSuccess(context, message);
//       } else {}
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   Future getAccountDetails() async {
//     var response = await ApiService.fetchData(
//         "CRM/GetLocationById?LocationId=${Preference.getString(PrefKeys.locationId)}");

//     getimagepath = response["bLogoPath"];
//     gstNumberController.text = response["bgstinno"];
//     businesNameController.text = response["location_Name"];
//     descriptionController.text = response["description"];
//     emailController.text = response["bEmailId"];
//     mobileNumberController.text = response["contact_No"];
//     addressController.text = response["address1"];
//     pinCodeController.text = response["pin_Code"];
//     dealerCodeController.text = response["bDealerCode"];
//     jurdictionController.text = response["bJuridiction"];
//     stateName = response["state_Name"];
//     cityName = response["city_Name"];
//     districtName = response["district_Name"];
//     // return data;
//   }

//   // Get City List
//   Future fetchCity() async {
//     final response = await ApiService.fetchData("CRM/GetCity");

//     if (response is List) {
//       // Assuming it's a list, convert each item to a Map
//       cityList = response.map((item) => item as Map<String, dynamic>).toList();
//     } else {
//       throw Exception('Unexpected data format for cities');
//     }
//   }

//   // Get District List
//   Future fetchDistrict() async {
//     final response = await ApiService.fetchData("CRM/GetDistrict");

//     if (response is List) {
//       // Assuming it's a list, convert each item to a Map
//       districtList =
//           response.map((item) => item as Map<String, dynamic>).toList();
//     } else {
//       throw Exception('Unexpected data format for cities');
//     }
//   }
// }
//
