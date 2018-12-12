import 'dart:async';

import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare/math/mat2d.dart';
import "package:flare_flutter/flare_actor.dart";
import 'package:flutter/material.dart';
import 'package:talkmonkey/game_states.dart';

const ANIMATION_ZOOM = 'Closer';
const ANIMATION_SKY = 'SunSky';
const ANIMATION_BLINK = 'Blink';
const ANIMATION_ITCHING = 'Itching';
const ANIMATION_DARTING = 'Darting';
const ANIMATION_OPENMOUTH = 'OpenMouth';

const ANIMATION_ZOOM_PARTS = 3;

List<String> _animationsAlwaysLooping = [
  ANIMATION_SKY,
  ANIMATION_BLINK,
];

List<String> _animationsExpression = [
  ANIMATION_ITCHING,
  ANIMATION_DARTING,
  ANIMATION_OPENMOUTH,
];

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> implements FlareController {
  GameState current = gameStates['start'];
  bool correct = false;

  bool doFaceRec = false;

  int zoom = 0;
  String expression;

  get canAdvance => correct;

  Map<String, double> _animationTimes = <String, double>{};
  Map<String, ActorAnimation> _animationActors = <String, ActorAnimation>{};

  /// Initializes widget for Flare animations
  /// (In this case we just track instances of them)
  void initialize(FlutterActorArtboard artboard) {
    artboard.animations.forEach((ActorAnimation animation) {
      _animationActors[animation.name] = animation;
      _animationTimes[animation.name] = 0.0;
      print("ActorAnimation Initialized [${animation.name}]");
    });
  }

  void setViewTransform(Mat2D viewTransform) {}

  /// Loop the animations that should always be playing
  ///  add the time that has elapsed, to the animation's timeline tracker
  ///  looping back to the start if the time passes the animation's length
  _loopAnimation(
      String animationName, FlutterActorArtboard artboard, double elapsed) {
    if (_animationTimes[animationName] == null) {
      throw Exception(
          "Animation [${animationName}] was not found in animation times");
    }
    ActorAnimation _animation = _animationActors[animationName];
    _animationTimes[animationName] =
        (_animationTimes[animationName] + elapsed) % _animation.duration;
    _animation.apply(_animationTimes[animationName], artboard, 1.0);
  }

  /// If the elapsed time of the partial animation, is less than the latest time it
  /// should be at in respect to the current step level, then advance it.
  _playAnimationOnceOfStep(String animationName, FlutterActorArtboard artboard,
      double elapsed, int steps, int step) {
    ActorAnimation _animation = _animationActors[animationName];

    if (_animationTimes[ANIMATION_ZOOM] <
        (_animation.duration / steps) * step) {
      _animation.apply(
          _animationTimes[ANIMATION_ZOOM] += elapsed, artboard, 1.0);
    }
  }

  _playAnimationOnce(
      String animationName, FlutterActorArtboard artboard, double elapsed) {
    ActorAnimation _animation = _animationActors[animationName];

    if (_animationTimes[animationName] < _animation.duration) {
      _animation.apply(
          _animationTimes[animationName] += elapsed, artboard, 1.0);
    }
  }

  _resetAnimation(animationName, artboard) {
    _animationActors[animationName].apply(0.0, artboard, 1.0);
  }

  /// Controls Flare Animations (per animation frame)
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    /// Animations 1. - Animations always going on (backgrounds)
    for (String loopAnimationName in _animationsAlwaysLooping) {
      _loopAnimation(loopAnimationName, artboard, elapsed);
    }

    /// Animations 2. - A Single animation played out in 3 steps depending on state.
    /// This is one animation in Flare, that we advance in multiple stages from
    /// code.
    if (this.zoom >= 1) {
      _playAnimationOnceOfStep(
        ANIMATION_ZOOM,
        artboard,
        elapsed,
        ANIMATION_ZOOM_PARTS,
        this.zoom,
      );
    }

    /// Animations 3. - These animations are played out if the widget state
    /// says they should.

    if (this.expression != null) {
      if (_animationsExpression.contains(this.expression)) {
        _loopAnimation(this.expression, artboard, elapsed);
      } else {
        print(
            'State set to an expression [${this.expression}] that has no matching animation');
      }
    }

    ///Reset any other expressions not used
    _animationsExpression
        .where((animationName) => this.expression != animationName)
        .forEach((animationName) {
      _resetAnimation(animationName, artboard);
    });

    return true;
  }

  @override
  void initState() {
    super.initState();

//    if (current.special == 'FaceRec') {
//      doFaceRec = true;
//    }

    this.expression = current?.expression;
  }

  win() {
    showDialog(
      context: context,
      builder: (context) => GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: AlertDialog(
            title: Text('Completed!'),
            content: Container(
              child: Text(
                'Great work! You passed the basic level of monkey understanding! Continue through the rest of the exercises to get your proficiency certificate (and a pizza!)',
                style: TextStyle(color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
          )),
    ).then((val) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF6784),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 300.0,
              child: FlareActor(
                "assets/SkyBackground.flr",
                alignment: Alignment.center,
                fit: BoxFit.cover,
                controller: this,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    (!canAdvance)
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  current.gameText,
                                  style: TextStyle(
                                      fontSize: 22.0, fontFamily: 'Roboto'),
                                  softWrap: true,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
//                  Expanded(child: SizedBox()),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        canAdvance
                            ? AnimatedOpacity(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                                opacity: canAdvance ? 1.0 : 0.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40.0,
                                      width: 10.0,
                                    ),
                                    RaisedButton(
                                      color: Colors.blue,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          'Advance',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 28.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () => _moveState(),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 0.0,
                                width: 0.0,
                              ),
                      ],
                    ),
//                (doFaceRec == true)
//                    ? FaceWidget()
//                    : SizedBox(
//                        height: 0.0,
//                        width: 0.0,
//                      ),
                    (!canAdvance)
                        ? Wrap(
                            spacing: 10.0,
                            children: []..addAll(current.gameOptions
                                .map((k) => MaterialButton(
                                      color: Color(0xFF47A787),
                                      key: Key('key-option-${k}'),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          k,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22.0),
                                        ),
                                      ),
                                      onPressed: () => _selectOption(
                                          current.gameOptions.indexOf(k)),
                                    ))
                                .toList()
                                .cast<Widget>()))
                        : SizedBox(),
                    new SizedBox(
                      height: 40.0,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _selectOption(int v) {
    if (v == current.correct) {
      Completer completer = Completer();
      Timer timer = Timer(Duration(milliseconds: 500), () {
        if (!completer.isCompleted) {
          Navigator.pop(context);
          completer.complete(true);
        }
      });
      showDialog(
          context: context,
          builder: (context) => Dialog(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0)
                        .copyWith(top: 15.0, bottom: 15.0),
                    child: Text(
                      'Correct',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  color: Colors.lightGreen,
                ),
              )).then((val) {
        if (!completer.isCompleted) completer.complete(true);
      });

      this.setState(() => correct = true);
    } else {
      this.setState(() => correct = false);
      Completer completer = Completer();
      Timer timer = Timer(Duration(milliseconds: 300), () {
        if (!completer.isCompleted) {
          Navigator.pop(context);
          completer.complete(true);
        }
      });
      showDialog(
          context: context,
          builder: (context) => Dialog(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0)
                        .copyWith(top: 15.0, bottom: 15.0),
                    child: Text(
                      'False',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  color: Colors.redAccent,
                ),
              )).then((val) {
        if (!completer.isCompleted) completer.complete(true);
      });
    }
  }

  _moveState() {
    this.setState(() {
      correct = false;

      if (current.next == 'win') {
        win();
      } else {
        current = gameStates[current.next];
        zoom = current.zoom;
        expression = current.expression;
//        if (current.special == 'FaceRec') {
//          doFaceRec = true;
//        }
      }
    });
  }
}
