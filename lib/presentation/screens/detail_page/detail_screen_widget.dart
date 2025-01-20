import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/house_bloc/house_bloc.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/constants.dart';
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
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        isExpanded = true;
      });
    });

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    )..forward();

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  double _calculateOpacity(double offset) => (offset / 100).clamp(0.0, 1.0);
  Color _calculateArrowColor(double offset) {
    final opacity = (offset / 100).clamp(0.0, 1.0);
    return Color.lerp(Colors.white, Colors.black, opacity)!;
  }

  @override
  void dispose() {
    _animationController.dispose();
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
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        HouseImageSection(
                          imageUrl: '${Constants.mainUrl}${house.image}',
                          id: house.id,
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: isExpanded ? 20 : 0,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SlideTransition(
                              position: _slideAnimation,
                              child: HousePriceInfo(
                                price: formatCurrency(house.price),
                                bedrooms: house.bedrooms,
                                bathrooms: house.bathrooms,
                                size: house.size,
                                distanceFromUser: house.distanceFromUser,
                              ),
                            ),
                            const SizedBox(height: 30),
                            HouseDescription(
                              house: house,
                              isFavorite: state.favoriteHouseIds.contains(house.id),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocal.location.tr(),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.titleLarge?.color,
                              ),
                            ),
                            const SizedBox(height: 16),
                            HouseLocationMap(
                              latitude: house.latitude,
                              longitude: house.longitude,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  foregroundColor: 
                  context.watch<ThemeProvider>().isDarkMode
                      ? Colors.white
                      : _calculateArrowColor(_scrollOffset),
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha:
                        _calculateOpacity(_scrollOffset),
                      ),
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
