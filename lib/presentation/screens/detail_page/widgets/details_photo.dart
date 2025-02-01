import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_app/constants.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';
import 'package:real_estate_app/presentation/screens/settings_page/settings_page.dart';

class DetailPhotosWidget extends StatefulWidget {
  const DetailPhotosWidget({super.key});

  @override
  _DetailPhotosWidgetState createState() => _DetailPhotosWidgetState();
}

class _DetailPhotosWidgetState extends State<DetailPhotosWidget> {
  late PageController _pageController;
  int _currentPage = 0;
  bool isChangeColor = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Restore portrait-only mode when leaving this screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final house = ModalRoute.of(context)?.settings.arguments as House;
    final imageUrl = '${Constants.mainUrl}${house.image}';
    final imageCount = 10;

    return Scaffold(
      backgroundColor: context.watch<ThemeProvider>().isDarkMode
          ? Colors.black
          : isChangeColor
              ? Colors.white
              : Colors.black,
      body: Stack(
        children: [
          InteractiveViewer(
            panEnabled: true,
            boundaryMargin: EdgeInsets.all(0),
            minScale: 1.0,
            maxScale: 3.0, // Allows zooming up to 3x
            child: PageView.builder(
              controller: _pageController,
              itemCount: imageCount,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isChangeColor = !isChangeColor;
                      });
                    },
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context)
                          .size
                          .width, // Full screen width
                      imageUrl: imageUrl,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        width: MediaQuery.of(context).size.width,
                        AppImages.housePlaceholder,
                        fit: BoxFit.fitWidth,
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 48,
            right: 10,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: context.watch<ThemeProvider>().isDarkMode
                    ? Colors.white
                    : isChangeColor
                        ? Colors.black
                        : Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            left: 16,
            bottom: 48,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                '${_currentPage + 1}/$imageCount',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
