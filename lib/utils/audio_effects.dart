import "../providers/game.dart";

String getAudioEffectPath(AudioEffect audioEffect) {
  switch(audioEffect) {
    case AudioEffect.tap:
      return "assets/sounds/tap_effect.mp3";
    case AudioEffect.move:
      return "assets/sounds/move_effect.mp3";
    case AudioEffect.shake:
      return "assets/sounds/shake_effect.mp3";
    case AudioEffect.page:
      return "assets/sounds/page_effect.mp3";
    case AudioEffect.closeBook:
      return "assets/sounds/close_book_effect.mp3";
  }
}