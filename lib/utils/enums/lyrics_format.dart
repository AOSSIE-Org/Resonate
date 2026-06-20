enum LyricsFormat {
  lrc,
  txt;

  static List<String> get extensions => values.map((f) => f.name).toList();
}
