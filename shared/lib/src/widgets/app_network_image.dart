import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String? url;
  final double? borderRadius;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppNetworkImage({
    Key? key,
    required this.url,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeholderWidget = placeholder ??
        Container(
          color: Colors.grey.shade100,
          alignment: Alignment.center,
          child: Icon(
            Icons.pets,
            size: 36,
            color: Colors.grey.shade400,
          ),
        );

    final error = errorWidget ??
        Container(
          color: Colors.grey.shade100,
          alignment: Alignment.center,
          child: Icon(
            Icons.broken_image_rounded,
            size: 32,
            color: Colors.grey.shade400,
          ),
        );

    if (url == null || url!.isEmpty) return placeholderWidget;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: Image.network(
        url!,
        fit: fit,
        errorBuilder: (_, __, ___) => error,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade100,
            alignment: Alignment.center,
            child: const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      ),
    );
  }
}
