import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/house_bloc.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/constants.dart';
import 'package:real_estate_app/presentation/helpers/currency_formater.dart';
import 'package:real_estate_app/presentation/screens/detail_page/widgets/house_description_widget.dart';
import 'package:real_estate_app/presentation/screens/detail_page/widgets/house_image_widget.dart';
import 'package:real_estate_app/presentation/screens/detail_page/widgets/house_location_map_widget.dart';
import 'package:real_estate_app/presentation/screens/detail_page/widgets/house_price_info_widget.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        isExpanded = true;
      });
    });
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1100), // Animation duration
      vsync: this,
    )..forward();

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 3), // Start position (just below the screen)
      end: Offset.zero, // End position (final position)
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut, // Smooth easing effect
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final house = ModalRoute.of(context)?.settings.arguments as House;
    return Scaffold(
      body: BlocBuilder<HouseBloc, HouseState>(builder: (context, state) {
        return SingleChildScrollView(
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
                    duration: const Duration(
                        milliseconds: 500), // Duration of the animation
                    height: isExpanded
                        ? 20
                        : 0, // Height changes based on _isExpanded
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ), // Rounded corners
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
                        'Location',
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
        );
      }),
    );
  }
}
