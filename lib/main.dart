import 'dart:convert';
// ignore: directives_ordering
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map data;
  List employeeData;

  Future getData() async {
    final http.Response response =
        await http.get('https://reqres.in/api/users?page=2');
    data = jsonDecode(response.body);
    setState(() {
      employeeData = data['data'];
    });
  }

  Future<void> _launched;
  String _launchedUrl =
      'https://www.youtube.com/watch?v=yr8F2S3Amas&list=PLOU2XLYxmsIK0r_D-zWcmJ1plIcDNnRkK';

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_key'},
      );
    } else {
      throw 'could not launch $url';
    }
  }

  Future<void> _launchInApp(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_key'},
      );
    } else {
      throw 'could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dummy API'),
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          await Future<void>.delayed(const Duration(seconds: 1));
          setState(() {
          });
        },
        child: ListView.builder(
            itemCount: employeeData == null ? 0 : employeeData.length,
            itemBuilder: (BuildContext context, int index) {
              
              return Card(
                
                color: Colors.yellow.withOpacity(.8),
                child: Padding(
                  key: Key(employeeData.indexOf(data).toString()),
                  padding: const EdgeInsets.all(10.0),
                  child: ExpansionTile(trailing: Icon(Icons.info),
                    
                    title: Text(
                      '${employeeData[index]['id']} ${employeeData[index]['first_name']} ${employeeData[index]['last_name']} ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(employeeData[index]['avatar']),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(
                                  icon: new Icon(Icons.launch),
                                  onPressed: () {
                                    _launchInApp(_launchedUrl);
                                  }),
                              Text('Open the Link for more info')
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
        
      ),
    );
  }
}
