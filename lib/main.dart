import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'package:magic_sdk/modules/web3/magic_credential.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(const MyApp());

  const String apiKey = '$APIKEY';
  const String rpcUrl = 'https://rpc-mumbai.matic.today';
  const int chainId = 80001;

  Magic.instance =
      Magic.custom(apiKey, rpcUrl: rpcUrl, chainId: chainId); // your own node

  debugPrint(Magic.instance.toString());

  // print(Magic.instance);
  // Magic.instance = Magic(apiKey);
}

class MyApp extends StatelessWidget {
  // https://stackoverflow.com/questions/52056035/myhomepagekey-key-this-title-superkey-key-in-flutter-what-would-b

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Stack(children: [
      MaterialApp(
        title: 'Flutter Demo Home Page',
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
        ),
      ),
      Magic.instance.relayer
    ]));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Magic magic = Magic.instance; // instantiate

  final client = Web3Client.custom(Magic.instance.provider);
  final credential = MagicCredential(Magic.instance.provider);

  int _counter = 0;
  var cred = "init";

  void getAccount() async {
    debugPrint(magic.toString());
    debugPrint("getAccount");
    debugPrint(credential.toString());

    // try {
    //   debugPrint("loginwithSMS");
    //   await magic.auth.loginWithSMS(phoneNumber: '14155086888');
    //   debugPrint("finish await");
    // } catch (e) {
    //   debugPrint("$e");
    // }

    try {
      debugPrint("loginwithMagicLink");
      debugPrint(magic.auth.toString());

      var linkauth = await magic.auth
          .loginWithMagicLink(email: 'timfong888@gmail.com', showUI: false);
      debugPrint("after await $linkauth");
    } catch (e) {
      debugPrint("error: $e");
    }

    try {
      debugPrint("isLoggedIn");
      final isLoggedIn = await magic.user.isLoggedIn();
      debugPrint(isLoggedIn.toString()); // => `true` or `false`
    } catch (e) {
      // Handle errors if required!
      debugPrint("error: $e");
    }

    final isLoggedIn = await magic.user.isLoggedIn();
    debugPrint(isLoggedIn.toString()); // => `true` or `false`

    var cred = await credential.getAccount();
    debugPrint("account, ${cred.hex}");
  }

  void _incrementCounter() {
    print("counter");
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// get account
            ElevatedButton(
                onPressed: getAccount, child: const Text("getAccount")),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
