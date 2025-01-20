import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/house_bloc/house_bloc.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/helpers/app_local.dart';

class HouseDescription extends StatelessWidget {
  final House house; // Add a houseId to identify the specific house
  final bool isFavorite;

  const HouseDescription(
      {super.key, required this.house, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    // Check if the state has the favorite house ids
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppLocal.description.tr(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            Spacer(),
            BlocConsumer<HouseBloc, HouseState>(listener: (context, state) {
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
            }, builder: (context, state) {
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                  color: isFavorite
                      ? Colors.red
                      : Theme.of(context).textTheme.titleLarge?.color,
                ),
                onPressed: () {
                  BlocProvider.of<HouseBloc>(context)
                      .add(ToggleFavoriteHouseEvent(house));
                  // context.read<HouseBloc>().add(ToggleFavoriteHouseEvent(house));
                  if (isFavorite) {
                    context.read<HouseBloc>().add(const RemovedFromFavorite());
                  }
                },
              );
            }),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          house.description,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.titleLarge?.color,
            height: 1.3,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
            fontFamily: 'GothamSSm',
          ),
        ),
      ],
    );
  }
}
