import 'package:flutter/material.dart';
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/components/decoration.dart';
import 'package:wms_mst/components/layout.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/components/responsive.dart';
import 'package:wms_mst/components/sidemenu.dart';
import 'package:wms_mst/ui/home/staff/edit_staff.dart';
import 'package:wms_mst/utils/button.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/navigation.dart';
import 'package:wms_mst/utils/reuse_widget.dart';
import 'package:wms_mst/utils/snackbar.dart';
import 'package:wms_mst/utils/textstyle.dart';

class GetStaffWidget extends StatefulWidget {
  const GetStaffWidget({super.key});

  @override
  State<GetStaffWidget> createState() => _GetStaffWidgetState();
}

class _GetStaffWidgetState extends State<GetStaffWidget> {
  //Data List
  List getStaffList = [];
  List<Map<String, dynamic>> deginationList = [];

  @override
  void initState() {
    setState(() {
      deginationData().then(
        (value) => getStaffApi().then((value) => setState(() {})),
      );
    });
    super.initState();
  }

  StyleText textStyles = StyleText();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Our Staff",
          overflow: TextOverflow.ellipsis,
          style: textStyles.abyssinicaSilText(
            22,
            FontWeight.w600,
            AppColor.white,
          ),
        ),
        backgroundColor: AppColor.primary,
      ),
      backgroundColor: AppColor.white,
      body: DecorationContainer(
        url: Images.other1,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: Sizes.height * 0.02,
            horizontal: 20,
          ),
          child: Column(
            children: [
              if (!Responsive.isDesktop(context))
                ...List.generate(getStaffList.length, (index) {
                  //Degination
                  int deginationId = getStaffList[index]['staff_Degination_Id'];
                  String deginationName =
                      deginationList.isEmpty
                          ? ''
                          : deginationList.firstWhere(
                            (element) => element['id'] == deginationId,
                            orElse: () => {'name': ''},
                          )['name'];

                  return Container(
                    margin: EdgeInsets.only(bottom: Sizes.height * 0.02),
                    width:
                        (!Responsive.isDesktop(context))
                            ? double.infinity
                            : Sizes.width * .48 - Sizes.width * .1 - 10,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(blurRadius: 2, color: AppColor.grey),
                      ],
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: ListTile(
                        minVerticalPadding: 0,
                        horizontalTitleGap: 0,
                        leading: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 7.5,
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            // '${getStaffList[index]?["id"] ?? 'N/A'}',
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                        title: Text(
                          '${getStaffList[index]?["staff_Name"] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColor.black,
                          ),
                        ),
                        trailing: Text(
                          getStaffList[index]?["userType"] == 'subadmin'
                              ? 'Sub-Admin'
                              : getStaffList[index]?["userType"] == 'staff'
                              ? 'Staff'
                              : 'Admin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.blue.withOpacity(.5),
                          ),
                        ),
                      ),
                      trailing: const SizedBox(width: 0, height: 0),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              datastyle(
                                "Joining Date:",
                                '${getStaffList[index]?["joining_Date"] ?? 'N/A'}',
                                context,
                              ),
                              datastyle(
                                "Mobile No.:",
                                '${getStaffList[index]?["mob"] ?? 'N/A'}',
                                context,
                              ),
                              datastyle(
                                "Father's Name:",
                                '${getStaffList[index]?["son_Off"] ?? 'N/A'}',
                                context,
                              ),
                              datastyle(
                                "Address:",
                                '${getStaffList[index]?["address"] ?? 'N/A'}',
                                context,
                              ),
                              datastyle(
                                "City:",
                                '${getStaffList[index]?["city_Name"] ?? 'N/A'}',
                                context,
                              ),
                              datastyle(
                                "State:",
                                '${getStaffList[index]?["state_Name"] ?? 'N/A'}',
                                context,
                              ),
                              datastyle(
                                "Pin Code:",
                                '${getStaffList[index]?["pin_Code"] ?? 'N/A'}',
                                context,
                              ),
                              datastyle("Degination:", deginationName, context),
                              datastyle(
                                "Password:",
                                '${getStaffList[index]?["password"] ?? 'N/A'}',
                                context,
                              ),
                              const Divider(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        var newData = await pushTo(
                                          AddStaff(
                                            isFirst: false,
                                            id: getStaffList[index]?["id"],
                                          ),
                                        );
                                        if (newData == null) {
                                          getStaffApi().then(
                                            (value) => setState(() {}),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        "Edit",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Preference.getString(PrefKeys.userType) !=
                                            "Admin"
                                        ? Container(width: 0)
                                        : TextButton(
                                          onPressed: () {
                                            deleteDialog(
                                              onPressed: () {
                                                deleteStaffApi(
                                                  getStaffList[index]?["id"],
                                                ).then((value) {
                                                  getStaffApi().then(
                                                    (value) => setState(() {
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    }),
                                                  );
                                                });
                                              },
                                            );
                                          },
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: AppColor.red,
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                })
              else
                getStaffList.isEmpty
                    ? Container()
                    : ReuseContainer(
                      isList: true,
                      text: "Staff List",
                      child: Table(
                        border: TableBorder.symmetric(
                          inside: const BorderSide(color: Color(0xff948A8A)),
                        ),
                        children: [
                          TableRow(
                            children: [
                              tableHeader("Name"),
                              tableHeader("Degination"),
                              tableHeader("Mobile No."),
                              tableHeader("Joining Date"),
                              tableHeader("City"),
                              tableHeader("Password"),
                              tableHeader("Action"),
                            ],
                          ),
                          ...List.generate(getStaffList.length, (index) {
                            //Degination
                            int deginationId =
                                getStaffList[index]['staff_Degination_Id'];
                            String deginationName =
                                deginationList.isEmpty
                                    ? ''
                                    : deginationList.firstWhere(
                                      (element) =>
                                          element['id'] == deginationId,
                                      orElse: () => {'name': ''},
                                    )['name'];

                            return TableRow(
                              children: [
                                tableRow(
                                  '${getStaffList[index]?["staff_Name"] ?? 'N/A'}',
                                ),
                                tableRow(deginationName),
                                tableRow(
                                  '${getStaffList[index]?["mob"] ?? 'N/A'}',
                                ),
                                tableRow(
                                  '${getStaffList[index]?["joining_Date"] ?? 'N/A'}',
                                ),
                                tableRow(
                                  "${getStaffList[index]?["city_Name"] ?? 'N/A'}",
                                ),
                                tableRow(
                                  "${getStaffList[index]?["password"] ?? 'N/A'}",
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        var newData = await pushTo(
                                          AddStaff(
                                            id: getStaffList[index]?["id"],
                                            isFirst: false,
                                          ),
                                        );
                                        if (newData == null) {
                                          getStaffApi().then(
                                            (value) => setState(() {}),
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                    Preference.getString(PrefKeys.userType) !=
                                            "Admin"
                                        ? Container(width: 0)
                                        : IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Delete Staff',
                                                  ),
                                                  content: const Text(
                                                    'Are you sure you want to delete staff ?',
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        deleteStaffApi(
                                                          getStaffList[index]?["id"],
                                                        ).then((value) {
                                                          getStaffApi().then(
                                                            (value) =>
                                                                setState(() {
                                                                  Navigator.of(
                                                                    context,
                                                                  ).pop();
                                                                }),
                                                          );
                                                        });
                                                      },
                                                      child: Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                          color: AppColor.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: AppColor.red,
                                          ),
                                        ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
              SizedBox(height: Sizes.height * .04),
              DefaultButton(
                hight: 45,
                width: 250,
                text: "+ Add Staff",
                onTap: () {
                  pushTo(AddStaff(isFirst: true, id: 0));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future deleteStaffApi(int? staffId) async {
    var response = await ApiService.postData(
      "UserController1/DeleteStaffById?Id=$staffId",
      {},
    );
    showCustomSnackbar(context, response['message']);
  }

  Future deginationData() async {
    await fetchDataByMiscTypeId(28, deginationList);
  }

  Future getStaffApi() async {
    var response = await ApiService.fetchData(
      "UserController1/GetStaffDetailsLocationwise?locationid=${Preference.getString(PrefKeys.locationId)}",
    );
    getStaffList = response;
  }

  deleteDialog({required void Function()? onPressed}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Staff'),
          content: const Text('Are you sure you want to delete staff ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: onPressed,
              child: Text('Delete', style: TextStyle(color: AppColor.red)),
            ),
          ],
        );
      },
    );
  }
}
