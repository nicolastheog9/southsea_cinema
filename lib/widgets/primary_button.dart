import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Size? minimumSize;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.minimumSize,
    this.padding,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: cinemaBrand,
        foregroundColor: cinemaFontWhite,
        minimumSize: minimumSize,
        padding: padding,
        shape: shape,
      ),
      child: Text(label),
    );
  }
}
