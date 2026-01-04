import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = !isLoading && !isDisabled;

    final ButtonStyle? buttonStyle =
        (backgroundColor == null && foregroundColor == null)
            ? null
            : ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
              );

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: text,
      hint: isLoading ? 'Loading' : null,
      excludeSemantics: true,
      child: SizedBox(
        width: width,
        height: height ?? 48,
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: isLoading
              ? Semantics(
                  label: 'Loading',
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                )
              : Text(text),
        ),
      ),
    );
  }
}
