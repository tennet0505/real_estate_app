import 'package:flutter/material.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/screens/favorite_page/favorite_item_widget.dart';

class FavoriteListWidget extends StatelessWidget {
  final VoidCallback onDelete;
  const FavoriteListWidget({
    super.key,
    required this.house, 
    required this.onDelete,
  });

  final House house;

  @override
  Widget build(BuildContext context) {    
    return Dismissible(
      key: Key(house.id.toString()), // Unique key for each item
      direction: DismissDirection.endToStart, // Swipe from right to left
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        onDelete(); // Trigger the delete callback
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
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
              child: FavoriteItemHouseWidget(house: house),
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
      ),
    );
  }
}