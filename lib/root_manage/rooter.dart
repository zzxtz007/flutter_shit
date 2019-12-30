import 'package:flutter/material.dart';
import 'package:flutter_shit/pages/home.dart';
import 'package:flutter_shit/pages/list.dart';
import 'package:flutter_shit/pages/preferences.dart';
import 'package:flutter_shit/pages/search.dart';

class Rooter extends StatefulWidget {
  @override
  _RooterState createState() => _RooterState();
}

class _RooterState extends State<Rooter> {
  var _currentIndex = 3;
  final defaultColor = Colors.grey;
  final activeColor = Colors.blueAccent;

  final _controller = PageController(
    initialPage: 3
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        children: <Widget>[
          HomePage(),
          SearchPage(),
          ListViewDemo(),
          Preferences(),
        ],
        controller: _controller,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: defaultColor,
              ),
              title: Text(
                '首页',
                style: TextStyle(
                    color: _currentIndex == 0 ? activeColor : defaultColor),
              ),
              activeIcon: Icon(
                Icons.home,
                color: activeColor,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: defaultColor,
              ),
              title: Text(
                '搜索',
                style: TextStyle(
                    color: _currentIndex == 1 ? activeColor : defaultColor),
              ),
              activeIcon: Icon(
                Icons.search,
                color: activeColor,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                color: defaultColor,
              ),
              title: Text(
                '我的',
                style: TextStyle(
                    color: _currentIndex == 2 ? activeColor : defaultColor),
              ),
              activeIcon: Icon(
                Icons.account_circle,
                color: activeColor,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.save_alt,
                color: defaultColor,
              ),
              title: Text(
                '存储',
                style: TextStyle(
                    color: _currentIndex == 3 ? activeColor : defaultColor),
              ),
              activeIcon: Icon(
                Icons.account_circle,
                color: activeColor,
              )),
        ],
      ),

    );
  }
}
