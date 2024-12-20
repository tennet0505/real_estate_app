import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/house_bloc.dart';
import 'package:real_estate_app/presentation/helpers/app_local.dart';
import 'package:real_estate_app/theme/app_color.dart';
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
     final searchQuery = context.read<HouseBloc>().searchQuery;
    textEditingController.text = searchQuery; 

    textEditingController.addListener(() {
      context.read<HouseBloc>().add(SearchHouses(textEditingController.text));
    });
  }

  Future<void> _onRefresh() async {
    context.read<HouseBloc>().add(RefreshHouses());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Hides the keyboard
      },
      child: Stack(
        children: [
          BlocListener<HouseBloc, HouseState>(
            listener: (context, state) {
              if (state is HouseState && state.errorMessage != '') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocal.noInternetConnection.tr(),),backgroundColor: Colors.red),
                );
              }
            },
            child: BlocBuilder<HouseBloc, HouseState>(
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
                    onRefresh: _onRefresh, // Refresh handler
                    child: ListView.builder(
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SearchWidget(textEditingController: textEditingController),
          ),
        ],
      ),
    );
  }
}
