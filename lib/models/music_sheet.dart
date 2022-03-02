class MusicSheet {
	final String title;
	final String author;
  final int items;
	late final List<String> _images;
	late final List<String> _audios;
  
  List<String> get images => this._images;
  List<String> get audios => this._audios;

	MusicSheet({
    this.title = "",
    this.author = "",
    this.items = 0,
    String imagePath = "",
    String imageExtension = ".svg",
    String audioPath = "",
    String audioExtension = ".mp3"
  }) {
    _images = List.generate(items, (index) => "$imagePath$index$imageExtension");
    _audios = List.generate(items, (index) => "$audioPath$index$audioExtension");
  }
}