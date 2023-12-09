import 'package:flutter/cupertino.dart';

/// A widget for displaying title text.
class TitlesTextWidget extends StatelessWidget {
  /// Default constructor for [TitlesTextWidget].
  const TitlesTextWidget({
    Key? key,
    required this.label,
    this.fontSize = 20,
    this.color,
    this.maxLines,
  }) : super(key: key);

  /// The text to be displayed.
  final String label;

  /// The font size of the text.
  final double fontSize;

  /// The color of the text.
  final Color? color;

  /// The maximum number of lines for the text.
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxLines,
      // textAlign: TextAlign.justify,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
