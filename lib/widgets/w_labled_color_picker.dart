import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_map_all_feature/utils/extensions.dart';

class LabledColorPicker extends StatelessWidget {
  const LabledColorPicker(
      {super.key,
      required this.pickerColor,
      required this.onChange,
      required this.lable});
  final String lable;
  final Color pickerColor;
  final Function(Color color) onChange;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: onChange,
              ),
            ));
          },
        );
      },
      child: ColoredBox(
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              color: pickerColor,
            ),
            5.widthBox(),
            Text(
              lable,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            5.widthBox(),
            const Icon(Icons.arrow_drop_down)
          ],
        ),
      ),
    );
  }
}
