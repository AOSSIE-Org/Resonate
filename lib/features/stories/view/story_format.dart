String formatPlayDuration(int milliseconds) {
  final totalSeconds = (milliseconds / 1000).round();
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return "$minutes:${seconds.toString().padLeft(2, '0')}";
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}
