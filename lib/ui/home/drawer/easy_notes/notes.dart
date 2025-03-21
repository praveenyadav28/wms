import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/components/decoration.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/textstyle.dart';

class Task {
  String text;
  String isChecked;

  Task({required this.text, required this.isChecked});

  Map<String, dynamic> toJson() => {'Notes': text, 'Status': isChecked};
  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(text: json['Notes'], isChecked: json['Status']);
}

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  int _selectedColor = 0xffFFCDD2; // Default color

  final List<int> _colors = [
    0xffFFCDD2, // Colors.red[100]
    0xffF8BBD0, // Colors.pink[100]
    0xffE1BEE7, // Colors.purple[100]
    0xffBBDEFB, // Colors.blue[100]
    0xffC8E6C9, // Colors.green[100]
    0xffFFF9C4, // Colors.yellow[100]
    0xffFFFFFF, // Colors.white
  ];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focusNodes = [];
  List<Task> _tasks = [];
  bool _showTaskList = false; // Controls task list visibility

  void _startTaskList() {
    setState(() {
      _showTaskList = true;
      _addNewTask(); // Immediately add first task
    });
  }

  void _addNewTask() {
    setState(() {
      _tasks.add(Task(text: "", isChecked: "0"));
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());

      // Request focus on the latest added task
      Future.delayed(Duration(milliseconds: 100), () {
        _focusNodes.last.requestFocus();
      });
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isChecked = _tasks[index].isChecked == "0" ? "1" : "0";
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      _controllers.removeAt(index);
      _focusNodes.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  StyleText textStyles = StyleText();
  bool pinNote = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DecorationContainer(
        url: Images.other1,
        child: Column(
          children: [
            SizedBox(height: Sizes.height * .1),
            Container(
              width: Sizes.width * .5,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(_selectedColor),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    color: AppColor.grey,
                    blurRadius: 4,
                  ),
                ],
                // border: Border.all(color: AppColor.black),
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        style: textStyles.albertsans(
                          17,
                          FontWeight.w600,
                          AppColor.primarydark,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Title",
                          hintStyle: textStyles.albertsans(
                            17,
                            FontWeight.w600,
                            AppColor.black.withValues(alpha: .6),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _contentController,
                        style: textStyles.albertsans(
                          15,
                          FontWeight.w500,
                          AppColor.primarydark,
                        ),
                        maxLines: null,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Take a note...",
                          hintStyle: textStyles.albertsans(
                            15,
                            FontWeight.w500,
                            AppColor.black.withValues(alpha: .6),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: Sizes.height * .01),
                      // Task List
                      if (_showTaskList)
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _tasks.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(_tasks[index].text + index.toString()),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (direction) => _deleteTask(index),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value:
                                        _tasks[index].isChecked == "0"
                                            ? false
                                            : true,
                                    onChanged: (value) => _toggleTask(index),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      decoration: InputDecoration(
                                        hintText: "Enter task",
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        _tasks[index].text = value;
                                      },
                                      onSubmitted: (value) {
                                        if (value.trim().isNotEmpty) {
                                          _addNewTask(); // Add new task on Enter key
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, size: 18),
                                    onPressed: () => _deleteTask(index),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      SizedBox(height: Sizes.height * .01),
                      Row(
                        children: [
                          PopupMenuButton<int>(
                            icon: Icon(Icons.color_lens),
                            onSelected: (int value) {
                              setState(() {
                                _selectedColor = value;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  enabled:
                                      false, // Prevents automatic selection
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                        _colors.map((color) {
                                          return Radio<int>(
                                            fillColor: WidgetStatePropertyAll(
                                              Color(color),
                                            ),
                                            value: color,
                                            groupValue: _selectedColor,
                                            onChanged: (int? value) {
                                              if (value != null) {
                                                setState(() {
                                                  _selectedColor = value;
                                                });
                                                Navigator.pop(
                                                  context,
                                                ); // Close popup after selection
                                              }
                                            },
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ];
                            },
                          ),

                          if (_tasks.isEmpty)
                            TextButton(
                              onPressed: _startTaskList,
                              child: Text(
                                "Show Checkbox",
                                style: textStyles.sarifProText(
                                  14,
                                  FontWeight.w600,
                                  AppColor.primary,
                                ),
                              ),
                            ),
                          Spacer(),
                          OutlinedButton(
                            onPressed: postNotes,
                            child: Text("Add Note"),
                          ),
                        ],
                      ),

                      SizedBox(height: Sizes.height * .01),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        pinNote = !pinNote;
                      });
                    },
                    icon: Icon(
                      pinNote ? Icons.push_pin : Icons.push_pin_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future postNotes() async {
    var response = await ApiService.postData("Modern/PostNotes", {
      "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
      "StaffId": int.parse(Preference.getString(PrefKeys.staffId)),
      "DemoTitle": _titleController.text,
      "DemoNote": _contentController.text,
      "BackgroundColour": "$_selectedColor",
      "PinStatus": "$pinNote",
      "CreateDate": DateFormat('yyyy/MM/dd').format(DateTime.now()),
      "Other1": "Other1",
      "Other2": "Other2",
      "Other3": "Other3",
      "Other4": "Other4",
      "Other5": "Other5",
      "TaskDetails": _tasks,
    });
    if (response['result']) {
      _tasks.clear();
      _contentController.clear();
      _titleController.clear();
      setState(() {});
    }
  }
}
