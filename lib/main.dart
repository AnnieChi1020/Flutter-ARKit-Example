import 'dart:async';
import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late ARKitController arKitController;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    arKitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Earth Sample')),
        body: ARKitSceneView(
          // ARKit view 執行後，呼叫 onARKitViewCreated
          onARKitViewCreated: onARKitViewCreated,
        ),
      );

  void onARKitViewCreated(ARKitController arKitController) {
    this.arKitController = arKitController;

    // ARKitMaterial 用於決定幾何圖形的渲染方式；定義 3d 幾何外觀的顏色和紋理
    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.lambert,
      diffuse: ARKitMaterialProperty.image('images/earth.jpg'),
    );

    // ARKitSphere 用於創建球體
    final sphere = ARKitSphere(
      materials: [material],
      radius: 0.1,
    );

    // ARKitNode 用於創建節點
    final node = ARKitNode(
      geometry: sphere,
      position: Vector3(0, 0, -0.5),
      eulerAngles: Vector3.zero(),
    );

    // 將節點加入到 ARKitController 中
    this.arKitController.add(node);

    // 設定定時器，每 50 毫秒旋轉一次
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final rotation = node.eulerAngles;
      rotation.x += 0.01;
      node.eulerAngles = rotation;
    });
  }
}
