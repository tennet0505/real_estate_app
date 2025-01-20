import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/business_logic/house_bloc/house_bloc.dart';
import 'package:real_estate_app/presentation/helpers/app_local.dart';
import 'package:real_estate_app/theme/app_color.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController textEditingController;

  const SearchWidget({
    super.key,
    required this.textEditingController,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(() {
      setState(() {}); // Triggers a rebuild whenever the text changes
    });
  }

  @override
  void dispose() {
    widget.textEditingController.removeListener(() {});
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        cursorColor: AppColor.mediumColor,
        cursorHeight: 14,
        controller: widget.textEditingController,
        decoration: InputDecoration(
          label: Text(
            AppLocal.searchHome.tr(),
            style: TextStyle(
              color: AppColor.mediumColor,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.1,
              fontFamily: 'GothamSSm',
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
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
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          suffixIcon:
          widget.textEditingController.text.isNotEmpty
          ? IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        widget.textEditingController.clear();
                        context.read<HouseBloc>().add(const SearchHouses(''));
                      },
                    )
                    : const Icon(
            Icons.search,
            color: AppColor.mediumColor,
          ),
        ),
      ),
    );
  }
}
