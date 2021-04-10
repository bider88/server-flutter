import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    )
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool _loading = true;
  HttpServer _server;
  String _host = InternetAddress.loopbackIPv4.host;
  final _port = 8100;

  @override
  void initState() {
    _startServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Text('App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 700,
              child: _loading ?
              Center(
                child: CircularProgressIndicator(),
              )
              :
              WebView(
                initialUrl: 'http://127.0.0.1:$_port/',
                javascriptMode: JavascriptMode.unrestricted
              ),
            )
          ],
        ),
      ),
    );
  }

  _startServer() async {
    _server = await HttpServer.bind(_host, _port);
    print(
      '1. Server running on IP : ' +
      _server.address.toString() +
      ' On Port : ' + _server.port.toString()
    );
    setState(() => _loading = false);
    await for (HttpRequest request in _server) {
      request.response
        ..headers.contentType = new ContentType('text', 'html', charset: 'utf-8')
        ..write('<html><h1>Hello world</h1></html>')
        ..close();
    }
  }
}