import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/constants.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/screens/favorite_page/favorite_icon_widget.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';
import 'package:real_estate_app/presentation/helpers/currency_formater.dart';
import 'package:real_estate_app/presentation/helpers/distance_helper.dart';

class FavoriteItemHouseWidget extends StatefulWidget {
  final House house;

  const FavoriteItemHouseWidget({
    super.key,
    required this.house,
  });

  @override
  State<FavoriteItemHouseWidget> createState() =>
      _FavoriteItemHouseWidgetState();
}

class _FavoriteItemHouseWidgetState extends State<FavoriteItemHouseWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Ensures full width
      height: 200, // Set a fixed height as per design
      child: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: 'tag_${widget.house.id}',
              child: CachedNetworkImage(
                imageUrl: '${Constants.mainUrl}${widget.house.image}',
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  AppImages.housePlaceholder,
                  fit: BoxFit.cover,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha:0.6), // Darker at the bottom
                    Colors.black.withValues(alpha:0.0), // Transparent at the top
                  ],
                ),
              ),
            ),
          ),
          // Content Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatCurrency(widget.house.price),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.1,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${widget.house.zip.replaceAll(' ', '')} ${widget.house.city}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Column(
                    spacing: 4,
                    children: [
                      FavoriteIconWidget(
                        imageString: AppImages.bed,
                        string: '${widget.house.bedrooms}',
                      ),
                      FavoriteIconWidget(
                        imageString: AppImages.shower,
                        string: '${widget.house.bathrooms}',
                      ),
                      FavoriteIconWidget(
                        imageString: AppImages.mapLayer,
                        string: '${widget.house.size}',
                      ),
                      FavoriteIconWidget(
                        imageString: AppImages.location,
                        string: formatDistance(widget.house.distanceFromUser),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha:0.5),
              child: IconButton(
                icon: Icon(Icons.favorite, color: Colors.red),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
