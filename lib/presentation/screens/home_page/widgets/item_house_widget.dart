import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/constants.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/theme/app_color.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';
import 'package:real_estate_app/presentation/helpers/currency_formater.dart';
import 'package:real_estate_app/presentation/helpers/distance_helper.dart';
import 'package:real_estate_app/presentation/widgets/icon_widget.dart';

class ItemHouseWidget extends StatelessWidget {
  final House house;

  const ItemHouseWidget({
    super.key,
    required this.house,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Hero(
          tag: 'tag_${house.id}',
          child: 
          CachedNetworkImage(
            width: 74,
            height: 74,
            imageUrl: '${Constants.mainUrl}${house.image}',
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => 
            Image.asset(
              width: 74,
              height: 74,
              AppImages.housePlaceholder,
              fit: BoxFit.cover,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatCurrency(house.price),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              Text(
                '${house.zip.replaceAll(' ', '')} ${house.city}',
                style: TextStyle(
                  fontSize: 12,
                  // height: 1,
                  color: AppColor.mediumColor,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                  fontFamily: 'GothamSSm',
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  IconWidget(
                      imageString: AppImages.bed,
                      string: '${house.bedrooms}',
                      isDetailScreen: false),
                  IconWidget(
                      imageString: AppImages.shower,
                      string: '${house.bathrooms}',
                      isDetailScreen: false),
                  IconWidget(
                      imageString: AppImages.mapLayer,
                      string: '${house.size}',
                      isDetailScreen: false),
                  IconWidget(
                      imageString: AppImages.location,
                      string: formatDistance(house.distanceFromUser),
                      isDetailScreen: false),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
