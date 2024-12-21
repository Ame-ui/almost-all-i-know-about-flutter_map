import 'package:flutter/material.dart';

class BackKey extends StatelessWidget {
  const BackKey({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.withOpacity(0.5))),
        child: Icon(Icons.arrow_back, color: Colors.black, size: 30),
      ),
    );
  }
}
