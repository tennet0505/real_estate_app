import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/house_bloc.dart';
import 'package:real_estate_app/theme/app_color.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';
import 'package:real_estate_app/presentation/screens/home_page/widgets/list_item_widget.dart';
import 'package:real_estate_app/presentation/screens/home_page/widgets/search_widget.dart';
import 'package:real_estate_app/presentation/widgets/empty_state_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Stack(
      children: [
        BlocBuilder<HouseBloc, HouseState>(
          builder: (context, state) {
            if (state is HouseLoadingState) {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppColor.redColor,
              ));
            } else if (state is HouseErrorState) {
              // Show Snackbar when there is an error
              Future.delayed(Duration.zero, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              });
              return const SizedBox.shrink();
            } else if (state is HouseState) {
              return RefreshIndicator(
                color: AppColor.backgroundColorDarkTertiary,
                backgroundColor: Theme.of(context).colorScheme.secondary,
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
                          return ListItemWidget(house: house);
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
    );
  }
}