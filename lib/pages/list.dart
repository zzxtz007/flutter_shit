import 'dart:convert';
import 'dart:isolate';
import 'package:flutter_shit/model/Region.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ListViewDemo extends StatefulWidget {
  @override
  _ListViewDemoState createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  List<Region> widgets;
  List<Region> currentWidgets;
  int pageCount = 10;
  int pageIndex = 1;
  int dataListFrom = 0;
  int dataListTo = 10;
  ScrollController scrollController = ScrollController();
  bool canILoad = true;
  bool showFloatButton = false;

  @override
  void initState() {
    scrollController.addListener(() {
//      print(scrollController.position.pixels);
//      print(scrollController.position.maxScrollExtent);
      if (scrollController.position.pixels > 120) {
        setState(() {
          showFloatButton = true;
        });
      } else {
        setState(() {
          showFloatButton = false;
        });
      }
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (canILoad == false) {
          return;
        }
        setState(() {
          setPageIndex(pageIndex + 1);
          if (dataListTo >= widgets.length) {
            dataListTo = widgets.length;
            canILoad = false;
          }
          currentWidgets.addAll(widgets.getRange(dataListFrom, dataListTo));
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: !showFloatButton
            ? null
            : FloatingActionButton(
                onPressed: _goToTop,
                child: Icon(Icons.vertical_align_top),
              ),
        appBar: AppBar(
          title: Text('中国行政区'),
        ),
        body: RefreshIndicator(
            child: widgets == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: currentWidgets.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == currentWidgets.length) {
                        if (canILoad) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              height: 50,
                              padding: EdgeInsets.only(left: 20),
                              alignment: AlignmentDirectional.center,
                              decoration: BoxDecoration(),
                              child: Text('已经到最后了!'),
                            ),
                          );
                        }
                      }
                      var region = currentWidgets[index];
                      return ExpansionTile(
                        title: Text(
                          region.name,
                          style: TextStyle(fontSize: 20),
                        ),
                        children: region.pchilds.map((p) {
                          return ExpansionTile(
                            title: Text(
                              p.name,
                              style: TextStyle(fontSize: 16),
                            ),
                            children: p.cchilds
                                .where((c) => c.name != '市辖区')
                                .map((c) {
                              return FractionallySizedBox(
                                widthFactor: 1,
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: 5),
                                  padding: EdgeInsets.only(left: 20),
                                  alignment: AlignmentDirectional.centerStart,
                                  decoration: BoxDecoration(
                                      color: Colors.deepOrangeAccent),
                                  child: Text(c.name),
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      );
                    }),
            onRefresh: _loadData));
  }

  _ListViewDemoState() {
    doGetCityListInBack();
  }

  void setPageIndex(int index) {
    pageIndex = index;
    dataListFrom = (pageIndex - 1) * pageCount;
    dataListTo = (pageIndex) * pageCount;
  }

  Future<void> _loadData() async {
//    doGetCityListInBack() 下面测试用 正式应该用注释部分来重新加载数据
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      initConfig(widgets.reversed.toList());
    });
  }

  void initConfig(List list) {
    canILoad = true;
    widgets = list;
    pageIndex = 1;
    dataListFrom = (pageIndex - 1) * pageCount;
    dataListTo = (pageIndex) * pageCount;
    currentWidgets = widgets.getRange(dataListFrom, dataListTo).toList();
  }

  //后台加载数据
  void doGetCityListInBack() async {
    ReceivePort receivePort = ReceivePort();
    //创建后台线程
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    SendPort sendPort = await receivePort.first;

    ReceivePort response = ReceivePort();

    sendPort.send([
      'https://www.mxnzp.com/api/address/list?app_id=nwnimemktjdvinm6&app_secret=Qm9KNEVvWjRUT3dic3QraWxZZ0xVUT09',
      response.sendPort
    ]);

    var msg = await response.first;

    setState(() {
      initConfig(msg);
    });
  }

  _goToTop() {
    scrollController.animateTo(0.0,
        duration: Duration(microseconds: 2500), curve: Curves.ease);
  }
}

void dataLoader(SendPort sendPort) async {
  ReceivePort port = ReceivePort();

  sendPort.send(port.sendPort);

  await for (var msg in port) {
    String url = msg[0];
    SendPort replyTo = msg[1];

    http.Response response = await http.get(url);

    var body = json.decode(response.body);
    if (body["code"] == 1) {
      replyTo.send(body["data"] != null
          ? (body['data'] as List).map((i) => Region.fromJson(i)).toList()
          : null);
    }
  }
}
