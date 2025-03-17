import 'package:flutter/material.dart';
import 'package:wms_mst/components/responsive.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/textstyle.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CoverTextField extends StatefulWidget {
  CoverTextField({
    super.key,
    required this.widget,
    this.borderColor,
    this.boxColor,
  });
  Widget? widget;
  Color? borderColor;
  Color? boxColor;
  @override
  State<CoverTextField> createState() => _CoverTextFieldState();
}

class _CoverTextFieldState extends State<CoverTextField> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        // height: 52,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: 0.2),
              offset: Offset(0, 2),
              blurRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.circular(15),
          color: widget.boxColor ?? AppColor.white,
          border: Border.all(color: widget.borderColor ?? AppColor.borderColor),
        ),

        child: widget.widget,
      ),
    );
  }
}

// //OutSide Cover Like TextField
// Widget coverTextField(String? labelText, Widget? widget, {Color? borderColor}) {
//   return InkWell(
//     child: Container(
//       alignment: Alignment.center,
//       // height: 52,
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: AppColor.black.withValues(alpha: 0.2),
//             offset: Offset(0, 2),
//             blurRadius: 2,
//           ),
//         ],
//         borderRadius: BorderRadius.circular(15),
//         color: AppColor.white,
//         border: Border.all(color: borderColor ?? AppColor.borderColor),
//       ),

//       child: widget,

//       //  TextFormField(
//       //   readOnly: true,
//       //   initialValue: " ",
//       //   decoration: InputDecoration(
//       //     fillColor: AppColor.white,
//       //     filled: true,
//       //     suffix: SizedBox(width: double.infinity, child: widget),
//       //     labelText: labelText,
//       //     labelStyle: textStyles.sarifProText(
//       //       16,
//       //       FontWeight.w700,
//       //       AppColor.black,
//       //     ),
//       //     border: OutlineInputBorder(
//       //       borderSide: BorderSide(color: AppColor.black, width: 1),
//       //     ),
//       //     enabledBorder: OutlineInputBorder(
//       //       borderSide: BorderSide(color: AppColor.black, width: 1),
//       //     ),
//       //     errorBorder: OutlineInputBorder(
//       //       borderSide: BorderSide(color: AppColor.black, width: 1),
//       //     ),
//       //     focusedBorder: OutlineInputBorder(
//       //       borderSide: BorderSide(color: AppColor.black, width: 1),
//       //     ),
//       //   ),
//       // ),
//     ),
//   );
// }

Widget commonTextField(
  TextEditingController? controller, {
  Widget? label,
  TextInputType? keyboardType,
  int? maxLength,
  Widget? suffixIcon,
  Widget? prefixIcon,
  String? Function(String?)? validator,
  Function(String)? onChanged,
  Function(String)? onFieldSubmitted,
  String? labelText,
  bool readOnly = false,
  bool obscureText = false,
  Color? borderColor,
  int? maxLines,
}) {
  StyleText textStyles = StyleText();
  return CoverTextField(
    widget: TextFormField(
      onFieldSubmitted: onFieldSubmitted ?? null,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: keyboardType,
      controller: controller,
      readOnly: readOnly,
      maxLength: maxLength,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines ?? 1,
      style: textStyles.sarifProText(16, FontWeight.w500, AppColor.primarydark),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: labelText,
        counterText: "",
        prefixIcon: prefixIcon,
        label: label,
        hintStyle: textStyles.sarifProText(15, FontWeight.w500, AppColor.grey),
        isDense: true,
        contentPadding: const EdgeInsets.only(top: 28, left: 15, right: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    ),
    borderColor: borderColor ?? AppColor.borderColor,
  );
}

//Searchable DropDown
DropdownButtonHideUnderline searchDropDown(
  BuildContext context,
  String hintText,
  List<DropdownMenuItem<Map<String, dynamic>>>? items,
  Map<String, dynamic>? value,
  Function(Map<String, dynamic>?)? onChanged,
  TextEditingController? controller,
  Function(String)? onChangedText,
  String hintTextInside,
  Function(bool)? onMenuStateChange,
) {
  StyleText textStyles = StyleText();
  return DropdownButtonHideUnderline(
    child: DropdownButton2<Map<String, dynamic>>(
      isExpanded: true,
      // ignore: prefer_const_constructors
      iconStyleData: IconStyleData(icon: Icon(Icons.keyboard_arrow_down)),
      alignment: Alignment.centerLeft,

      hint: Text(
        hintText,
        style: textStyles.sarifProText(
          16,
          FontWeight.w700,
          AppColor.primarydark,
        ),
      ),
      items: items,
      value: value,
      onChanged: onChanged,
      buttonStyleData: ButtonStyleData(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: (Responsive.isMobile(context)) ? 45 : 40,
        width: 200,
      ),
      dropdownStyleData: const DropdownStyleData(maxHeight: 200),
      menuItemStyleData: const MenuItemStyleData(height: 40),
      dropdownSearchData: DropdownSearchData(
        searchController: controller,
        searchInnerWidgetHeight: 50,
        searchInnerWidget: Container(
          height: 50,
          padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
          child: TextFormField(
            expands: true,
            readOnly: false,
            maxLines: null,
            controller: controller,
            onChanged: onChangedText,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              hintText: hintTextInside,
              hintStyle: const TextStyle(fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
      onMenuStateChange: onMenuStateChange,
    ),
  );
}

//Simple DropDown
Widget defaultDropDown({
  required Map<String, dynamic>? value,
  required List<DropdownMenuItem<Map<String, dynamic>>>? items,
  required void Function(Map<String, dynamic>?)? onChanged,
}) {
  return DropdownButton<Map<String, dynamic>>(
    underline: Container(),
    value: value,
    items: items,
    icon: const Icon(Icons.keyboard_arrow_down_outlined),
    isExpanded: true,
    onChanged: onChanged,
  );
}
