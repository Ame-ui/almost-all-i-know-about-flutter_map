import 'package:flutter/material.dart';

class DraggableMarker extends StatelessWidget {
  const DraggableMarker(
      {super.key,
      required this.lable,
      required this.background,
      required this.onDragEnd});
  final String lable;
  final Color background;
  final Function(DraggableDetails details) onDragEnd;
  @override
  Widget build(BuildContext context) {
    return Draggable(
      feedback: Material(color: Colors.transparent, child: childWidget(true)),
      onDragEnd: onDragEnd,
      childWhenDragging: const SizedBox.shrink(),
      child: childWidget(false),
    );
  }

  Widget childWidget(bool xFeedback) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(xFeedback ? 100 : 10),
          border: xFeedback ? Border.all(color: Colors.black, width: 3) : null),
      child: Text(
        lable,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
