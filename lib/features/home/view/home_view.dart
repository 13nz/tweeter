import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter/constants/assets_constants.dart';
import 'package:twitter/constants/ui_constants.dart';
import 'package:twitter/features/tweet/views/create_tweet_view.dart';
import 'package:twitter/theme/pallette.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;
  final appBar = UIConstants.appBar();

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreateTweet() {
    Navigator.push(context, CreateTweetView.route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreateTweet,
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: _page,
          onTap: onPageChange,
          backgroundColor: Pallete.backgroundColor,
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
              _page == 0
                  ? AssetsConstants.homeFilledIcon
                  : AssetsConstants.homeOutlinedIcon,
              colorFilter:
                  const ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn),
            )),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
              AssetsConstants.searchIcon,
              colorFilter:
                  const ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn),
            )),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
              _page == 2
                  ? AssetsConstants.notifFilledIcon
                  : AssetsConstants.notifOutlinedIcon,
              colorFilter:
                  const ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn),
            )),
          ]),
    );
  }
}
