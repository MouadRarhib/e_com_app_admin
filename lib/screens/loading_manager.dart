import 'package:flutter/material.dart';

class LoadingManager extends StatelessWidget {
  const LoadingManager({Key? key, required this.isLoading, required this.child})
      : super(key: key);

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The main child widget
        child,
        // Overlay widgets if isLoading is true
        if (isLoading) ...[
          // Semi-transparent background
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          // Centered CircularProgressIndicator
          const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}
