import 'package:flutter/material.dart';

/// A widget for displaying subtitle text.
class SubtitleTextWidget extends StatelessWidget {
  /// Default constructor for [SubtitleTextWidget].
  const SubtitleTextWidget({
    Key? key,
    required this.label,
    this.fontSize = 18,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textDecoration = TextDecoration.none,
  }) : super(key: key);

  /// The text to be displayed.
  final String label;

  /// The font size of the text.
  final double fontSize;

  /// The font style of the text.
  final FontStyle fontStyle;

  /// The font weight of the text.
  final FontWeight? fontWeight;

  /// The color of the text.
  final Color? color;

  /// The decoration of the text.
  final TextDecoration textDecoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontStyle: fontStyle,
        decoration: textDecoration,
      ),
    );
  }
}
