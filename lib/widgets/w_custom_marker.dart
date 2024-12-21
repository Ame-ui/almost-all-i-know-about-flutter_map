import 'package:flutter/material.dart';

class CustomMarker extends StatelessWidget {
  const CustomMarker({super.key, required this.xSelected, required this.onTap});

  final bool xSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // color: xSelected ? Colors.black.withOpacity(0.3) : Colors.transparent,
          // shape: BoxShape.circle,
          border: Border.all(color: Colors.black.withOpacity(0.1)),
        ),
        child: Icon(
          Icons.location_pin,
          color: xSelected ? Colors.red : Colors.black,
          size: 40,
        ),
      ),
    );
  }
}
