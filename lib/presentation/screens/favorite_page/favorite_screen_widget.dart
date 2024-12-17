import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/house_bloc.dart';
import 'package:real_estate_app/presentation/screens/favorite_page/favorite_list_widget.dart';
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
    context.read<HouseBloc>().add(const GetFavoriteHouses());
  }

  void removeHouse(int houseId) {
    context.read<HouseBloc>().add(ToggleFavoriteHouseEvent(houseId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HouseBloc, HouseState>(
      builder: (context, state) {
        if (state is HouseLoadingState) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColor.redColor,
          ));
        } else if (state is HouseErrorState) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
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
                  removeHouse(house.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${house.zip} removed from favorites"), 
                      backgroundColor:Colors.red),
                  );
                },
              );
            },
          );
        } else {
          return Text("data");
        }
      },
    );
  }
}
