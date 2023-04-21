import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WishWallPage extends StatefulWidget{
  const WishWallPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WishWallState();
  }
}

class _WishWallState extends State<WishWallPage>{

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var yellowBox = Container(
      color: Colors.yellow,
      height: 100,
      width: 100,
    );

    var redBox = Container(
      color: Colors.red,
      height: 90,
      width: 90,
      child: Text("_counter"),
    );

    var greenBox = InkWell(
      child: Container(
        color: Colors.green,
        height: 80,
        width: 80,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("widget.title"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        // child: Column(
        //   // Column is also a layout widget. It takes a list of children and
        //   // arranges them vertically. By default, it sizes itself to fit its
        //   // children horizontally, and tries to be as tall as its parent.
        //   //
        //   // Invoke "debug painting" (press "p" in the console, choose the
        //   // "Toggle Debug Paint" action from the Flutter Inspector in Android
        //   // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        //   // to see the wireframe for each widget.
        //   //
        //   // Column has various properties to control how it sizes itself and
        //   // how it positions its children. Here we use mainAxisAlignment to
        //   // center the children vertically; the main axis here is the vertical
        //   // axis because Columns are vertical (the cross axis would be
        //   // horizontal).
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     const Text(
        //       'You have pushed the button this many times:',
        //     ),
        //     Text(
        //       '$_counter',
        //       style: Theme.of(context).textTheme.headlineMedium,
        //     ),
        //   ],
        // ),
        child: Stack(
          children: [
            Positioned(
              left: Random().nextInt(50).toDouble(),
              bottom: Random().nextInt(100).toDouble(),
              child: Transform.rotate(
                angle: Random().nextInt(360).toDouble(),
                child: yellowBox,
              ),
            ),
            Positioned(
                right: -10,
                top: 180,
                child: Transform.rotate(
                  angle: 68,
                  child: redBox,
                )),
            Positioned(
              left: Random().nextInt(200).toDouble(),
              bottom: Random().nextInt(600).toDouble(),
              child: Transform.rotate(
                angle: Random().nextInt(360).toDouble(),
                child: greenBox,
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  
}