import 'package:flutter/material.dart';
import 'package:wms_mst/components/sidemenu.dart';
import 'package:wms_mst/ui/home/drawer.dart/easy_notes/notes.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/textstyle.dart';

class EasyNotes extends StatefulWidget {
  const EasyNotes({super.key});

  @override
  State<EasyNotes> createState() => _EasyNotesState();
}

class _EasyNotesState extends State<EasyNotes> {
  StyleText textStyles = StyleText();
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
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
      backgroundColor: AppColor.white,
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: Sizes.height * .1),
                ...List.generate(2, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: Sizes.height * .02),
                      height: 50,
                      padding: EdgeInsets.only(left: Sizes.width * .03),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffA09E9E)),
                        color:
                            selectedIndex == index
                                ? Color(0xffC1C1F7)
                                : Color(0xffD9D9D9),
                        boxShadow:
                            selectedIndex == index
                                ? [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    color: AppColor.grey,
                                    blurRadius: 4,
                                  ),
                                ]
                                : [],
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        index == 0 ? "Notes" : "Reminders",
                        style: textStyles.albertsans(
                          22,
                          FontWeight.w500,
                          selectedIndex == index
                              ? AppColor.white
                              : AppColor.black,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Expanded(flex: 5, child: Column(children: [NotesScreen()])),
        ],
      ),
    );
  }
}
