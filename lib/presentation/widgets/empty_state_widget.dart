import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/presentation/helpers/app_local.dart';
import 'package:real_estate_app/theme/app_color.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';

class EmptyStateWidget extends StatelessWidget {
  final bool showRefreshButton;
  final bool isFavorite;
  final String message;
  final Future<void> Function()
      onRefresh; 

  const EmptyStateWidget(
      {super.key,
      required this.onRefresh,
      this.showRefreshButton = false,
      this.isFavorite = false, 
      required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 54, right: 54, top: 24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, 
          crossAxisAlignment:
              CrossAxisAlignment.center,
          children: [
            Image.asset(AppImages.emptyState),
            const SizedBox(height: 48),
            Text(
              message,
              style: TextStyle(fontSize: 18, color: AppColor.mediumColor),
            ),
            const SizedBox(height: 24),
            if (showRefreshButton)
              ElevatedButton(
                onPressed: () {
                  onRefresh();
                },
                child: Text(AppLocal.refresh.tr()),
              ),
          ],
        ),
      ),
    );
  }
}
