import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/house_bloc/house_bloc.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/helpers/app_local.dart';
import 'package:real_estate_app/presentation/screens/favorite_page/favorite_list_widget.dart';
import 'package:real_estate_app/presentation/widgets/empty_state_widget.dart';
import 'package:real_estate_app/theme/app_color.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  void removeHouse(House house) {
    context.read<HouseBloc>().add(ToggleFavoriteHouseEvent(house));
  }

  Future<void> _onRefresh() async {
    context.read<HouseBloc>().add(const GetFavoriteHouses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            AppLocal.myWishlist.tr(),
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'GothamSSm',
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
        ),
      ),
      body: BlocConsumer<HouseBloc, HouseState>(
        listener: (context, state) {
          if (state is HouseRemovedFromFavoriteState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                    content: Text(
                        "${state.removedHouseZip} ${AppLocal.removeFromList.tr()}"),
                    backgroundColor: Colors.red),
              );
          }
        },
        builder: (context, state) {
          if (state is HouseLoadingState) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColor.redColor,
            ));
          } else if (state is HouseErrorState) {
            return EmptyStateWidget(
              onRefresh: _onRefresh,
              isFavorite: true,
              message: state.message,
            );
          } else if (state is HouseState) {
            return ListView.builder(
              itemCount: state.favoriteHouses.length,
              itemExtent: 220,
              itemBuilder: (context, index) {
                final house = state.favoriteHouses[index];
                return FavoriteListWidget(
                  house: house,
                  onDelete: () {
                    removeHouse(house);
                    context.read<HouseBloc>().add(const RemovedFromFavorite());
                  },
                );
              },
            );
          } else {
            return EmptyStateWidget(
              onRefresh: _onRefresh,
              message: AppLocal.somethingWentWrong.tr(),
            );
          }
        },
      ),
    );
  }
}
