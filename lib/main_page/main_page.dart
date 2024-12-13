import 'package:flutter/material.dart';
import 'package:real_estate_app/Models/house.dart';
import 'package:real_estate_app/Theme/app_color.dart';
import 'package:real_estate_app/Theme/app_images.dart';
import 'package:real_estate_app/api_client.dart';
import 'package:real_estate_app/main_page/empty_state_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final textEditingController = TextEditingController();
  var _houses = <House>[];
  var _filteredHouses = <House>[];
  var isSearchEmpty = false;
  final client = ApiClient();

  void search() {
    final query = textEditingController.text;
    if (query.isNotEmpty) {
      _filteredHouses = _houses.where((House house) {
        return house.zip.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      _filteredHouses = _houses;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getHouses();

    _filteredHouses = _houses;
    textEditingController.addListener(search);
  }

  Future<void> getHouses() async {
    final houses = await client.getHouses();
    _houses = houses;
    _filteredHouses = houses;
    setState(() {});
    print(houses);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _filteredHouses.isEmpty? 
        const EmptyStateWidget() 
        : ListView.builder(
          padding: const EdgeInsets.only(top: 60),
          itemCount: _filteredHouses.length,
          itemExtent: 152,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (BuildContext context, int index) {
            final house = _filteredHouses[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 5,
                        )
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ItemHouseWidget(house: house),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      onTap: () {
                        print('tap item');
                      },
                    ),
                  ),
                ],
              ),
            );
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
        child: Image.asset(
          'images/ic_placeholder.png',
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
                house.zip,
                style:
                    const TextStyle(fontSize: 14, color: AppColor.mediumColor),
              ),
              const Spacer(),
              const Row(
                children: [
                  IconWidget(imageString: AppImages.bed, string: '1'),
                  IconWidget(imageString: AppImages.shower, string: '1'),
                  IconWidget(imageString: AppImages.mapLayer, string: '46'),
                  IconWidget(imageString: AppImages.location, string: '54.6km'),
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
  const SearchWidget({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        cursorColor: AppColor.mediumColor,
        cursorHeight: 14,
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