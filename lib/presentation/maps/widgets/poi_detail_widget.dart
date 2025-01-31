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
  final void Function() onClose;

  const PoiDetailWidget(
      {super.key, required this.house, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .appBarTheme
                  .backgroundColor, // White background with transparency
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${house.zip.replaceAll(' ', '')} ${house.city}',
                          style: TextStyle(
                            fontSize: 14,
                            // height: 1,
                            color: AppColor.mediumColor,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1,
                            fontFamily: 'GothamSSm',
                          ),
                        ),
                        const SizedBox(height: 4),
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
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            IconWidget(
                                imageString: AppImages.bed,
                                string: '${house.bedrooms}',
                                isDetailScreen: true),
                            IconWidget(
                                imageString: AppImages.shower,
                                string: '${house.bathrooms}',
                                isDetailScreen: true),
                            IconWidget(
                                imageString: AppImages.mapLayer,
                                string: '${house.size}',
                                isDetailScreen: true),
                            IconWidget(
                                imageString: AppImages.location,
                                string: formatDistance(house.distanceFromUser),
                                isDetailScreen: true),
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
        Positioned(
          top: 8,
          right: 8,
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.2),
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                onClose();
              },
            ),
          ),
        ),
        Positioned(
          bottom: 64,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.0),
            child: BlocBuilder<HouseBloc, HouseState>(
              builder: (context, state) {
                final isFavorite = state.favoriteHouseIds.contains(house.id);
                if (state is HouseState) {
                  return IconButton(
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: isFavorite
                          ? Colors.red
                          : Theme.of(context).textTheme.titleLarge?.color,
                    ),
                    onPressed: () {
                      BlocProvider.of<HouseBloc>(context)
                          .add(ToggleFavoriteHouseEvent(house));
                      if (state.favoriteHouseIds.contains(house.id)) {
                        context
                            .read<HouseBloc>()
                            .add(const RemovedFromFavorite());
                      }
                    },
                  );
                }
                return Icon(Icons.favorite, color: Colors.white);
              },
            ),
          ),
        ),
      ],
    );
  }
}
