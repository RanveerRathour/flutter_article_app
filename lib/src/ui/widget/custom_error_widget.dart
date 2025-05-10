import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    required this.onButtonPressed,
    this.buttonText,
    this.padding,
    this.expandedButton = true,
    this.title,
    this.subtitle,
    this.subtitleButtonSpacing,
    this.showTryAgainButton = true,
    this.customAsset,
  });

  final VoidCallback onButtonPressed;
  final String? buttonText;
  final EdgeInsets? padding;
  final bool expandedButton;
  final bool showTryAgainButton;
  final Widget? customAsset;

  final String? title;
  final String? subtitle;
  final double? subtitleButtonSpacing;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding ?? const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: customAsset ?? Image.asset('assets/images/error.png', width: MediaQuery.of(context).size.width - 40, fit: BoxFit.cover),
          ),
          const SizedBox(height: 24),
          Text(
            title ?? 'Error Occured',
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle ?? 'Something went wrong!',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w400),
          ),
          if (showTryAgainButton) ...<Widget>[
            SizedBox(height: subtitleButtonSpacing ?? 28),
            OutlinedButton(onPressed: onButtonPressed, child: Text(buttonText ?? 'Try Again')),
          ],
        ],
      ),
    );
  }
}
