String timeParse(int time) {
  String _time = "";

  if(time >= 3600) {
    _time = (time ~/ 3600).toString().padLeft(2, "0") + ":" + ((time % 3600) ~/ 60).toString().padLeft(2, "0") + ":" + ((time % 3600) % 60).toString().padLeft(2, "0");
  } else if(time >= 60) {
    _time = (time ~/ 60).toString().padLeft(2, "0") + ":" + (time % 60).toString().padLeft(2, "0");
  } else {
    _time = "00:" + time.toString().padLeft(2, "0");
  }

  return _time;
}