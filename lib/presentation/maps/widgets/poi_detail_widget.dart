import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/house_bloc/house_bloc.dart';
import 'package:real_estate_app/constants.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';
import 'package:real_estate_app/presentation/helpers/currency_formater.dart';
import 'package:real_estate_app/presentation/helpers/distance_helper.dart';
import 'package:real_estate_app/presentation/widgets/icon_widget.dart';
import 'package:real_estate_app/theme/app_color.dart';

class PoiDetailWidget extends StatelessWidget {
  final House house;
  const PoiDetailWidget({super.key, required this.house});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.9), // White background with transparency
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      height: 240,
                      width: double.infinity,
                      imageUrl: '${Constants.mainUrl}${house.image}',
                      errorWidget: (context, url, error) => Image.asset(
                        height: 240,
                        width: double.infinity,
                        AppImages.housePlaceholder,
                        fit: BoxFit.cover,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                              color:
                                  Theme.of(context).textTheme.titleLarge?.color,
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
                          const SizedBox(height: 16),
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
                                  string:
                                      formatDistance(house.distanceFromUser),
                                  isDetailScreen: false),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.2),
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        Positioned(
          bottom: 68,
          right: 8,
          child: CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.5),
            child: IconButton(
                icon: BlocBuilder<HouseBloc, HouseState>(
                  builder: (context, state) {
                    if (state is HouseState) {
                      return Icon(Icons.favorite, color: state.favoriteHouseIds.contains(house.id) ? Colors.red : Colors.grey[350]);
                    }
                    return Icon(Icons.favorite, color: Colors.white);
                  },
                ),
                onPressed: () {
                  // Add your onPressed logic here
                },
              ),
            ),
        ),
      ],
    );
  }
}
