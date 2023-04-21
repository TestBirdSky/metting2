import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base/BaseController.dart';
import '../base/BaseStatelessPage.dart';

class ControllerUsePage extends BaseStatelessPage<TestController2> {
  @override
  Widget createBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("widget.title"),
      ),
      body: Center(
          child: Column(
            children: [
              GetBuilder<TestController2>(
                  id: "count",
                  builder: (c) {
                    return Text(
                      "change${c.count}",
                      style: const TextStyle(fontSize: 50),
                    );
                  }),
              Text(
                "不变${controller.count}",
                style: const TextStyle(fontSize: 50),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addCount();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  TestController2 initController() => TestController2();
}

class TestController2 extends BaseController {
  var count = 1;

  void addCount() {
    count++;
    update(["count"]);
  }

}
