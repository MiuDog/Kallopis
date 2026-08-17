import 'package:flutter/widgets.dart';

class CatalogPageData {
  const CatalogPageData({
    required this.label,
    required this.title,
    required this.description,
    required this.icon,
    required this.child,
  });

  final String label;
  final String title;
  final String description;
  final String icon;
  final Widget child;
}
