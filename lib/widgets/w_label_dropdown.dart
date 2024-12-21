import 'package:flutter/material.dart';

class LabledDropdown extends StatelessWidget {
  const LabledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.itemList,
    required this.onChanged,
  });
  final String label;
  final String value;
  final List<String> itemList;
  final Function(String? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: const Color(0xff303030).withOpacity(0.2)),
                value: value,
                dropdownColor: const Color(0xff303030).withOpacity(0.8),
                items: itemList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          )
        ],
      ),
    );
  }
}
