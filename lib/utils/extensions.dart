import 'package:flutter/cupertino.dart';

extension CustomBox on double {
  Widget widthBox() {
    return SizedBox(
      width: this,
    );
  }

  Widget heightBox() {
    return SizedBox(
      height: this,
    );
  }
}

extension CustomBox2 on int {
  Widget widthBox() {
    return SizedBox(
      width: toDouble(),
    );
  }

  Widget heightBox() {
    return SizedBox(
      height: toDouble(),
    );
  }
}
