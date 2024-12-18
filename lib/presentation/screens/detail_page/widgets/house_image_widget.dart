import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';

class HouseImageSection extends StatelessWidget {
  final String imageUrl;
  final int id;

  const HouseImageSection(
      {super.key, required this.imageUrl, required this.id});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [ 
        Hero(
          tag: 'tag_$id',
          child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.asset(
                    height: 270,
                    AppImages.housePlaceholder,
                    fit: BoxFit.cover,
                  ),
              fit: BoxFit.cover),
        ),
        Positioned(
          top: 48,
          left: 8,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
