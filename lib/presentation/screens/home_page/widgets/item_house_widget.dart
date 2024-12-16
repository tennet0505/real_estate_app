import 'package:flutter/material.dart';
import 'package:real_estate_app/constants.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/helpers/app_color.dart';
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
          child: Image.network(
            '${Constants.mainUrl}${house.image}',
            width: 74,
            height: 74,
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
              Text(
                '${house.zip.replaceAll(' ', '')} ${house.city}',
                style: const TextStyle(
                  fontSize: 10,
                  height: 0.8,
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