import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'title_text.dart';

/// Widget for displaying the application name with a shimmer effect.
class AppNameTextWidget extends StatelessWidget {
  /// Default constructor for [AppNameTextWidget].
  const AppNameTextWidget({Key? key, this.fontSize = 30}) : super(key: key);

  /// Font size for the application name text.
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    // Shimmer effect for a dynamic and animated color transition.
    return Shimmer.fromColors(
      period: const Duration(seconds: 16),
      baseColor: Colors.purple,
      highlightColor: Colors.red,
      child: TitlesTextWidget(
        label: "Shop Smart Admin",
        fontSize: fontSize,
      ),
    );
  }
}
