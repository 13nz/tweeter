import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter/constants/assets_constants.dart';
import 'package:twitter/features/tweet/widgets/tweet_list.dart';
import 'package:twitter/theme/pallette.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(AssetsConstants.twitterLogo,
          colorFilter:
              const ColorFilter.mode(Pallete.blueColor, BlendMode.srcIn),
          height: 30),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    TweetList(),
    Text('Search Screen'),
    Text('Notifications Screen')
  ];
}
