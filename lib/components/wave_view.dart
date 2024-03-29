import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:vector_math/vector_math.dart' as vector;
import 'package:your_hit_point/view_model/HP_notifier.dart';

class WaveView extends ConsumerStatefulWidget{
  final double percentageValue;

  const WaveView({
    Key? key,
    this.percentageValue = 100.0,
  }) : super(key: key);
  @override
  WaveViewState createState() => WaveViewState();
}

class WaveViewState extends ConsumerState<WaveView> with TickerProviderStateMixin {
  AnimationController? animationController;
  AnimationController? waveAnimationController;
  Offset bottleOffset1 = const Offset(0, 0);
  List<Offset> animList1 = [];
  Offset bottleOffset2 = const Offset(60, 0);
  List<Offset> animList2 = [];

  @override
  void initState() {
    animationController =
        AnimationController(duration: const Duration(seconds: 4), vsync: this);
    waveAnimationController =
        AnimationController(duration: const Duration(seconds: 4), vsync: this);
    animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController?.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController?.forward();
      }
    });
    waveAnimationController!.addListener(() {
      animList1.clear();
      for (int i = -2 - bottleOffset1.dx.toInt(); i <= 120 + 2; i++) {
        animList1.add(
          Offset(
            i.toDouble() + bottleOffset1.dx.toInt(),
            math.sin((waveAnimationController!.value * 360 - i) %
                        360 *
                        vector.degrees2Radians) *
                    4 +
                (((100 - widget.percentageValue) * 160 / 100)),
          ),
        );
      }
      animList2.clear();
      for (int i = -2 - bottleOffset2.dx.toInt(); i <= 60 + 2; i++) {
        animList2.add(
          Offset(
            i.toDouble() + bottleOffset2.dx.toInt(),
            math.sin((waveAnimationController!.value * 360 - i) %
                        360 *
                        vector.degrees2Radians) *
                    4 +
                (((100 - widget.percentageValue) * 160 / 100)),
          ),
        );
      }
    });
    waveAnimationController?.repeat();
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    if (animationController != null) {
      animationController?.dispose();
    }
    if (waveAnimationController != null) {
      waveAnimationController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barcolor = ref.watch(hpProvider).barColor;
    final fontposition = ref.watch(hpProvider).fontPosition;
    final fontColor = ref.watch(hpProvider).fontColor;

    return Container(
        alignment: Alignment.center,
        child: provider.Consumer(builder: (context, userDataProvider, child) {
          return Stack(
            children: <Widget>[
              AnimatedBuilder(
                  animation: CurvedAnimation(
                    parent: animationController!,
                    curve: Curves.easeInOut,
                  ),
                  builder: (context, child) => Stack(
                        children: <Widget>[
                          ClipPath(
                            clipper: WaveClipper(
                                animationController!.value, animList1),
                            child: Container(
                              decoration: BoxDecoration(
                                //引数
                                color: barcolor.withOpacity(0.5),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(80.0),
                                    bottomLeft: Radius.circular(80.0),
                                    bottomRight: Radius.circular(80.0),
                                    topRight: Radius.circular(80.0)),
                                gradient: LinearGradient(
                                  colors: [
                                    //引数
                                    barcolor.withOpacity(0.2),
                                    barcolor.withOpacity(0.5)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                          ClipPath(
                            clipper: WaveClipper(
                                animationController!.value, animList2),
                            child: Container(
                              decoration: BoxDecoration(
                                //引数
                                color: barcolor,
                                gradient: LinearGradient(
                                  colors: [
                                    //引数
                                    barcolor.withOpacity(0.4),
                                    barcolor
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(80.0),
                                    bottomLeft: Radius.circular(80.0),
                                    bottomRight: Radius.circular(80.0),
                                    topRight: Radius.circular(80.0)),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 6,
                            bottom: 8,
                            child: ScaleTransition(
                              alignment: Alignment.center,
                              scale: Tween(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController!,
                                      curve: const Interval(0.0, 1.0,
                                          curve: Curves.fastOutSlowIn))),
                              child: Container(
                                width: 2,
                                height: 2,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .cardColor
                                      .withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 24,
                            right: 0,
                            bottom: 16,
                            child: ScaleTransition(
                              alignment: Alignment.center,
                              scale: Tween(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController!,
                                      curve: const Interval(0.4, 1.0,
                                          curve: Curves.fastOutSlowIn))),
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .cardColor
                                      .withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 24,
                            bottom: 32,
                            child: ScaleTransition(
                              alignment: Alignment.center,
                              scale: Tween(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController!,
                                      curve: const Interval(0.6, 0.8,
                                          curve: Curves.fastOutSlowIn))),
                              child: Container(
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .cardColor
                                      .withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 20,
                            bottom: 0,
                            child: Transform(
                              transform: Matrix4.translationValues(0.0,
                                  16 * (1.0 - animationController!.value), 0.0),
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .cardColor
                                      .withOpacity(
                                          animationController!.status ==
                                                  AnimationStatus.reverse
                                              ? 0.0
                                              : 0.4),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
              Padding(
                //ここで%の高さを変更できる　引数で決める
                padding: EdgeInsets.only(top: fontposition),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.percentageValue.round().toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          letterSpacing: 0.0,
                          //引数
                          color: fontColor,
                          // color: Colors.black
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          "%",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              letterSpacing: 0.0,
                              //引数
                              color: fontColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Image(image: AssetImage("assets/images/bottle.png")),
            ],
          );
        }));
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}
