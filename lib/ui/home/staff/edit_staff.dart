import 'package:flutter/material.dart';
import 'package:wms_mst/components/decoration.dart';
import 'package:wms_mst/ui/home/staff/add_staff.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/textstyle.dart';

class AddStaff extends StatefulWidget {
  AddStaff({super.key, required this.isFirst, required this.id});
  bool isFirst;
  int? id;

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  StyleText textStyles = StyleText();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, 'New Data');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text(
          widget.isFirst ? "Add Staff" : "Edit Staff",
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
        child: AddStaffWidget(id: widget.id, isFirst: widget.isFirst),
      ),
    );
  }
}
