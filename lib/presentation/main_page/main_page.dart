import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/house_bloc.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/helpers/app_color.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';
import 'package:real_estate_app/constants.dart';
import 'package:real_estate_app/presentation/helpers/currency_formater.dart';
import 'package:real_estate_app/presentation/helpers/distance_helper.dart';
import 'package:real_estate_app/presentation/main_page/empty_state_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HouseBloc>().add(const GetHouses());
    textEditingController.addListener(() {
      context.read<HouseBloc>().add(SearchHouses(textEditingController.text));
    });
  }

  Future<void> _onRefresh() async {
    context.read<HouseBloc>().add(const GetHouses());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.lightGrayColor,
      child: Stack(
        children: [
          BlocBuilder<HouseBloc, HouseState>(
            builder: (context, state) {
              if (state is HouseLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HouseState) {
                return RefreshIndicator(
                  onRefresh: _onRefresh, // Refresh handler
                  child: state.houses.isEmpty
                      ? const EmptyStateWidget()
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 54),
                          itemCount: state.houses.length,
                          itemExtent: 128,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemBuilder: (context, index) {
                            final house = state.houses[index];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          offset: const Offset(0, 2),
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(18, 8, 8, 8),
                                      child: ItemHouseWidget(house: house),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          '/detail_screen',
                                          arguments: house,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                );
              } else if (state is HouseErrorState) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return const EmptyStateWidget();
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: SearchWidget(textEditingController: textEditingController),
          ),
        ],
      ),
    );
  }
}

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
        child: 
        Hero(
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
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
              Text(
                '${house.zip.replaceAll(' ', '')} ${house.city}',
                style: const TextStyle(
                  fontSize: 10,
                  height: 0.8,
                  color: AppColor.mediumColor,
                  fontWeight: FontWeight.w300,
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

class IconWidget extends StatelessWidget {
  final String imageString;
  final bool isDetailScreen;
  final String string;
  const IconWidget(
      {super.key,
      required this.imageString,
      required this.string,
      this.isDetailScreen = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          color: AppColor.mediumColor,
          imageString,
          width: isDetailScreen ? 14 : 12,
          height: isDetailScreen ? 16 : 14,
        ),
        SizedBox(width: isDetailScreen ? 2 : 4),
        Text(
          string,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isDetailScreen ? 10 : 8,
            color: AppColor.mediumColor,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
            fontFamily: 'GothamSSm',
          ),
        ),
        SizedBox(
          width: isDetailScreen ? 16 : 20,
        ),
      ],
    );
  }
}

class SearchWidget extends StatelessWidget {
  final TextEditingController textEditingController;

  const SearchWidget({
    super.key,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        cursorColor: AppColor.mediumColor,
        controller: textEditingController,
        decoration: InputDecoration(
          label: const Text(
            'Search for a home',
            style: TextStyle(
              color: AppColor.mediumColor,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.1,
              fontFamily: 'GothamSSm',
            ),
          ),
          filled: true,
          fillColor: AppColor.darkGrayColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          suffixIcon: const Icon(
            Icons.search,
            color: AppColor.mediumColor,
          ),
        ),
      ),
    );
  }
}
