import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class CommonModel {
  final String icon;
  final String title;
  final String url;
  final String statusBarColor;
  final bool hideAppBar;
  final String json;

  CommonModel(
      {this.icon, this.title, this.url, this.statusBarColor, this.hideAppBar,this.json});

  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return CommonModel(
      icon: json['appversion'],
      title: json['title'],
      url: json['url'],
//      statusBarColor: json['statusBarColor'],
      hideAppBar: json['hideAppBar'],
      json: json.toString(),
    );
  }

  @override
  String toString() {
    return 'CommonModel{icon: $icon, title: $title, url: $url, statusBarColor: $statusBarColor, hideAppBar: $hideAppBar, json: $json}';
  }


}

class _SearchPageState extends State<SearchPage> {
  String showResult = "";

  Future<CommonModel> fetchPost() async {
    final response = await http.get('http://mts.mariclub.com:5282/checkupdate');
    final result = json.decode(response.body);
    return CommonModel.fromJson(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Http"),
      ),
      body: FutureBuilder(
        future: fetchPost(),
        builder: (BuildContext context, AsyncSnapshot<CommonModel> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Input a URL to start');
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
              return Text('');
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text(
                  '${snapshot.error.toString()}',
                  style: TextStyle(color: Colors.red),
                );
              }
              else
                return Text('${snapshot.data.toString()}');
          }
          return null;
        },
      ),
    );
  }
}
//
//class _SearchPageState extends State<SearchPage> {
//  String showResult = "";
//
//  Future<CommonModel> fetchPost() async {
//    final response = await http.get('http://192.168.1.118:5282/checkupdate');
//    final result = json.decode(response.body);
//    return CommonModel.fromJson(result);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Http"),
//      ),
//      body: Column(
//        children: <Widget>[
//          InkWell(
//            onTap: () {
//              fetchPost().then((CommonModel value) {
//                setState(() {
//                  showResult =
//                      '请求结果：\n hideAppBar:${value.hideAppBar}\n icon:${value.icon}';
//                });
//              }).catchError((error) {
//                setState(() {
//                  showResult = error.toString();
//                });
//
//              });
//            },
//            child: Text('点我'),
//          ),
//          Text(showResult)
//        ],
//      ),
//    );
//  }
//}
