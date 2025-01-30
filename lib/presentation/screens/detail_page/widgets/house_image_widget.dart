import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';

class HouseImageSection extends StatelessWidget {
  final String imageUrl;
  final int id;
  final Color color;

  const HouseImageSection(
      {super.key,
      required this.imageUrl,
      required this.id,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        height: 290,
        imageUrl: imageUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Image.asset(
              height: 290,
              AppImages.housePlaceholder,
              fit: BoxFit.cover,
            ),
        fit: BoxFit.cover);
  }
}
