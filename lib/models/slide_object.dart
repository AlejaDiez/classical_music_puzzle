import 'dart:math';

class SlideObject {
  int index;
  Point correctPoint;
  Point currentPoint;
  Duration duration;
  String image;
  String audio;
  
  SlideObject({
    required this.index,
    required this.correctPoint,
    required this.currentPoint,
    this.duration = Duration.zero,
    required this.image,
    required this.audio
  });
}