import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/UI/home_page.dart';
import 'package:podboi/UI/mini_player.dart';
import 'package:podboi/UI/subscriptions_page.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedPage = 0;
  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: 2,
              onPageChanged: (newIndex) {
                setState(() {
                  _selectedPage = newIndex;
                });
              },
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Consumer(builder: (context, ref, child) {
                    return HomePage(
                      ref: ref,
                    );
                  });
                } else {
                  return SubscriptionsPage();
                }
              },
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: MiniPlayer()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (newIndex) {
          setState(() {
            _selectedPage = newIndex;
          });
          _pageController.animateToPage(newIndex,
              duration: Duration(
                milliseconds: 500,
              ),
              curve: Curves.ease);
        },
        backgroundColor: Theme.of(context).backgroundColor,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.home,
              color: Theme.of(context).accentColor,
            ),
            // ignore: deprecated_member_use
            title: Text(
              'Home',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).accentColor,
                  fontFamily: 'Segoe'),
            ),
            icon: Icon(Icons.home, color: Colors.grey.withOpacity(0.5)),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.book,
              color: Theme.of(context).accentColor,
            ),
            // ignore: deprecated_member_use
            title: Text(
              'Subscriptions',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).accentColor,
                  fontFamily: 'Segoe'),
            ),
            icon: Icon(
              Icons.book,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
