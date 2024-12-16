import 'package:flutter/material.dart';
import 'package:real_estate_app/presentation/helpers/app_color.dart';

class IconWidget extends StatelessWidget {
  final String imageString;
  final bool isDetailScreen;
  final String string;
  const IconWidget(
      {super.key,
      required this.imageString,
      required this.string,
      this.isDetailScreen = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          color: AppColor.mediumColor,
          imageString,
          width: isDetailScreen ? 14 : 12,
          height: isDetailScreen ? 16 : 14,
        ),
        SizedBox(width: isDetailScreen ? 2 : 4),
        Text(
          string,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isDetailScreen ? 10 : 10,
            color: AppColor.mediumColor,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
            fontFamily: 'GothamSSm',
          ),
        ),
        SizedBox(
          width: isDetailScreen ? 16 : 20,
        ),
      ],
    );
  }
}
