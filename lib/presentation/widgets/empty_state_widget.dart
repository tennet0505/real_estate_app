import 'package:flutter/material.dart';
import 'package:real_estate_app/theme/app_color.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';

class EmptyStateWidget extends StatelessWidget {
  final bool showRefreshButton;
  final Future<void> Function()
      onRefresh; // Define a callback function for refresh action

  const EmptyStateWidget({super.key, required this.onRefresh, this.showRefreshButton = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 54, right: 54, top: 24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers items vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centers items horizontally
          children: [
            Image.asset(AppImages.emptyState),
            const SizedBox(height: 48),
            const Text(
              'No results found',
              style: TextStyle(fontSize: 16, color: AppColor.mediumColor),
            ),
            const Text(
              'Perhaps try another search?',
              style: TextStyle(fontSize: 16, color: AppColor.mediumColor),
            ),
            const SizedBox(height: 24),
            if (showRefreshButton)
            ElevatedButton(
              onPressed: () {
                onRefresh();
              },
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
