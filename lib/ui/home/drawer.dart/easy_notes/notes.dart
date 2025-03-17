import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/components/decoration.dart';
import 'package:wms_mst/components/prefences.dart';
// import 'package:wms_mst/utils/button.dart';
import 'dart:convert';

import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/textformfield.dart';
import 'package:wms_mst/utils/textstyle.dart';

class Task {
  String text;
  bool isChecked;

  Task({required this.text, this.isChecked = false});

  Map<String, dynamic> toJson() => {'text': text, 'isChecked': isChecked};
  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(text: json['text'], isChecked: json['isChecked']);
}

class Note {
  String title;
  String content;
  List<Task> tasks;
  Color backgroundColor;

  Note({
    required this.title,
    required this.content,
    required this.tasks,
    required this.backgroundColor,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'tasks': tasks.map((t) => t.toJson()).toList(),
    'backgroundColor': backgroundColor.value,
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    title: json['title'],
    content: json['content'],
    tasks: (json['tasks'] as List).map((t) => Task.fromJson(t)).toList(),
    backgroundColor: Color(json['backgroundColor'] ?? Colors.white.value),
  );
}

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  Color _selectedColor = Colors.red[100]!; // Default color

  final List<Color> _colors = [
    Colors.red[100]!,
    Colors.pink[100]!,
    Colors.purple[100]!,
    Colors.blue[100]!,
    Colors.green[100]!,
    Colors.yellow[100]!,
    Colors.white,
  ];
  List<Note> _notes = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<Task> _newTasks = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
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

  void _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notesString =
        _notes.map((e) => jsonEncode(e.toJson())).toList();
    prefs.setStringList('notes', notesString);
  }

  void _addNote() {
    if (_titleController.text.isNotEmpty ||
        _contentController.text.isNotEmpty ||
        _newTasks.isNotEmpty) {
      setState(() {
        _notes.add(
          Note(
            title: _titleController.text,
            content: _contentController.text,
            tasks: List.from(_newTasks),
            backgroundColor: _selectedColor,
          ),
        );
        _titleController.clear();
        _contentController.clear();
        _newTasks.clear();
      });
      _saveNotes();
    }
  }

  void _addTaskToNewNote() async {
    TextEditingController taskController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Enter Task Title",
            style: textStyles.sarifProText(
              16,
              FontWeight.w600,
              AppColor.primary,
            ),
          ),
          content: SizedBox(
            height: 40,
            child: commonTextField(taskController, labelText: "Task title"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: textStyles.albertsans(15, FontWeight.w500, AppColor.red),
              ),
            ),
            TextButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  setState(() {
                    _newTasks.add(Task(text: taskController.text));
                  });
                }
                Navigator.pop(context);
              },
              child: Text(
                "Add",
                style: textStyles.albertsans(
                  15,
                  FontWeight.w500,
                  AppColor.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _toggleNewTask(int taskIndex) {
    setState(() {
      _newTasks[taskIndex].isChecked = !_newTasks[taskIndex].isChecked;
    });
  }

  void _deleteNewTask(int taskIndex) {
    setState(() {
      _newTasks.removeAt(taskIndex);
    });
  }

  StyleText textStyles = StyleText();
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
                color: _selectedColor,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    color: AppColor.grey,
                    blurRadius: 4,
                  ),
                ],
                // border: Border.all(color: AppColor.black),
              ),
              child: Column(
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
                      border: OutlineInputBorder(borderSide: BorderSide.none),
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
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                  SizedBox(height: Sizes.height * .01),
                  Column(
                    children: List.generate(_newTasks.length, (taskIndex) {
                      return CheckboxListTile(
                        title: Text(
                          _newTasks[taskIndex].text,
                          style: textStyles.albertsans(
                            14,
                            FontWeight.w600,
                            AppColor.black,
                          ),
                        ),
                        value: _newTasks[taskIndex].isChecked,
                        onChanged: (_) => _toggleNewTask(taskIndex),
                        secondary: IconButton(
                          icon: Icon(Icons.delete, color: AppColor.red),
                          onPressed: () => _deleteNewTask(taskIndex),
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: Sizes.height * .01),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            "Add Task",
                            style: textStyles.sarifProText(
                              14,
                              FontWeight.w600,
                              AppColor.primary,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: _addTaskToNewNote,
                            icon: Icon(Icons.add),
                          ),
                        ),
                      ),
                      Expanded(
                        child: PopupMenuButton<Color>(
                          icon: Icon(Icons.color_lens),
                          onSelected: (Color value) {
                            setState(() {
                              _selectedColor = value;
                            });
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                enabled: false, // Prevents automatic selection
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      _colors.map((color) {
                                        return Radio<Color>(
                                          fillColor: WidgetStatePropertyAll(
                                            color,
                                          ),
                                          value: color,
                                          groupValue: _selectedColor,
                                          onChanged: (Color? value) {
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
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: _addNote,
                          child: Text("Add Note"),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Sizes.height * .01),
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
      "DemoTitle": "Jaipur",
      "DemoNote": "DemoNote",
      "BackgroundColour": "BackgroundColour",
      "PinStatus": "PinStatus",
      "CreateDate": "2024/01/27",
      "Other1": "Other1",
      "Other2": "Other2",
      "Other3": "Other3",
      "Other4": "Other4",
      "Other5": "Other5",
      "TaskDetails": [
        {"Notes": "Notes1", "Status": "0"},
        {"Notes": "Notes2", "Status": "1"},
      ],
    });
  }
}
