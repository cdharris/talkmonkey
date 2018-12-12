import 'package:flutter/material.dart';
import 'package:talkmonkey/face_expression_reader.dart';
import 'package:vector_math/vector_math_64.dart';

class FaceWidget extends StatefulWidget {
  @override
  _FaceState createState() => new _FaceState();
}

class _FaceState extends State<FaceWidget> with WidgetsBindingObserver {
  final FaceExpressionReader reader = FaceExpressionReader.instance;

  @override
  void initState() {
    super.initState();
    reader.addListener(() {
      setState(() {});
    });
    reader.init();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      reader.suspend();
    } else if (state == AppLifecycleState.resumed) {
      reader.init();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
//    reader.dispose();
    super.dispose();
  }

  String _expressionToEmoji() {
    if (!reader.isLeftEyeOpen && reader.isRightEyeOpen) {
      return "😉";
    } else if (reader.isSmiling) {
      return "😀";
    } else {
      return "😐";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Center(
        child: Transform.rotate(
          angle: radians(reader?.headAngleZ ?? 0.0),
          child: new Text(
            _expressionToEmoji(),
            style: TextStyle(fontSize: 120.0),
          ),
        ),
      ),
    );
  }
}
