import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/house_bloc.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/helpers/app_color.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';
import 'package:real_estate_app/presentation/helpers/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<HouseBloc, HouseState>(
          builder: (context, state) {
            if (state is HouseLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HouseState) {
              return state.houses.isEmpty
                  ? const EmptyStateWidget()
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 60),
                      itemCount: state.houses.length,
                      itemExtent: 132,
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
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 2),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
        borderRadius: BorderRadius.circular(6.0),
        child: Image.network(
          '${Constants.mainUrl}${house.image}',
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${house.price}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${house.zip.replaceAll(' ', '')} ${house.city}',
                style:
                    const TextStyle(fontSize: 14, color: AppColor.mediumColor),
              ),
              const Spacer(),
              Row(
                children: [
                  IconWidget(
                      imageString: AppImages.bed, string: '${house.bedrooms}'),
                  IconWidget(
                      imageString: AppImages.shower,
                      string: '${house.bathrooms}'),
                  IconWidget(
                      imageString: AppImages.mapLayer, string: '${house.size}'),
                  IconWidget(
                      imageString: AppImages.location,
                      string:
                          '${house.distanceFromUser?.toStringAsFixed(2) ?? '0'} km'),
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
  final String string;
  const IconWidget(
      {super.key, required this.imageString, required this.string});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          color: AppColor.mediumColor,
          imageString,
          width: 14,
          height: 14,
        ),
        const SizedBox(width: 2),
        Text(
          string,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10, color: AppColor.mediumColor),
        ),
        const SizedBox(
          width: 16,
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
            style: TextStyle(color: AppColor.mediumColor),
          ),
          filled: true,
          fillColor: AppColor.darkGaryColor,
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

