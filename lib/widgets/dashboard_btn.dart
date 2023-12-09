import 'package:flutter/material.dart';
import 'package:e_com_app_admin/widgets/subtitle_text.dart';

/// Widget for displaying dashboard buttons.
class DashboardButtonsWidget extends StatelessWidget {
  /// Default constructor for [DashboardButtonsWidget].
  const DashboardButtonsWidget({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.onPressed,
  }) : super(key: key);

  /// Title of the dashboard button.
  final String title;

  /// Image path for the dashboard button.
  final String imagePath;

  /// Callback function to be executed when the button is pressed.
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 65,
              width: 65,
            ),
            const SizedBox(
              height: 15,
            ),
            SubtitleTextWidget(
              label: title,
              fontSize: 18,
            )
          ],
        ),
      ),
    );
  }
}
