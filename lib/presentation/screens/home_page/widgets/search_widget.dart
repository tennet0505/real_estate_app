import 'package:flutter/material.dart';
import 'package:real_estate_app/theme/app_color.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController textEditingController;

  const SearchWidget({
    super.key,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        cursorColor: AppColor.mediumColor,
        cursorHeight: 14,
        controller: textEditingController,
        decoration: InputDecoration(
          label: const Text(
            'Search for a home',
            style: TextStyle(
              color: AppColor.mediumColor,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.1,
              fontFamily: 'GothamSSm',
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: AppColor.darkGrayColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          suffixIcon: const Icon(
            Icons.search,
            color: AppColor.mediumColor,
          ),
        ),
      ),
    );
  }
}