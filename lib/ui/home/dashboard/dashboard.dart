import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/components/decoration.dart';
import 'package:wms_mst/components/layout.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/components/responsive.dart';
import 'package:wms_mst/components/sidemenu.dart';
import 'package:wms_mst/model/group.dart';
import 'package:wms_mst/ui/home/dashboard/chartdata.dart';
import 'package:wms_mst/ui/home/dashboard/customer_status.dart';
import 'package:wms_mst/ui/home/dashboard/fileinfo.dart';
import 'package:wms_mst/ui/home/dashboard/filterview/customer_status.dart';
import 'package:wms_mst/ui/home/dashboard/filterview/priority.dart';
import 'package:wms_mst/ui/home/dashboard/filterview/productview.dart';
import 'package:wms_mst/ui/home/dashboard/search_prospect.dart';
import 'package:wms_mst/ui/home/drawer.dart/easy_notes/notes.dart';
import 'package:wms_mst/ui/home/prospect/add_prospect.dart';
import 'package:wms_mst/utils/button.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/navigation.dart';
import 'package:wms_mst/utils/textformfield.dart';
import 'package:wms_mst/utils/textstyle.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //Prieority List
  List priorityGetList = [];

  //CustomerType List
  List customerTypeGetList = [];
  List customerTypeList = [];

  //Enquery List
  List productGetList = [];
  List productList = [];
  //colorList
  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.deepOrange,
    Color.fromARGB(255, 6, 219, 173),
  ];

  List<Map<String, dynamic>> dataList = [];

  bool onReminderHower = false;
  bool onPriorityHower = false;
  bool onEnqueryHower = false;
  bool onCSHower = false;
  bool onCTHower = false;

  List<Staffmodel> salesmanList = [];
  int? salesmanId;

  List<Map<String, dynamic>> reminders = [];
  List<Map<String, dynamic>> todayreminders = [];
  Timer? _timer;
  List<Note> _notes = [];

  @override
  void initState() {
    _loadReminders();
    _startReminderCheck();
    staffData().then((value) => setState(() {}));
    getPriorityApi().then((value) => setState(() {}));
    getcustomerTypeApi().then((value) => setState(() {}));
    getenqueryApi().then((value) => setState(() {}));
    getallprospactGrid().then((value) => setState(() {}));
    customerTypeData();
    productData();
    _loadNotes();
    super.initState();
  }

  void _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notesString = prefs.getStringList('notes');
    if (notesString != null) {
      setState(() {
        _notes = notesString.map((e) => Note.fromJson(jsonDecode(e))).toList();
      });
    }
  }

  Future<void> _loadReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedReminders = prefs.getStringList('reminders');
    if (savedReminders != null) {
      reminders =
          savedReminders
              .map((e) => json.decode(e))
              .toList()
              .cast<Map<String, dynamic>>();
    }
    setState(() {});
  }

  Future<void> _saveReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedReminders = reminders.map((e) => json.encode(e)).toList();
    await prefs.setStringList('reminders', savedReminders);
  }

  void _startReminderCheck() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _checkReminders();
    });
  }

  void _checkReminders() {
    DateTime now = DateTime.now();
    DateTime checkstatus = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );
    reminders.removeWhere((reminder) {
      DateTime reminderTime = DateTime.parse(reminder['dateTime']);

      if (checkstatus == reminderTime ||
          checkstatus == reminderTime.subtract(Duration(minutes: 5))) {
        setState(() {
          playNotificationSound();
        });
        return false;
      } else if (checkstatus.difference(reminderTime).inDays > 1) {
        return true; // Delete if older than 1 day
      }
      return false;
    });
    _saveReminders();
  }

  void _addReminder(DateTime selectedTime, String title) {
    reminders.add({
      "title": title,
      'dateTime': selectedTime.toIso8601String(),
      'notified': false,
    });
    _saveReminders();
    setState(() {});
  }

  void _deleteReminder(int index) {
    reminders.removeAt(index);
    _saveReminders();
    setState(() {});
  }

  Future<void> _pickDateTime(BuildContext context) async {
    TextEditingController titleController = TextEditingController();

    // Show dialog to enter the reminder title
    String? title = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Enter Reminder Title",
            style: textStyles.sarifProText(
              16,
              FontWeight.w600,
              AppColor.primary,
            ),
          ),
          content: SizedBox(
            height: 50,
            child: commonTextField(
              titleController,
              labelText: "Reminder title",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null), // Cancel
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed:
                  () => Navigator.pop(
                    context,
                    titleController.text,
                  ), // Save title
              child: Text("OK"),
            ),
          ],
        );
      },
    );

    if (title == null || title.isEmpty) return; // Exit if no title entered

    // Pick date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Pick time
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine date & time
        DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Store in the list
        setState(() {
          _addReminder(finalDateTime, title);
        });

        print("Reminder Added: $title at $finalDateTime");
      }
    }
  }

  Future<void> playNotificationSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource('notification.wav'));
  }

  TextEditingController datepickarfrom = TextEditingController(
    text: DateFormat(
      'yyyy/MM/dd',
    ).format(DateTime.now().subtract(Duration(days: 60))),
  );
  TextEditingController datepickarto = TextEditingController(
    text: DateFormat(
      'yyyy/MM/dd',
    ).format(DateTime.now().add(Duration(days: 30))),
  );
  StyleText textStyles = StyleText();
  @override
  Widget build(BuildContext context) {
    dataList = [
      {
        "icon":
            "https://github.com/praveenyadav28/wms-images/blob/main/icon/17806297%201.png?raw=true",
        "title": "Enquery Punched Today",
        "users": "$punchedToday",
      },
      {
        "icon":
            "https://github.com/praveenyadav28/wms-images/blob/main/icon/17806420%201.png?raw=true",
        "title": "Tomorrow’s Follow-up",
        "users": "$folowupTomorrow",
      },
      {
        "icon":
            "https://github.com/praveenyadav28/wms-images/blob/main/icon/17806211%201.png?raw=true",
        "title": "Today’s Follow-up",
        "users": "$followupToday",
      },
      {
        "icon":
            "https://github.com/praveenyadav28/wms-images/blob/main/icon/17806386%201.png?raw=true",
        "title": "Weekly Lead",
        "users": "$weeklyLead",
      },
      {
        "icon":
            "https://github.com/praveenyadav28/wms-images/blob/main/icon/17806281%201.png?raw=true",
        "title": "Today’s Demo ",
        "users": "$demoToday",
      },
    ];
    todayreminders =
        reminders.isEmpty
            ? []
            : reminders
                .where(
                  (reminderdata) =>
                      DateTime.parse(reminderdata['dateTime']).day ==
                      DateTime.now().day,
                )
                .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        centerTitle: true,
        title: Text(
          "WMS- MST Pvt Ltd.",
          overflow: TextOverflow.ellipsis,
          style: textStyles.abyssinicaSilText(
            25,
            FontWeight.w600,
            AppColor.white,
          ),
        ),
      ),
      drawer: SideMenu(),
      body: DecorationContainer(
        url: Images.dashbordBackground,
        child:
            priorityGetList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                  onRefresh: () async {
                    staffData().then((value) => setState(() {}));
                    getPriorityApi().then((value) => setState(() {}));
                    getcustomerTypeApi().then((value) => setState(() {}));
                    getenqueryApi().then((value) => setState(() {}));
                    getallprospactGrid().then((value) => setState(() {}));
                    customerTypeData();
                    productData();
                  },
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: Sizes.width * 0.04,
                      right: Sizes.width * 0.04,
                      bottom: Sizes.width * 0.04,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width:
                              Sizes.width < 1000
                                  ? Sizes.width
                                  : Sizes.width < 1300
                                  ? Sizes.width * .7
                                  : Sizes.width * .6,
                          padding: EdgeInsets.symmetric(
                            horizontal: Sizes.width * .02,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xff270C3D),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                          child: Wrap(
                            spacing: Sizes.width * .03,
                            children: [
                              SizedBox(
                                width: 300,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  dense: true,
                                  horizontalTitleGap: 0,
                                  title: Text(
                                    'Target of Month  :',
                                    style: textStyles.adlamText(
                                      19,
                                      FontWeight.w400,
                                      AppColor.white,
                                    ),
                                  ),
                                  trailing: Container(
                                    height: 28,
                                    alignment: Alignment.center,
                                    width: 90,
                                    decoration: insideShadow(
                                      color: AppColor.white,
                                      radius: 3,
                                    ),
                                    child: Text(
                                      "70,000",
                                      style: textStyles.abyssinicaSilText(
                                        17,
                                        FontWeight.w700,
                                        AppColor.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 300,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  horizontalTitleGap: 0,
                                  dense: true,
                                  title: Text(
                                    'Target of Week  :',
                                    style: textStyles.adlamText(
                                      19,
                                      FontWeight.w400,
                                      AppColor.white,
                                    ),
                                  ),
                                  trailing: Container(
                                    height: 28,
                                    width: 90,
                                    alignment: Alignment.center,
                                    decoration: insideShadow(
                                      color: AppColor.white,
                                      radius: 3,
                                    ),
                                    child: Text(
                                      "15,000",
                                      style: textStyles.abyssinicaSilText(
                                        17,
                                        FontWeight.w700,
                                        AppColor.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 300,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  dense: true,

                                  horizontalTitleGap: 0,
                                  title: Text(
                                    'Recieved  :',
                                    style: textStyles.adlamText(
                                      19,
                                      FontWeight.w400,
                                      AppColor.white,
                                    ),
                                  ),
                                  trailing: Container(
                                    height: 28,
                                    width: 90,
                                    alignment: Alignment.center,
                                    decoration: insideShadow(
                                      color: AppColor.white,
                                      radius: 3,
                                    ),
                                    child: Text(
                                      "30,000",
                                      style: textStyles.abyssinicaSilText(
                                        17,
                                        FontWeight.w700,
                                        AppColor.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 300,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  dense: true,
                                  horizontalTitleGap: 0,
                                  title: Text(
                                    'Recieved  :',
                                    style: textStyles.adlamText(
                                      19,
                                      FontWeight.w400,
                                      AppColor.white,
                                    ),
                                  ),
                                  trailing: Container(
                                    height: 28,
                                    width: 90,
                                    alignment: Alignment.center,
                                    decoration: insideShadow(
                                      color: AppColor.white,
                                      radius: 3,
                                    ),
                                    child: Text(
                                      "10,000",
                                      style: textStyles.abyssinicaSilText(
                                        17,
                                        FontWeight.w700,
                                        AppColor.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Sizes.height * .03),
                        FileInfoCard(dataList: dataList),
                        SizedBox(height: Sizes.height * 0.03),
                        SizedBox(
                          width: Sizes.width,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onHover: (value) {
                                  setState(() {
                                    onReminderHower = value;
                                  });
                                },
                                onTap: () {},
                                child: Container(
                                  height: Sizes.height * .4,
                                  width: Sizes.width * .25,
                                  decoration: BoxDecoration(
                                    boxShadow:
                                        !onReminderHower
                                            ? [
                                              BoxShadow(
                                                offset: Offset(0, 2),
                                                blurRadius: 3,
                                                spreadRadius: 0,
                                              ),
                                            ]
                                            : [
                                              BoxShadow(
                                                blurRadius: 8,
                                                color: const Color.fromARGB(
                                                  255,
                                                  51,
                                                  83,
                                                  136,
                                                ),
                                                offset: Offset(2, 5),
                                              ),
                                              BoxShadow(
                                                blurRadius: 8,
                                                color: const Color.fromARGB(
                                                  255,
                                                  59,
                                                  89,
                                                  141,
                                                ),
                                                offset: Offset(-2, 0),
                                              ),
                                            ],
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Color(0xffD9D9D9),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: Container()),
                                          Expanded(
                                            flex: 3,
                                            child: Center(
                                              child: Text(
                                                "Upcoming Reminder",
                                                style: textStyles.sarifProText(
                                                  16,
                                                  FontWeight.w900,
                                                  AppColor.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: IconButton(
                                              // icon: Image.asset(
                                              //   "assets/Filters.png",
                                              // ),
                                              icon: Icon(Icons.add),
                                              onPressed:
                                                  () => _pickDateTime(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ...List.generate(todayreminders.length, (
                                        index,
                                      ) {
                                        var date = DateTime.parse(
                                          todayreminders[index]["dateTime"],
                                        );
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                AppColor.transparent,
                                            backgroundImage: AssetImage(
                                              "assets/outside.png",
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                6.0,
                                              ),
                                              child: Image.asset(
                                                "assets/notification.png",
                                              ),
                                            ),
                                          ),
                                          horizontalTitleGap: 20,
                                          title: Text(
                                            todayreminders[index]["title"],
                                            style: textStyles.abyssinicaSilText(
                                              16,
                                              FontWeight.w600,
                                              AppColor.black,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${date.hour}:${date.minute}",
                                            style: textStyles.abyssinicaSilText(
                                              15,
                                              FontWeight.w500,
                                              AppColor.grey,
                                            ),
                                          ),
                                          trailing: IconButton(
                                            onPressed: () {
                                              _deleteReminder(index);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: AppColor.red,
                                              size: 20,
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: Sizes.height * .47,
                                width: Sizes.width * .63,
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    width: 4,
                                    color: AppColor.primarydark,
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.only(
                                    bottom: Sizes.height * .02,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: Container()),
                                          Expanded(
                                            flex: 3,
                                            child: Center(
                                              child: Text(
                                                "Your Notes",
                                                style: textStyles.sarifProText(
                                                  16,
                                                  FontWeight.w900,
                                                  AppColor.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: IconButton(
                                              // icon: Image.asset(
                                              //   "assets/Filters.png",
                                              // ),
                                              icon: Icon(Icons.add),
                                              onPressed: () async {
                                                var somedata = await pushTo(
                                                  NotesScreen(),
                                                );
                                                if (somedata != null) {
                                                  _loadNotes();
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      SizedBox(
                                        width: Sizes.width * .63,
                                        child: Wrap(
                                          runSpacing: Sizes.height * .02,

                                          alignment: WrapAlignment.spaceEvenly,
                                          children: [
                                            ...List.generate(_notes.length, (
                                              index,
                                            ) {
                                              return SizedBox(
                                                width:
                                                    Sizes.width > 1000
                                                        ? Sizes.width * .19
                                                        : Sizes.width > 700
                                                        ? Sizes.width * .3
                                                        : Sizes.width * .5,

                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 8,
                                                  ),

                                                  decoration: BoxDecoration(
                                                    color:
                                                        _notes[index]
                                                            .backgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 2,
                                                        color: AppColor.black
                                                            .withValues(
                                                              alpha: .2,
                                                            ),
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),

                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      _notes[index].title
                                                                  .trim()
                                                                  .isEmpty &&
                                                              _notes[index]
                                                                  .title
                                                                  .trim()
                                                                  .isEmpty
                                                          ? SizedBox(
                                                            width: 0,
                                                            height: 0,
                                                          )
                                                          : ListTile(
                                                            contentPadding:
                                                                EdgeInsets.zero,

                                                            title: Text(
                                                              _notes[index]
                                                                  .title,
                                                              style: textStyles
                                                                  .sarifProText(
                                                                    16,
                                                                    FontWeight
                                                                        .w600,
                                                                    AppColor
                                                                        .black,
                                                                  ),
                                                            ),

                                                            subtitle: Text(
                                                              _notes[index]
                                                                  .content,
                                                              style: textStyles
                                                                  .sarifProText(
                                                                    14,
                                                                    FontWeight
                                                                        .w500,
                                                                    AppColor
                                                                        .black,
                                                                  ),
                                                            ),
                                                            trailing: IconButton(
                                                              icon: Icon(
                                                                Icons.delete,
                                                                color:
                                                                    AppColor
                                                                        .red,
                                                                size: 20,
                                                              ),
                                                              onPressed:
                                                                  () =>
                                                                      _deleteNote(
                                                                        index,
                                                                      ),
                                                            ),
                                                          ),

                                                      if (_notes[index]
                                                          .tasks
                                                          .isNotEmpty) ...[
                                                        ListTile(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          title: Text(
                                                            "Tasks:",
                                                            style: textStyles
                                                                .sarifProText(
                                                                  14,
                                                                  FontWeight
                                                                      .w600,
                                                                  AppColor
                                                                      .primary,
                                                                ),
                                                          ),
                                                          trailing:
                                                              _notes[index]
                                                                          .title
                                                                          .trim()
                                                                          .isEmpty &&
                                                                      _notes[index]
                                                                          .title
                                                                          .trim()
                                                                          .isEmpty
                                                                  ? IconButton(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color:
                                                                          AppColor
                                                                              .red,
                                                                    ),
                                                                    onPressed:
                                                                        () => _deleteNote(
                                                                          index,
                                                                        ),
                                                                  )
                                                                  : SizedBox(
                                                                    width: 0,
                                                                    height: 0,
                                                                  ),
                                                        ),

                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: List.generate(
                                                            _notes[index]
                                                                .tasks
                                                                .length,
                                                            (taskIndex) {
                                                              return CheckboxListTile(
                                                                dense: true,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                title: Text(
                                                                  _notes[index]
                                                                      .tasks[taskIndex]
                                                                      .text,
                                                                  style: textStyles
                                                                      .sarifProText(
                                                                        14,
                                                                        FontWeight
                                                                            .w500,
                                                                        AppColor
                                                                            .grey,
                                                                      ),
                                                                ),
                                                                value:
                                                                    _notes[index]
                                                                        .tasks[taskIndex]
                                                                        .isChecked,
                                                                onChanged:
                                                                    (
                                                                      _,
                                                                    ) => _toggleTask(
                                                                      index,
                                                                      taskIndex,
                                                                    ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                            _notes.length % 3 == 2
                                                ? Container(
                                                  width:
                                                      Sizes.width > 1000
                                                          ? Sizes.width * .19
                                                          : Sizes.width > 700
                                                          ? Sizes.width * .3
                                                          : Sizes.width * .5,
                                                )
                                                : _notes.length % 3 == 1
                                                ? Container(
                                                  width:
                                                      Sizes.width > 1000
                                                          ? Sizes.width * .38
                                                          : Sizes.width > 700
                                                          ? Sizes.width * .6
                                                          : Sizes.width * 1,
                                                )
                                                : Container(width: 0),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Sizes.height * .04),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: addMasterOutside(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Find Prospect  ',
                                  style: textStyles.sarifProText(
                                    18,
                                    FontWeight.w600,
                                    AppColor.primarydark,
                                  ),
                                ),
                              ),
                              DateRange(
                                datepickar1: datepickarfrom,
                                datepickar2: datepickarto,
                              ),
                              DoubleDropdown(
                                staffDropdown: CoverTextField(
                                  widget: DropdownButton(
                                    underline: Container(),
                                    isDense: true,
                                    hint: Text(
                                      'Select Staff',
                                      style: textStyles.sarifProText(
                                        16,
                                        FontWeight.w700,
                                        AppColor.black,
                                      ),
                                    ),
                                    isExpanded: true,
                                    value: salesmanId,
                                    items:
                                        salesmanList.map((employee) {
                                          return DropdownMenuItem(
                                            value: employee.id,
                                            child: Text(
                                              employee.staffName,
                                              style: textStyles
                                                  .abyssinicaSilText(
                                                    18,
                                                    FontWeight.w700,
                                                    AppColor.black,
                                                  ),
                                            ),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        salesmanId = value;
                                      });
                                    },
                                  ),
                                ),
                                child: DefaultButton(
                                  text: '🔎 Find',
                                  buttonColor: AppColor.white,
                                  textColor: AppColor.black,
                                  hight: 45,
                                  width: double.infinity,
                                  onTap: () {
                                    setState(() {
                                      getPriorityApi().then(
                                        (value) => setState(() {}),
                                      );
                                      getcustomerTypeApi().then(
                                        (value) => setState(() {}),
                                      );
                                      getenqueryApi().then(
                                        (value) => setState(() {}),
                                      );
                                      customerTypeData().then(
                                        (value) => setState(() {}),
                                      );
                                    });
                                  },
                                ),
                              ),
                            ],
                            context: context,
                          ),
                        ),
                        SizedBox(height: Sizes.height * .04),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: Sizes.height * 0.02,
                          spacing: Sizes.width * 0.02,
                          children: [
                            InkWell(
                              onHover: (value) {
                                setState(() {
                                  onPriorityHower = value;
                                });
                              },
                              onTap: () {
                                pushTo(PriorityViewScreen());
                              },
                              child: Container(
                                width:
                                    (Responsive.isMobile(context))
                                        ? double.infinity
                                        : Sizes.width * 0.45,
                                padding: EdgeInsets.symmetric(
                                  vertical: Sizes.height * 0.01,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  boxShadow:
                                      !onPriorityHower
                                          ? [
                                            BoxShadow(
                                              offset: Offset(0, 2),
                                              blurRadius: 3,
                                              spreadRadius: 0,
                                            ),
                                          ]
                                          : [
                                            BoxShadow(
                                              blurRadius: 8,
                                              color: const Color.fromARGB(
                                                255,
                                                51,
                                                83,
                                                136,
                                              ),
                                              offset: Offset(2, 5),
                                            ),
                                            BoxShadow(
                                              blurRadius: 8,
                                              color: const Color.fromARGB(
                                                255,
                                                59,
                                                89,
                                                141,
                                              ),
                                              offset: Offset(-2, 0),
                                            ),
                                          ],
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: SfCircularChart(
                                  title: ChartTitle(
                                    text: "Priority Chart",
                                    textStyle: textStyles.abyssinicaSilText(
                                      18,
                                      FontWeight.w600,
                                      AppColor.primary,
                                    ),
                                    alignment: ChartAlignment.center,
                                  ),
                                  legend: Legend(isVisible: true),
                                  series: <PieSeries<SalesData, String>>[
                                    PieSeries<SalesData, String>(
                                      dataSource: <SalesData>[
                                        SalesData(
                                          'Hot',
                                          double.parse(
                                            "${priorityGetList[2]['prospectDetails'].length}",
                                          ),
                                        ),
                                        SalesData(
                                          'Normal',
                                          double.parse(
                                            "${priorityGetList[1]['prospectDetails'].length}",
                                          ),
                                        ),
                                        SalesData(
                                          'Cold',
                                          double.parse(
                                            "${priorityGetList[0]['prospectDetails'].length}",
                                          ),
                                        ),
                                      ],
                                      pointColorMapper: (SalesData sales, _) {
                                        switch (sales.category) {
                                          case 'Hot':
                                            return AppColor.red.withValues(
                                              alpha: 0.8,
                                            );
                                          case 'Normal':
                                            return AppColor.colYellow
                                                .withValues(alpha: 0.8);
                                          case 'Cold':
                                            return AppColor.blue.withValues(
                                              alpha: 0.8,
                                            );
                                          default:
                                            return Colors.grey.withValues(
                                              alpha: 0.8,
                                            );
                                        }
                                      },
                                      xValueMapper:
                                          (SalesData sales, _) =>
                                              sales.category,
                                      yValueMapper:
                                          (SalesData sales, _) => sales.sales,
                                      dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        labelPosition:
                                            ChartDataLabelPosition.inside,
                                        textStyle: textStyles.sarifProText(
                                          12,
                                          FontWeight.w500,
                                          AppColor.black,
                                        ),
                                      ),
                                      strokeColor:
                                          AppColor
                                              .primary, // Or any color you like
                                      strokeWidth: .5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onHover: (value) {
                                setState(() {
                                  onEnqueryHower = value;
                                });
                              },
                              onTap: () {
                                pushTo(ProductView());
                              },
                              child: Container(
                                width:
                                    (Responsive.isMobile(context))
                                        ? double.infinity
                                        : Sizes.width * 0.45,
                                padding: EdgeInsets.symmetric(
                                  vertical: Sizes.height * 0.01,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  boxShadow:
                                      !onEnqueryHower
                                          ? [
                                            BoxShadow(
                                              offset: Offset(0, 2),
                                              blurRadius: 3,
                                              spreadRadius: 0,
                                            ),
                                          ]
                                          : [
                                            BoxShadow(
                                              blurRadius: 8,
                                              color: const Color.fromARGB(
                                                255,
                                                51,
                                                83,
                                                136,
                                              ),
                                              offset: Offset(2, 5),
                                            ),
                                            BoxShadow(
                                              blurRadius: 8,
                                              color: const Color.fromARGB(
                                                255,
                                                59,
                                                89,
                                                141,
                                              ),
                                              offset: Offset(-2, 0),
                                            ),
                                          ],
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    SfCircularChart(
                                      title: ChartTitle(
                                        text: "Product Type",
                                        textStyle: textStyles.abyssinicaSilText(
                                          18,
                                          FontWeight.w600,
                                          AppColor.primary,
                                        ),
                                        alignment: ChartAlignment.center,
                                      ),
                                      legend: Legend(isVisible: true),
                                      series: <CircularSeries>[
                                        DoughnutSeries<ChartData, String>(
                                          radius: '80%',
                                          dataSource: <ChartData>[
                                            ...List.generate(productGetList.length, (
                                              index,
                                            ) {
                                              int enqueryId = int.parse(
                                                productGetList[index]['enquiryName'],
                                              );
                                              String enqueryName =
                                                  productList.isEmpty
                                                      ? ''
                                                      : productList.firstWhere(
                                                        (element) =>
                                                            element['id'] ==
                                                            enqueryId,
                                                        orElse:
                                                            () => {'name': ''},
                                                      )['name'];
                                              return ChartData(
                                                enqueryName,
                                                productGetList[index]["prospectDetails"]
                                                    .length,
                                                color: colorList[index],
                                              );
                                            }),
                                          ],
                                          pointColorMapper:
                                              (ChartData data, _) => data.color,
                                          xValueMapper:
                                              (ChartData data, _) => data.x,
                                          yValueMapper:
                                              (ChartData data, _) => data.y,
                                          dataLabelSettings: DataLabelSettings(
                                            isVisible: true,
                                            labelPosition:
                                                ChartDataLabelPosition.inside,
                                          ),
                                          dataLabelMapper:
                                              (ChartData data, _) =>
                                                  '${data.x}\n${data.y}', // Customize label text
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Sizes.height * 0.04),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: Sizes.height * 0.02,
                          spacing: Sizes.width * 0.02,
                          children: [
                            InkWell(
                              onTap: () {
                                pushTo(CustomerStatus());
                              },
                              onHover: (value) {
                                setState(() {
                                  onCSHower = value;
                                });
                              },
                              child: Container(
                                width:
                                    (Responsive.isMobile(context))
                                        ? double.infinity
                                        : Sizes.width * 0.45,
                                padding: EdgeInsets.symmetric(
                                  vertical: Sizes.height * 0.01,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  boxShadow:
                                      !onCSHower
                                          ? [
                                            BoxShadow(
                                              offset: Offset(0, 2),
                                              blurRadius: 3,
                                              spreadRadius: 0,
                                            ),
                                          ]
                                          : [
                                            BoxShadow(
                                              blurRadius: 8,
                                              color: const Color.fromARGB(
                                                255,
                                                51,
                                                83,
                                                136,
                                              ),
                                              offset: Offset(2, 5),
                                            ),
                                            BoxShadow(
                                              blurRadius: 8,
                                              color: const Color.fromARGB(
                                                255,
                                                59,
                                                89,
                                                141,
                                              ),
                                              offset: Offset(-2, 0),
                                            ),
                                          ],
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Preference.getString(PrefKeys.userType) ==
                                            "Staff"
                                        ? StackedPieChart(
                                          datefrom: datepickarfrom.text,
                                          dateto: datepickarto.text,
                                          staffId:
                                              '${Preference.getString(PrefKeys.staffId) != "0" ? Preference.getString(PrefKeys.staffId) : salesmanId ?? 0}',
                                        )
                                        : StackedColumnChart(
                                          datefrom: datepickarfrom.text,
                                          dateto: datepickarto.text,
                                          staffId: Preference.getString(
                                            PrefKeys.staffId,
                                          ),
                                        ),

                                    Preference.getString(PrefKeys.userType) ==
                                            "Staff"
                                        ? Container()
                                        : Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                dense: true,
                                                contentPadding: EdgeInsets.zero,
                                                title: Text("Sales Colsed"),
                                                trailing: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                    color: AppColor.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 30,
                                              width: 1,
                                              color: AppColor.primary,
                                              margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    (Responsive.isMobile(
                                                          context,
                                                        )
                                                        ? 8
                                                        : 15),
                                              ),
                                            ),

                                            Expanded(
                                              child: ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                dense: true,
                                                title: Text("In process"),
                                                trailing: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                    color: Color(0xffFFB95A),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 30,
                                              width: 1,
                                              color: AppColor.primary,
                                              margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    (Responsive.isMobile(
                                                          context,
                                                        )
                                                        ? 8
                                                        : 15),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                dense: true,
                                                title: Text("Not Interested"),
                                                trailing: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                    color: AppColor.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             CustomerTypeView()));
                              },
                              onHover: (value) {
                                setState(() {
                                  onCTHower = value;
                                });
                              },
                              child: Container(
                                width:
                                    (Responsive.isMobile(context))
                                        ? double.infinity
                                        : Sizes.width * 0.45,
                                padding: EdgeInsets.symmetric(
                                  vertical: Sizes.height * 0.01,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  boxShadow:
                                      !onCTHower
                                          ? [
                                            BoxShadow(
                                              offset: Offset(0, 2),
                                              blurRadius: 3,
                                              spreadRadius: 0,
                                            ),
                                          ]
                                          : [
                                            BoxShadow(
                                              blurRadius: 8,
                                              color: const Color.fromARGB(
                                                255,
                                                51,
                                                83,
                                                136,
                                              ),
                                              offset: Offset(2, 5),
                                            ),
                                            BoxShadow(
                                              blurRadius: 8,
                                              color: const Color.fromARGB(
                                                255,
                                                59,
                                                89,
                                                141,
                                              ),
                                              offset: Offset(-2, 0),
                                            ),
                                          ],
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    SfCartesianChart(
                                      title: ChartTitle(
                                        text: "Daywise Call History",
                                        textStyle: textStyles.abyssinicaSilText(
                                          18,
                                          FontWeight.w600,
                                          AppColor.primary,
                                        ),
                                        alignment: ChartAlignment.center,
                                      ),
                                      primaryXAxis: CategoryAxis(),
                                      series: <CartesianSeries>[
                                        ColumnSeries<CustomerType, String>(
                                          color: AppColor.primary,
                                          dataSource: <CustomerType>[
                                            ...List.generate(
                                              customerTypeGetList.length,
                                              (index) {
                                                int customerTypeId = int.parse(
                                                  customerTypeGetList[index]['customerTypeName'],
                                                );
                                                String customerTypeName =
                                                    customerTypeList.isEmpty
                                                        ? ''
                                                        : customerTypeList
                                                            .firstWhere(
                                                              (element) =>
                                                                  element['id'] ==
                                                                  customerTypeId,
                                                              orElse:
                                                                  () => {
                                                                    'name': '',
                                                                  },
                                                            )['name'];
                                                return CustomerType(
                                                  customerTypeName,
                                                  int.parse(
                                                    customerTypeGetList[index]["customerTypeCount"],
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                          xValueMapper:
                                              (CustomerType sales, _) =>
                                                  sales.month,
                                          yValueMapper:
                                              (CustomerType sales, _) =>
                                                  sales.sales,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
      ),
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        runSpacing: 10,
        spacing: 10,
        alignment: WrapAlignment.end,
        children: [
          DefaultButton(
            width: 200,
            hight: 55,
            text: 'Search Prospect',
            buttonColor: Color(0xffECD2FF),
            textColor: AppColor.primary,
            onTap: () {
              pushTo(SearchProspect());
            },
          ),

          Preference.getString(PrefKeys.userType) != "Staff"
              ? Container()
              : DefaultButton(
                width: 200,
                hight: 55,
                buttonColor: Color(0xffECD2FF),
                textColor: AppColor.primary,
                text: 'Add Prospect',
                onTap: () async {
                  var somedata = await pushTo(ProspectScreen());
                  if (somedata != null) {
                    getallprospactGrid().then((value) {
                      setState(() {});
                    });
                  }
                },
              ),
        ],
      ),
    );
  }

  //GetPriority
  Future getPriorityApi() async {
    Map response = await ApiService.fetchData(
      "CRM/PriorityWiseDetails?locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId) != "0" ? Preference.getString(PrefKeys.staffId) : salesmanId ?? 0}&datefrom=${datepickarfrom.text}&dateto=${datepickarto.text}",
    );

    List priorityList = response['priority'] as List;

    for (var priority in priorityList) {
      List prospectDetails = priority['prospectDetails'] as List;
      priority['prospectDetails'] =
          prospectDetails
              .where((prospect) => prospect['enquiryStatus'] == 105)
              .toList();
    }

    priorityGetList = priorityList;
  }

  //GetCustomerType
  Future getcustomerTypeApi() async {
    var response = await ApiService.fetchData(
      "CRM/CustomerTypeWiseSummary?locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId) != "0" ? Preference.getString(PrefKeys.staffId) : salesmanId ?? 0}&datefrom=${datepickarfrom.text}&dateto=${datepickarto.text}",
    );
    customerTypeGetList = response['customerTypeC'];
  }

  //CustomerList
  Future<void> customerTypeData() async {
    var response = await ApiService.fetchData(
      "UserController1/GetMiscMasterLocationWise?MiscTypeId=50&LocationId=${Preference.getString(PrefKeys.locationId)}",
    );
    customerTypeList = response;
  }

  //Get enquery
  Future getenqueryApi() async {
    var response = await ApiService.fetchData(
      "CRM/EnquiryTypeWiseSummary?locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId) != "0" ? Preference.getString(PrefKeys.staffId) : salesmanId ?? 0}&datefrom=${datepickarfrom.text}&dateto=${datepickarto.text}",
    );
    List productList1 = response['enquiry'] as List;

    for (var enquery in productList1) {
      List prospectDetails = enquery['prospectDetails'] as List;
      enquery['prospectDetails'] =
          prospectDetails
              .where((prospect) => prospect['enquiryStatus'] == 105)
              .toList();
    }
    productGetList = productList1;
  }

  //Product List
  Future<void> productData() async {
    var response = await ApiService.fetchData(
      "UserController1/GetMiscMasterLocationWise?MiscTypeId=18&LocationId=${Preference.getString(PrefKeys.locationId)}",
    );
    productList = response;
  }

  int punchedToday = 0;
  int followupToday = 0;
  int demoToday = 0;
  int folowupTomorrow = 0;
  int weeklyLead = 0;
  Future getallprospactGrid() async {
    var response = await ApiService.fetchData(
      "CRM/GetScheduleReportALLDATA?datefrom=${DateFormat('yyyy/MM/dd').format(DateTime.now())}&dateto=${DateFormat('yyyy/MM/dd').format(DateTime.now())}&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId)}",
    );
    followupToday =
        response
            .where((prospect) => prospect['enquiryStatus'] == 105)
            .toList()
            .length;

    demoToday =
        response
            .where(
              (prospect) =>
                  prospect['enquiryStatus'] == 105 &&
                  prospect['modelTest_Id'] == 1,
            )
            .toList()
            .length;
    var responsetomaroow = await ApiService.fetchData(
      "CRM/GetScheduleReportALLDATA?datefrom=${DateFormat('yyyy/MM/dd').format(DateTime.now().add(Duration(days: 1)))}&dateto=${DateFormat('yyyy/MM/dd').format(DateTime.now().add(Duration(days: 1)))}&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId)}",
    );
    folowupTomorrow =
        responsetomaroow
            .where((prospect) => prospect['enquiryStatus'] == 105)
            .toList()
            .length;
    var responseweekly = await ApiService.fetchData(
      "CRM/GetProspectDateWiseReportALLDATA?datefrom=${DateFormat('yyyy/MM/dd').format(DateTime.now().subtract(Duration(days: 7)))}&dateto=${DateFormat('yyyy/MM/dd').format(DateTime.now())}&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId)}",
    );
    weeklyLead =
        responseweekly
            .where((prospect) => prospect['enquiryStatus'] == 105)
            .toList()
            .length;
    final formattedDateFrom = DateFormat('yyyy/MM/dd').format(DateTime.now());
    var responseToday = await ApiService.fetchData(
      "CRM/GetProspectDateWiseReportALLDATA?datefrom=$formattedDateFrom&dateto=$formattedDateFrom&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId)}",
    );
    punchedToday =
        responseToday
            .where((prospect) => prospect['enquiryStatus'] == 105)
            .toList()
            .length;
  }

  Future<void> staffData() async {
    final url = Uri.parse(
      'http://lms.muepetro.com/api/UserController1/GetStaffDetailsLocationwise?locationid=${Preference.getString(PrefKeys.locationId)}',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        salesmanList = staffmodelFromJson(response.body);
      }
    } catch (e) {
      print("Error fetching staff data: $e");
      // Handle error
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notesString =
        _notes.map((e) => jsonEncode(e.toJson())).toList();
    prefs.setStringList('notes', notesString);
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotes();
  }

  void _toggleTask(int noteIndex, int taskIndex) {
    setState(() {
      _notes[noteIndex].tasks[taskIndex].isChecked =
          !_notes[noteIndex].tasks[taskIndex].isChecked;
    });
    _saveNotes();
  }
}
