import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/textformfield.dart';
import 'package:wms_mst/utils/textstyle.dart';

class DefaultButton extends StatefulWidget {
  DefaultButton({
    required this.text,
    required this.hight,
    required this.width,
    required this.onTap,
    this.buttonColor,
    this.textColor,
    super.key,
  });

  final double hight;
  final double width;
  final Function()? onTap;
  final String text;
  final Color? buttonColor;
  final Color? textColor;

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  bool onButtonHower = false;
  StyleText textStyles = StyleText();
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return InkWell(
          onHover: (value) {
            setState(() {
              onButtonHower = value;
            });
          },
          onTap: widget.onTap,
          child: Container(
            height: widget.hight,
            width: widget.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.buttonColor ?? AppColor.primary,
              borderRadius: BorderRadius.circular(15),
              boxShadow:
                  !onButtonHower
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
                          color: const Color.fromARGB(255, 51, 83, 136),
                          offset: Offset(2, 5),
                        ),
                        BoxShadow(
                          blurRadius: 8,
                          color: const Color.fromARGB(255, 59, 89, 141),
                          offset: Offset(-2, 0),
                        ),
                      ],
            ),
            child: Text(
              widget.text,
              style: textStyles.sarifProText(
                17,
                FontWeight.w700,
                widget.textColor ?? AppColor.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class DateRange extends StatelessWidget {
  DateRange({super.key, required this.datepickar1, required this.datepickar2});
  TextEditingController datepickar1;
  TextEditingController datepickar2;
  @override
  Widget build(BuildContext context) {
    StyleText textStyles = StyleText();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CoverTextField(
                  widget: InkWell(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2500),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          datepickar1.text = DateFormat(
                            'yyyy/MM/dd',
                          ).format(selectedDate);
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          datepickar1.text,
                          style: textStyles.sarifProText(
                            16,
                            FontWeight.w500,
                            AppColor.primarydark,
                          ),
                        ),
                        Icon(Icons.edit_calendar, color: AppColor.primarydark),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CoverTextField(
                  widget: InkWell(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2500),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          datepickar2.text = DateFormat(
                            'yyyy/MM/dd',
                          ).format(selectedDate);
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          datepickar2.text,
                          style: textStyles.sarifProText(
                            16,
                            FontWeight.w500,
                            AppColor.primarydark,
                          ),
                        ),
                        Icon(Icons.edit_calendar, color: AppColor.primarydark),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DoubleDropdown extends StatefulWidget {
  DoubleDropdown({super.key, required this.staffDropdown, required this.child});
  Widget child;
  Widget staffDropdown;

  @override
  State<DoubleDropdown> createState() => _DoubleDropdownState();
}

class _DoubleDropdownState extends State<DoubleDropdown> {
  StyleText textStyles = StyleText();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,

          child: Row(
            children: [
              Preference.getString(PrefKeys.userType) == "Staff"
                  ? Container()
                  : Expanded(child: widget.staffDropdown),
              Preference.getString(PrefKeys.userType) == "Staff"
                  ? Container()
                  : SizedBox(width: 10),
              Expanded(child: widget.child),
            ],
          ),
        ),
      ],
    );
  }
}
