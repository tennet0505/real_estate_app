import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/constants.dart';
import 'package:real_estate_app/presentation/helpers/app_local.dart';
import 'package:real_estate_app/theme/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            AppLocal.about.tr(),
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'GothamSSm',
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocal.aboutText.tr(),
              style: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontSize: 16,
                height: 1.1,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.2,
                fontFamily: 'GothamSSm',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              AppLocal.designAndDevelopment.tr(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Image.asset(
                  'images/dtt_banner.png',
                  width: 136,
                ),
                const SizedBox(
                  width: 22,
                ),
                Column(
                  children: [
                    Text(
                      AppLocal.byDtt.tr(),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        _launchURL(Constants.webSiteUrl);
                      },
                      child: const Text(
                        'd-tt.nl',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
