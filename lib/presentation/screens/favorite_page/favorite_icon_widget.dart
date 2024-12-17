import 'package:flutter/material.dart';
import 'package:real_estate_app/theme/app_color.dart';

class FavoriteIconWidget extends StatelessWidget {
  final String imageString;
  final String string;
  const FavoriteIconWidget(
      {super.key,
      required this.imageString,
      required this.string});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          color: AppColor.whiteColor,
          imageString,
          width: 16,
          height: 16,
        ),
        SizedBox(width: 6),
        Text(
          string,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color: AppColor.whiteColor,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
            fontFamily: 'GothamSSm',
          ),
        ),
      ],
    );
  }
}
