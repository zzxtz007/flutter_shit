import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<http.Response> fetchPost(String url) async {
    return await http.get(url);
//  final result = json.decode(response.body);
//  return CommonModel.fromJson(result);
  }

  var _imageUrls = [
    'https://f10.baidu.com/it/u=3715626927,227026980&fm=72',
//    'https://media0.giphy.com/media/VbnUQpnihPSIgIXuZv/giphy.webp?cid=790b7611e888f8f6dc5657a3de817ce7e88a44303a30c92b&rid=giphy.webp',
//    'https://media2.giphy.com/media/rwCX06Y5XpbLG/giphy.webp?cid=790b7611e888f8f6dc5657a3de817ce7e88a44303a30c92b&rid=giphy.webp'
  ];

  var _futures = <Future<http.Response>>[];
  double appbarAlpha = 0;

  void _onScroll(double offset) {
    var alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appbarAlpha = alpha;
    });
    print(alpha);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          MediaQuery.removePadding(
            //去除顶部状态栏 MediaQuery.removePadding 参数
            //        removeTop: true,
            //        context: context,
            removeTop: true,
            context: context,
            child: NotificationListener(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification &&
                    scrollNotification.depth == 0) {
                  _onScroll(scrollNotification.metrics.pixels);
                  return true;
                }
                return false;
              },
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 160,
                    child: Swiper(
                      itemCount: _imageUrls.length,
                      autoplay: true,
                      itemBuilder: (BuildContext contest, int index) {
//                        return Image.memory(
//                          _imageFiles[index] ?? null,
//                          fit: BoxFit.fill,
//                        );

                        return FutureBuilder(
                            future: _futures[index],
                            builder: (BuildContext context,
                                AsyncSnapshot<http.Response> snapshot) {
                              Widget returnWegit = Center(
                                child: Text('null'),
                              );
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  returnWegit = Center(
                                    child: Text('none'),
                                  );
                                  break;
                                case ConnectionState.waiting:
                                  returnWegit = Center(
                                    child: CircularProgressIndicator(),
                                  );
                                  break;
                                case ConnectionState.active:
                                  returnWegit = Center(
                                    child: Text('active'),
                                  );
                                  break;
                                case ConnectionState.done:
                                  if (snapshot.hasError) {
                                    returnWegit = Center(
                                      child: Text(
                                        '${snapshot.error}',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    );
                                  } else {
                                    returnWegit = Image.memory(
                                      snapshot.data.bodyBytes,
                                      fit: BoxFit.fill,
                                    );
                                  }
                              }
                              return returnWegit;
                            });
                      },
                      pagination: SwiperPagination(),
                    ),
                  ),
                  Container(
                    height: 800,
                    child: ListTile(
                      title: Text("HHH"),
                    ),
                  ),
                ],
              ),
            ),
          ),
//          Opacity(
//            opacity: appbarAlpha,
//            child: Container(
//              height: 40,
//              decoration: BoxDecoration(color: Colors.white),
//              child: Center(
//                child: Padding(
//                  padding: EdgeInsets.only(top: 0),
//                  child: Text('首页'),
//                ),
//              ),
//            ),
//          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    for (var url in _imageUrls) {
      _futures.add(fetchPost(url));
    }
    super.initState();
  }

//  _HomePageState() {
//    for (var value in _imageUrls) {
//      (() async {
//        var tempHttp = await http.get(value);
//        _imageFiles.add(tempHttp.bodyBytes);
//      });
//    }
//  }
}
