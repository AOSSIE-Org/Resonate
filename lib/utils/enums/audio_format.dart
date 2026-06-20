enum AudioFormat {
  wav,
  aiff,
  alac,
  flac,
  mp3,
  aac,
  wma,
  ogg;

  static List<String> get extensions => values.map((f) => f.name).toList();
}
