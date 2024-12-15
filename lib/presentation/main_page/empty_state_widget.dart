import 'package:flutter/material.dart';
import 'package:real_estate_app/presentation/helpers/app_color.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.lightColor,
      child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 54, right: 54),
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Centers items vertically
                    crossAxisAlignment: CrossAxisAlignment.center, // C
                    children: [
            Image.asset(AppImages.emptyState),
            const SizedBox(height: 48),
            const Text('No results founds',
                style: TextStyle(fontSize: 16, color: AppColor.mediumColor)),
            const Text('Perhaps try another search?',
                style: TextStyle(fontSize: 16, color: AppColor.mediumColor)),
                    ],
                  ),
          )),
    );
  }
}
