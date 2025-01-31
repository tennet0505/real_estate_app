import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/house_bloc/house_bloc.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/helpers/app_local.dart';
import 'package:real_estate_app/presentation/maps/map.dart';
import 'package:real_estate_app/presentation/maps/widgets/poi_detail_widget.dart';
import 'package:real_estate_app/theme/app_color.dart';
import 'package:real_estate_app/presentation/screens/home_page/widgets/list_item_widget.dart';
import 'package:real_estate_app/presentation/screens/home_page/widgets/search_widget.dart';
import 'package:real_estate_app/presentation/widgets/empty_state_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final textEditingController = TextEditingController();
  bool isShowMap = false; // Move isShowMap to class-level
  House? selectedHouse;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<HouseBloc>().add(const GetHouses());
    final searchQuery = context.read<HouseBloc>().searchQuery;
    textEditingController.text = searchQuery;

    textEditingController.addListener(() {
      context.read<HouseBloc>().add(SearchHouses(textEditingController.text));
    });
  }

  Future<void> _onRefresh() async {
    context.read<HouseBloc>().add(RefreshHouses());
  }

  void _onHouseSelected(House house) {
    setState(() {
      selectedHouse = house; // Set the selected house
    });
  }

  void _closeDetail() {
    setState(() {
      selectedHouse = null; // Reset the selected house
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Hide keyboard
      },
      child: Stack(
        children: [
          BlocBuilder<HouseBloc, HouseState>(
            builder: (context, state) {
              if (state is HouseLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.redColor,
                  ),
                );
              } else if (state is HouseErrorState) {
                return EmptyStateWidget(
                  onRefresh: _onRefresh,
                  message: state.message,
                );
              } else if (state is HouseState) {
                return RefreshIndicator(
                  color: AppColor.backgroundColorDarkTertiary,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onRefresh: _onRefresh,
                  child: isShowMap
                      ? Padding(
                          padding: const EdgeInsets.only(top: 66),
                          child: MapScreen(
                            houses: List.from(state.houses),
                            onHouseSelected: (House house) {
                              _onHouseSelected(house);
                            },
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 54),
                          itemCount: state.houses.length,
                          itemExtent: 128,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemBuilder: (context, index) {
                            final house = state.houses[index];
                            return ListItemWidget(house: house, state: state);
                          },
                        ),
                );
              } else {
                return EmptyStateWidget(
                  onRefresh: _onRefresh,
                  showRefreshButton: true,
                  message: AppLocal.somethingWentWrongTryRefresh.tr(),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SearchWidget(
                      textEditingController: textEditingController),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isShowMap = !isShowMap;
                    });
                  },
                  icon: !isShowMap
                      ? Icon(Icons.map,
                          color: Theme.of(context).textTheme.titleLarge?.color)
                      : Icon(Icons.list,
                          color: Theme.of(context).textTheme.titleLarge?.color),
                ),
              ],
            ),
          ),
          if (selectedHouse != null)
            Positioned(
              top: 0,
              bottom: 0, // Adjust this value for positioning
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  _closeDetail(); // Ensure it's called correctly
                },
                child: Stack(
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: double.infinity, // Ensur
                      width: double.infinity, // Ensures full width
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/detail_screen',
                            arguments: selectedHouse!,
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 340, // Ensur
                          width: double.infinity,
                          child: PoiDetailWidget(
                            house: selectedHouse!,
                            onClose: () {
                              _closeDetail(); // Ensure it's called correctly
                            },
                          ), // Ensures full width
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
