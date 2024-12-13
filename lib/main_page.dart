import 'package:flutter/material.dart';
import 'package:real_estate_app/Theme/app_color.dart';
import 'package:real_estate_app/Theme/app_images.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final textEditingController = TextEditingController();

  void search() {}

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(search);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(top: 60),
          itemCount: 10,
          itemExtent: 152,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 8),
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
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  6.0), 
                              child: Image.asset(
                                'images/ic_placeholder.png',
                                width: 80, 
                                height: 80,
                                fit: BoxFit
                                    .cover, 
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  const Text(
                                    '45,000',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    'time ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.mediumColor),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Image.asset(
                                        AppImages.bed,
                                        width: 14,
                                        height: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        '1',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ]),
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
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
          child: SearchWidget(textEditingController: textEditingController),
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
