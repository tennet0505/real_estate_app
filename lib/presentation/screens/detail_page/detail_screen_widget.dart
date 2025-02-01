import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/house_bloc/house_bloc.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/constants.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';
import 'package:real_estate_app/presentation/helpers/app_local.dart';
import 'package:real_estate_app/presentation/helpers/currency_formater.dart';
import 'package:real_estate_app/presentation/screens/detail_page/widgets/house_description_widget.dart';
import 'package:real_estate_app/presentation/screens/detail_page/widgets/house_image_widget.dart';
import 'package:real_estate_app/presentation/screens/detail_page/widgets/house_location_map_widget.dart';
import 'package:real_estate_app/presentation/screens/detail_page/widgets/house_price_info_widget.dart';
import 'package:real_estate_app/presentation/screens/settings_page/settings_page.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  double _calculateOpacity(double offset) {
    return (offset / 100).clamp(0.0, 1.0);
  }

  double _calculateCornerRadiusOffset(double offset, double maxRadius,
      double minRadius, double maxOffset, double maxDownOffset) {
    if (offset > 0) {
      final normalizedOffset = (offset / maxOffset).clamp(0.0, 1.0);
      return (maxRadius - normalizedOffset * (maxRadius - minRadius))
          .clamp(minRadius, maxRadius);
    } else {
      final normalizedOffset = (offset.abs() / maxDownOffset).clamp(0.0, 1.0);
      return (maxRadius - normalizedOffset * (maxRadius - minRadius))
          .clamp(minRadius, maxRadius);
    }
  }

  double _calculateCornerRadius(double offset) {
    return _calculateCornerRadiusOffset(offset, 24, 0, 100, 25);
  }

  Color _calculateArrowColor(double offset) {
    final opacity = (offset / 100).clamp(0.0, 1.0);
    return Color.lerp(Colors.white, Colors.black, opacity)!;
  }

  double _calculateZoomScale() {
    if (_scrollOffset < 0) {
      return 1 - (_scrollOffset / 1000);
    }
    return 1;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final house = ModalRoute.of(context)?.settings.arguments as House;
    return Scaffold(
      body: BlocBuilder<HouseBloc, HouseState>(
        builder: (context, state) {
          return Stack(
            children: [
              Positioned(
                top: (_scrollOffset > 0) ? -_scrollOffset * 0.5 : 0,
                child: Transform.scale(
                  scale:
                      _calculateZoomScale(), // Apply zoom only when scrolling down
                  child: HouseImageSection(
                    imageUrl: '${Constants.mainUrl}${house.image}',
                    id: house.id,
                    color: Theme.of(context)
                        .appBarTheme
                        .backgroundColor!
                        .withValues(
                          alpha: _calculateOpacity(_scrollOffset),
                        ),
                  ),
                ),
              ),
              Positioned.fill(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 265,
                          color: Theme.of(context)
                              .appBarTheme
                              .backgroundColor
                              ?.withValues(
                                alpha: _calculateOpacity(_scrollOffset),
                              )),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                _calculateCornerRadius(_scrollOffset)),
                            topRight: Radius.circular(
                                _calculateCornerRadius(_scrollOffset)),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HousePriceInfo(
                                price: formatCurrency(house.price),
                                bedrooms: house.bedrooms,
                                bathrooms: house.bathrooms,
                                size: house.size,
                                distanceFromUser: house.distanceFromUser,
                              ),
                              const SizedBox(height: 30),
                              HouseDescription(
                                house: house,
                                isFavorite:
                                    state.favoriteHouseIds.contains(house.id),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AppLocal.location.tr(),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.color,
                                ),
                              ),
                              const SizedBox(height: 16),
                              HouseLocationMap(
                                latitude: house.latitude,
                                longitude: house.longitude,
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                height: 280,
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/photo_screen',
                        arguments: house,
                      );
                    },
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                    )),
              ),
              Positioned(
                top: 0,
                left: 0,
                width: 50,
                child: AppBar(
                  leading: IconButton(
                    icon: Image.asset(
                      AppImages.arrow,
                      color: context.watch<ThemeProvider>().isDarkMode
                          ? Colors.white
                          : _calculateArrowColor(_scrollOffset),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Opacity(
                    opacity: _calculateOpacity(_scrollOffset),
                    child: Text(
                      '${house.zip}, ${house.city}',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'GothamSSm',
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                  ),
                  foregroundColor: context.watch<ThemeProvider>().isDarkMode
                      ? Colors.white
                      : _calculateArrowColor(_scrollOffset),
                  backgroundColor: (_scrollOffset > 150)
                      ? Theme.of(context).appBarTheme.backgroundColor
                      : Colors.transparent,
                  elevation: 0,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
