import 'package:flutter/material.dart';

class PaddingTextField extends StatefulWidget {
  const PaddingTextField(
      {super.key, required this.label, required this.onChanged});
  final String label;
  final Function(String? value) onChanged;

  @override
  State<PaddingTextField> createState() => _PaddingTextFieldState();
}

class _PaddingTextFieldState extends State<PaddingTextField> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.clear();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        onTapOutside: (event) => FocusScope.of(context).unfocus,
        controller: textEditingController,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: const Color(0xff303030).withOpacity(0.2),
          label: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
