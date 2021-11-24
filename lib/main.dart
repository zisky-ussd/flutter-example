import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zisky/action_response.dart';
import 'package:zisky/zisky.dart';

void main() {
  runApp(MyApp());
  Zisky.init();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title}) ;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _billerCoder = new TextEditingController();
  TextEditingController _accountNumber = new TextEditingController();
  TextEditingController _amount = new TextEditingController();

  String authResult ='';
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title!),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text(authResult),

            TextFormField(
              controller: _billerCoder,
              decoration: InputDecoration(
                hintText: "Biller Code"
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _accountNumber,
                decoration: InputDecoration(
                    hintText: "Account Number"
                )
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _amount,
                decoration: InputDecoration(
                    hintText: "Amount"
                )
            ),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              child: Text("Verify"),
              onPressed: () => payMerchantAuth(),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void payMerchantAuth() async {
    print("verify");
    try {
      Map<String, String> map = Map();
      map["amount"] = _amount.text;
      map["accountNumber"] = _accountNumber.text;
      map["billerCode"] = _billerCoder.text;
      await Zisky.startAction("9", getAuthResponse, extras: map);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  String getAuthResponse(response) {
    print("RESULT FINAL= $response");
    if (response != null) {
      ActionResponse responseObj = ActionResponse.fromJson(jsonDecode(response));
      if(responseObj.status == "SUCCESS"){
        setState(() {
          authResult = 'Are you sure you want to pay ${responseObj
              .parsed_variables?['amount']} to ${responseObj
              .parsed_variables?['merchantDetails']}';
        });
      }
    }
    return response;
  }
}
