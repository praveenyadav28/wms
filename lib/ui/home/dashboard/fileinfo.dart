import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:wms_mst/ui/home/dashboard/addqueries.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/navigation.dart';
import 'package:wms_mst/utils/textstyle.dart';

class FileInfoCard extends StatefulWidget {
  final List<Map<String, dynamic>> dataList;

  const FileInfoCard({Key? key, required this.dataList}) : super(key: key);

  @override
  State<FileInfoCard> createState() => _FileInfoCardState();
}

class _FileInfoCardState extends State<FileInfoCard> {
  StyleText textStyles = StyleText();
  int hoveredIndex = -1;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.dataList.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            Sizes.width < 600
                ? 2
                : Sizes.width < 800
                ? 3
                : Sizes.width < 1100
                ? 4
                : 5,
        crossAxisSpacing: Sizes.width * .03,
        childAspectRatio:
            Sizes.width < 600
                ? 1.3
                : Sizes.width < 800
                ? 1.3
                : Sizes.width < 1100
                ? 1.4
                : 1.5,
        mainAxisSpacing: Sizes.height * .02,
      ),
      itemBuilder:
          (context, index) => InkWell(
            onHover: (value) {
              setState(() {
                hoveredIndex = value ? index : -1;
              });
            },
            onTap: () {
              pushTo(AddQueries(index: index));
            },
            child: Card(
              shadowColor: Colors.blueAccent,
              elevation: index == hoveredIndex ? 15.0 : 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                            color: AppColor.black.withOpacity(.2),
                            inset: true,
                          ),
                        ],
                        color: Color(0xffC1C1F7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Image.network(
                              widget.dataList[index]["icon"],
                              height: Sizes.width > 900 ? 40 : 30,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              widget.dataList[index]["users"],
                              style: textStyles.abyssinicaSilText(
                                26,
                                FontWeight.w700,
                                AppColor.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        widget.dataList[index]["title"],
                        style: textStyles.sarifProText(
                          17,
                          FontWeight.w800,
                          AppColor.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
